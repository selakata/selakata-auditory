# RMS Testing Guide

## Quick Test Checklist

### 1. Cek Log di Xcode Console

Saat audio di-load, kamu harus lihat log seperti ini:

```
🎵 Loading audio: [filename]
📊 Main RMS: 0.8, Noise RMS: 0.2
✅ Main audio URL resolved: [url]
🔄 Normalizing main audio to target RMS: 0.8
📊 Audio Analysis:
   Current RMS: 0.5 (-6.02 dBFS)
   Target RMS: 0.8 (-1.94 dBFS)
   Gain needed: 4.08 dB
   Linear gain: 1.6
✅ Audio normalized successfully: normalized_main_xxx.wav
✅ Main audio normalized and loaded
📊 Duration: 5.0s
```

### 2. Verifikasi Nilai RMS dari Backend

**Jika RMS = 0.0:**
```
📊 Main RMS: 0.0, Noise RMS: 0.0
ℹ️ No RMS specified, using original audio
```
→ **Masalah**: Backend belum kirim nilai RMS, audio pakai original tanpa normalisasi

**Jika RMS > 0.0:**
```
📊 Main RMS: 0.8, Noise RMS: 0.2
🔄 Normalizing main audio to target RMS: 0.8
```
→ **Bagus**: RMS diterima dan audio akan di-normalize

### 3. Test Flow Data

#### Step 1: Cek Question dari Backend
```swift
// Di QuizViewModel.swift, tambahkan log:
print("📊 Question RMS - Main: \(currentQuestion.mainRMS), Noise: \(currentQuestion.noiseRMS)")
```

#### Step 2: Cek di QuizView
```swift
// Di QuizView.swift, SimpleAudioPlayer call:
SimpleAudioPlayer(
    fileName: viewModel.audioFileName,
    noiseFileName: viewModel.noiseFileName,
    mainRMS: viewModel.currentQuestion.mainRMS,  // ← Cek ini
    noiseRMS: viewModel.currentQuestion.noiseRMS  // ← Cek ini
)
```

#### Step 3: Cek di SimpleAudioPlayer
```swift
// Di loadAudio(), akan print:
print("📊 Main RMS: \(mainRMS), Noise RMS: \(noiseRMS)")
```

#### Step 4: Cek di AudioEngineService
```swift
// Di loadMainAudio(), akan print:
print("🔄 Normalizing main audio to target RMS: \(targetRMS)")
```

### 4. Common Issues & Solutions

#### Issue 1: RMS selalu 0.0
**Symptom:**
```
📊 Main RMS: 0.0, Noise RMS: 0.0
ℹ️ No RMS specified, using original audio
```

**Penyebab:**
- Backend belum kirim nilai RMS
- JSON parsing error
- Field name tidak match

**Solution:**
1. Cek response JSON dari backend
2. Pastikan field name: `mainRMS` dan `noiseRMS` (case-sensitive)
3. Pastikan tipe data: `Double` bukan `String`

**Test dengan hardcode:**
```swift
// Di QuizView.swift, temporary test:
SimpleAudioPlayer(
    fileName: viewModel.audioFileName,
    noiseFileName: viewModel.noiseFileName,
    mainRMS: 0.8,  // ← Hardcode untuk test
    noiseRMS: 0.2   // ← Hardcode untuk test
)
```

#### Issue 2: Audio tidak kedengeran
**Symptom:**
- Audio play tapi tidak ada suara
- Log menunjukkan success: true

**Penyebab:**
- Volume iPhone terlalu kecil
- Silent mode aktif
- Audio session issue

**Solution:**
1. Cek volume iPhone (harus > 50%)
2. Matikan silent mode
3. Cek log untuk error audio session

#### Issue 3: Normalization failed
**Symptom:**
```
❌ Error normalizing audio: [error]
⚠️ Normalization failed, using original audio
```

**Penyebab:**
- Audio format tidak supported
- File corrupted
- Insufficient memory

**Solution:**
1. Cek audio file format (harus MP3/WAV/M4A)
2. Cek file size (jangan terlalu besar)
3. Fallback ke original audio akan digunakan

#### Issue 4: Audio terlalu pelan/keras
**Symptom:**
- Audio kedengeran tapi volume tidak sesuai

**Penyebab:**
- Nilai RMS dari backend tidak tepat
- Original audio RMS terlalu berbeda

