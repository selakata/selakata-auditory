# Debug Checklist - Audio Tidak Kedengeran

## Langkah-langkah Debug

### 1. Cek Log di Xcode Console

Jalankan app dan perhatikan log. Kamu harus lihat urutan seperti ini:

#### ✅ SCENARIO BENAR (RMS dari backend ada):
```
📊 Question RMS - Main: 0.8, Noise: 0.2
🎵 Loading audio: [filename]
📊 Main RMS: 0.8, Noise RMS: 0.2
✅ Main audio URL resolved: [url]
🎵 loadMainAudio called with targetRMS: 0.8
🔄 Normalizing main audio to target RMS: 0.8
📊 Audio Analysis:
   Current RMS: 0.5 (-6.02 dBFS)
   Target RMS: 0.8 (-1.94 dBFS)
   Gain needed: 4.08 dB
   Linear gain: 1.6
✅ Audio normalized successfully: normalized_main_xxx.wav
✅ Main audio normalized and loaded from: normalized_main_xxx.wav
✅ Main audio loaded successfully
   Duration: 5.0s
   Volume: 1.0
🎵 Main audio play called
   Success: true
   Volume: 1.0
   Duration: 5.0s
   Is Playing: true
   Current Time: 0.0s
```

#### ❌ SCENARIO SALAH (RMS = 0):
```
📊 Question RMS - Main: 0.0, Noise: 0.0  ← MASALAH!
🎵 Loading audio: [filename]
📊 Main RMS: 0.0, Noise RMS: 0.0  ← MASALAH!
✅ Main audio URL resolved: [url]
🎵 loadMainAudio called with targetRMS: 0.0  ← MASALAH!
⚠️ WARNING: No RMS specified (targetRMS = 0.0), using original audio at full volume
✅ Main audio loaded successfully
   Duration: 5.0s
   Volume: 1.0
🎵 Main audio play called
   Success: true
   Volume: 1.0
   Duration: 5.0s
   Is Playing: true
   Current Time: 0.0s
```

### 2. Identifikasi Masalah

#### Masalah A: RMS = 0.0
**Symptom:**
```
📊 Question RMS - Main: 0.0, Noise: 0.0
⚠️ WARNING: No RMS specified
```

**Penyebab:**
- Backend belum kirim nilai RMS
- JSON field name salah
- Parsing error

**Solution:**
1. Cek response JSON dari backend
2. Pastikan field: `mainRMS` dan `noiseRMS` ada
3. Test dengan hardcode:

```swift
// Di QuizView.swift, temporary:
SimpleAudioPlayer(
    fileName: viewModel.audioFileName,
    noiseFileName: viewModel.noiseFileName,
    mainRMS: 0.8,  // ← HARDCODE untuk test
    noiseRMS: 0.2   // ← HARDCODE untuk test
)
```

#### Masalah B: Normalization Failed
**Symptom:**
```
🔄 Normalizing main audio to target RMS: 0.8
❌ Error normalizing audio: [error message]
⚠️ Normalization failed, using original audio
```

**Penyebab:**
- Audio file format tidak supported
- File corrupted
- Memory issue

**Solution:**
- Cek audio file format (MP3/WAV/M4A)
- Cek file size
- Original audio akan digunakan sebagai fallback

#### Masalah C: Audio Play Failed
**Symptom:**
```
🎵 Main audio play called
   Success: false  ← MASALAH!
   Is Playing: false  ← MASALAH!
```

**Penyebab:**
- Audio session issue
- File tidak ter-load
- Permission issue

**Solution:**
- Restart app
- Cek audio session category
- Cek file permissions

#### Masalah D: Volume iPhone
**Symptom:**
- Log menunjukkan semua OK
- `Is Playing: true`
- Tapi tidak kedengeran

**Penyebab:**
- Volume iPhone terlalu kecil
- Silent mode aktif
- Bluetooth/AirPods connected

**Solution:**
1. Cek volume iPhone (harus > 50%)
2. Matikan silent mode (switch di samping iPhone)
3. Disconnect Bluetooth devices
4. Test dengan headphone

### 3. Quick Test dengan Hardcode