**Solution:**
1. Cek log "Audio Analysis" untuk lihat gain yang di-apply
2. Adjust nilai RMS di backend
3. Typical values: mainRMS 0.6-0.8, noiseRMS 0.1-0.3

### 5. Manual Testing Steps

#### Test 1: Tanpa RMS (Default)
1. Set mainRMS = 0.0, noiseRMS = 0.0 di backend
2. Play audio
3. Expected: Audio play dengan volume original

#### Test 2: Dengan RMS Normal
1. Set mainRMS = 0.8, noiseRMS = 0.2 di backend
2. Play audio
3. Expected: Audio di-normalize dan kedengeran jelas

#### Test 3: RMS Ekstrem
1. Set mainRMS = 0.3, noiseRMS = 0.7 di backend
2. Play audio
3. Expected: Main audio pelan, noise keras (hard difficulty)

### 6. Debug Commands

#### Print semua nilai RMS di chain:
```swift
// Di QuizViewModel.swift
print("1️⃣ ViewModel - Main: \(currentQuestion.mainRMS), Noise: \(currentQuestion.noiseRMS)")

// Di QuizView.swift
print("2️⃣ QuizView - Main: \(viewModel.currentQuestion.mainRMS), Noise: \(viewModel.currentQuestion.noiseRMS)")

// Di SimpleAudioPlayer.swift
print("3️⃣ AudioPlayer - Main: \(mainRMS), Noise: \(noiseRMS)")

// Di AudioEngineService.swift
print("4️⃣ Engine - Target: \(targetRMS)")
```

#### Verify audio normalization:
```swift
// Di normalizeAudio(), cek output:
print("Current RMS: \(currentRMS)")
print("Target RMS: \(targetRMS)")
print("Gain: \(linearGain)x")
```

### 7. Expected Results

#### Scenario: Easy Level
```
Backend: mainRMS = 0.8, noiseRMS = 0.1
Result: 
- Main audio jelas (80% amplitude)
- Noise minimal (10% amplitude)
- SNR ≈ 18 dB
- User mudah mendengar
```

#### Scenario: Medium Level
```
Backend: mainRMS = 0.7, noiseRMS = 0.3
Result:
- Main audio cukup jelas (70% amplitude)
- Noise moderate (30% amplitude)
- SNR ≈ 7 dB
- User perlu fokus
```

#### Scenario: Hard Level
```
Backend: mainRMS = 0.6, noiseRMS = 0.5
Result:
- Main audio agak pelan (60% amplitude)
- Noise cukup keras (50% amplitude)
- SNR ≈ 2 dB
- User harus konsentrasi tinggi
```

### 8. Performance Check

#### Memory Usage
- Normalization process: ~10-20 MB per audio
- Temporary files: Auto-cleaned by iOS
- No memory leak expected

#### Processing Time
- Short audio (< 10s): < 0.5s
- Medium audio (10-30s): 0.5-2s
- Long audio (> 30s): 2-5s

#### Battery Impact
- Minimal (one-time processing per question)
- No continuous processing
- Efficient algorithm

### 9. Production Checklist

Before deploying:
- [ ] Test dengan berbagai nilai RMS (0.1 - 0.9)
- [ ] Test dengan audio berbeda format (MP3, WAV, M4A)
- [ ] Test dengan audio berbeda durasi (1s - 60s)
- [ ] Test di berbagai device (iPhone, iPad)
- [ ] Test dengan network slow (streaming audio)
- [ ] Verify tidak ada memory leak
- [ ] Verify temporary files di-cleanup
- [ ] Test error handling (invalid RMS, corrupted audio)

### 10. Rollback Plan

Jika ada masalah di production:

**Option 1: Disable normalization**
```swift
// Di AudioEngineService.swift, comment out normalization:
func loadMainAudio(url: URL, targetRMS: Double = 0.0) {
    // Skip normalization, use original
    mainPlayer = try AVAudioPlayer(contentsOf: url)
    mainPlayer?.volume = 1.0
}
```

**Option 2: Use volume-based approach**
```swift
// Fallback ke adjust volume player saja:
mainPlayer?.volume = Float(targetRMS)
```

**Option 3: Backend flag**
```swift
// Tambahkan flag di Question:
if question.useRMSNormalization {
    // Use new normalization
} else {
    // Use old approach
}
```