Untuk memastikan sistem bekerja, test dengan hardcode RMS:

```swift
// Di QuizView.swift, line ~120:
SimpleAudioPlayer(
    fileName: viewModel.audioFileName,
    noiseFileName: viewModel.noiseFileName,
    mainRMS: 0.8,  // ← HARDCODE
    noiseRMS: 0.2,  // ← HARDCODE
    onAudioCompleted: { ... }
)
```

**Expected result:**
- Audio harus kedengeran dengan jelas
- Log menunjukkan normalization process
- Volume konsisten

### 4. Test Berbagai Nilai RMS

Test dengan nilai berbeda untuk verify:

#### Test 1: RMS Tinggi (Loud)
```swift
mainRMS: 0.9, noiseRMS: 0.1
```
Expected: Audio sangat jelas, noise minimal

#### Test 2: RMS Medium (Normal)
```swift
mainRMS: 0.7, noiseRMS: 0.3
```
Expected: Audio jelas, noise moderate

#### Test 3: RMS Rendah (Quiet)
```swift
mainRMS: 0.4, noiseRMS: 0.2
```
Expected: Audio agak pelan tapi masih kedengeran

#### Test 4: RMS = 0 (No Normalization)
```swift
mainRMS: 0.0, noiseRMS: 0.0
```
Expected: Audio original tanpa normalization

### 5. Verify Backend Response

Cek JSON response dari backend:

```json
{
  "id": "xxx",
  "text": "Question text",
  "mainRMS": 0.8,  ← Harus ada dan > 0
  "noiseRMS": 0.2,  ← Harus ada dan > 0
  "audioFile": {
    "fileURL": "https://..."
  },
  "noiseFile": {
    "fileURL": "https://..."
  }
}
```

**Cek:**
- [ ] Field `mainRMS` ada
- [ ] Field `noiseRMS` ada
- [ ] Nilai bukan string (harus number)
- [ ] Nilai > 0.0
- [ ] Nilai <= 1.0

### 6. Common Mistakes

#### Mistake 1: RMS sebagai String
```json
❌ "mainRMS": "0.8"  // String
✅ "mainRMS": 0.8    // Number
```

#### Mistake 2: RMS dalam dBFS
```json
❌ "mainRMS": -20.0  // dBFS (negative)
✅ "mainRMS": 0.8    // RMS (0-1)
```

#### Mistake 3: Field Name Salah
```json
❌ "main_rms": 0.8   // Snake case
✅ "mainRMS": 0.8    // Camel case
```

### 7. Emergency Fallback

Jika masih tidak kedengeran, gunakan fallback tanpa normalization:

```swift
// Di AudioEngineService.swift, loadMainAudio:
func loadMainAudio(url: URL, targetRMS: Double = 0.0) {
    do {
        // TEMPORARY: Skip normalization
        mainPlayer = try AVAudioPlayer(contentsOf: url)
        mainPlayer?.delegate = self
        mainPlayer?.prepareToPlay()
        mainPlayer?.volume = 1.0
        print("✅ Using original audio (normalization disabled)")
    } catch {
        print("❌ Error: \(error)")
    }
}
```

### 8. Final Checklist

Sebelum conclude masalah:

- [ ] Log menunjukkan RMS value dari backend
- [ ] Log menunjukkan normalization process
- [ ] Log menunjukkan `Success: true` dan `Is Playing: true`
- [ ] Volume iPhone > 50%
- [ ] Silent mode OFF
- [ ] Bluetooth disconnected
- [ ] Test dengan headphone
- [ ] Test dengan hardcode RMS
- [ ] Test dengan audio file berbeda
- [ ] Restart app
- [ ] Restart iPhone

### 9. Report Template

Jika masih tidak work, report dengan format ini:

```
**Log Output:**
[paste log dari console]

**Backend Response:**
[paste JSON response]

**Device Info:**
- iPhone model: 
- iOS version:
- Volume level:
- Silent mode: ON/OFF

**Test Results:**
- Hardcode RMS: WORK / NOT WORK
- Original audio (RMS=0): WORK / NOT WORK
- Different audio file: WORK / NOT WORK
```
