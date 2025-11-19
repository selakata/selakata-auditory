# RMS Implementation for Audio Playback

## Overview
Implementasi RMS (Root Mean Square) untuk **normalize audio** di QuizView sebelum playback, mengikuti standar yang sama dengan SoundLevel.swift `exportAudioWithTargetdBFS`.

**Perbedaan dengan implementasi sebelumnya:**
- ❌ **Sebelumnya**: Hanya adjust volume player (tidak akurat)
- ✅ **Sekarang**: Generate audio baru dengan RMS yang sudah di-normalize (akurat)

## Cara Kerja

### 1. Audio Normalization Process

```swift
// Flow:
Original Audio → Analyze RMS → Calculate Gain → Apply Gain → Normalized Audio → Play

// Detail:
1. Read audio file dan calculate current RMS
2. Convert RMS to dBFS: dBFS = 20 * log10(RMS)
3. Calculate gain needed: gainNeeded = targetdBFS - currentdBFS
4. Convert to linear gain: linearGain = pow(10, gainNeeded / 20)
5. Apply gain to all samples: sample *= linearGain
6. Prevent clipping: sample = clamp(sample, -1.0, 1.0)
7. Save as new audio file
8. Play normalized audio at full volume (1.0)
```

### 2. Implementation in AudioEngineService

```swift
func loadMainAudio(url: URL, targetRMS: Double = 0.0) {
    if targetRMS > 0.0 {
        // Normalize audio to target RMS
        if let normalizedURL = normalizeAudio(sourceURL: url, targetRMS: targetRMS) {
            mainPlayer = try AVAudioPlayer(contentsOf: normalizedURL)
        }
    }
    mainPlayer?.volume = 1.0  // Full volume, audio already normalized
}

private func normalizeAudio(sourceURL: URL, targetRMS: Double) -> URL? {
    // 1. Read audio and calculate current RMS
    let currentRMS = sqrt(sumOfSquares / totalSamples)
    
    // 2. Calculate gain
    let currentdBFS = 20 * log10(currentRMS)
    let targetdBFS = 20 * log10(targetRMS)
    let gainNeeded = targetdBFS - currentdBFS
    let linearGain = pow(10.0, gainNeeded / 20.0)
    
    // 3. Apply gain to samples
    for sample in samples {
        sample *= linearGain
        sample = clamp(sample, -1.0, 1.0)  // Prevent clipping
    }
    
    // 4. Save and return normalized audio
    return normalizedAudioURL
}
```

## Flow Data

```
Backend API
    ↓
Question Entity (mainRMS: 0.8, noiseRMS: 0.2)
    ↓
QuizViewModel (currentQuestion)
    ↓
QuizView (pass RMS values)
    ↓
SimpleAudioPlayer (mainRMS, noiseRMS)
    ↓
AudioEngineService.loadMainAudio(url, targetRMS: 0.8)
    ↓
normalizeAudio() → Generate new audio file
    ↓
Original Audio (RMS: 0.5) + Gain (1.6x) = Normalized Audio (RMS: 0.8)
    ↓
AVAudioPlayer plays normalized audio at volume 1.0
    ↓
iPhone Speaker 🔊 (audio dengan RMS yang tepat)
```

## Contoh Perhitungan

### Example 1: Boost Audio
```
Original Audio RMS: 0.5
Target RMS: 0.8

Current dBFS = 20 * log10(0.5) = -6.02 dBFS
Target dBFS = 20 * log10(0.8) = -1.94 dBFS
Gain needed = -1.94 - (-6.02) = 4.08 dB
Linear gain = pow(10, 4.08 / 20) = 1.6x

Result: Audio akan di-boost 1.6x lebih keras
```

### Example 2: Reduce Audio
```
Original Audio RMS: 0.9
Target RMS: 0.6

Current dBFS = 20 * log10(0.9) = -0.92 dBFS
Target dBFS = 20 * log10(0.6) = -4.44 dBFS
Gain needed = -4.44 - (-0.92) = -3.52 dB
Linear gain = pow(10, -3.52 / 20) = 0.67x

Result: Audio akan di-reduce 0.67x lebih pelan
```

## Keuntungan Implementasi Ini

### 1. Akurasi Tinggi
- Audio benar-benar di-normalize ke target RMS
- Tidak bergantung pada volume player
- Konsisten di semua device

### 2. Kontrol Presisi dari Backend
- Backend bisa set exact RMS value
- SNR (Signal-to-Noise Ratio) terkontrol dengan baik
- Difficulty level yang konsisten

### 3. Audible di Semua Device
- Audio sudah di-normalize sebelum play
- Tidak terpengaruh volume system
- Konsisten di iPhone, iPad, dll

### 4. Prevent Clipping
- Samples di-clamp antara -1.0 dan 1.0
- Tidak ada distorsi
- Audio quality terjaga

## File Management

### Temporary Files
Normalized audio disimpan di temporary directory:
```swift
let tempDir = FileManager.default.temporaryDirectory
let outputURL = tempDir.appendingPathComponent("normalized_main_\(UUID()).wav")
```

**Cleanup:**
- iOS automatically cleans temp directory
- Files dihapus saat app restart
- Tidak memakan storage permanent

### Cache Strategy
- Original audio: Cached by AudioCacheService
- Normalized audio: Generated on-demand, stored in temp
- Trade-off: CPU time vs Storage space

## Debug Output

Saat audio di-load dan normalize, akan muncul log:
```
🔄 Normalizing main audio to target RMS: 0.8
📊 Audio Analysis:
   Current RMS: 0.5 (-6.02 dBFS)
   Target RMS: 0.8 (-1.94 dBFS)
   Gain needed: 4.08 dB
   Linear gain: 1.6
✅ Audio normalized successfully: normalized_main_xxx.wav
✅ Main audio normalized and loaded
📊 Duration: 5.0s
🎵 Main audio play called - success: true, volume: 1.0
```

## Typical RMS Values

| Scenario | Main RMS | Noise RMS | SNR | Keterangan |
|----------|----------|-----------|-----|------------|
| Easy | 0.8 | 0.1 | ~18 dB | Suara jelas, noise minimal |
| Medium | 0.7 | 0.3 | ~7 dB | Suara cukup jelas |
| Hard | 0.6 | 0.5 | ~2 dB | Suara dan noise seimbang |
| Very Hard | 0.5 | 0.6 | ~-2 dB | Noise lebih keras dari suara |

### SNR Calculation
```swift
SNR (dB) = 20 * log10(mainRMS / noiseRMS)

Example:
mainRMS = 0.8, noiseRMS = 0.2
SNR = 20 * log10(0.8 / 0.2) = 20 * log10(4) ≈ 12 dB
```

## Troubleshooting

### Audio terlalu pelan
- Cek nilai RMS di backend (harus > 0.3 untuk audible)
- Cek log untuk melihat gain yang di-apply
- Cek original audio RMS

### Audio terlalu keras/clipping
- Cek nilai RMS tidak melebihi 0.9
- Reduce RMS value di backend
- Check log untuk "Prevent clipping" warnings

### Normalization failed
- Cek audio file format (harus supported by AVAudioFile)
- Cek file permissions
- Fallback ke original audio akan digunakan

### Performance issues
- Normalization dilakukan saat load (one-time cost)
- Untuk audio panjang, mungkin ada delay
- Consider pre-processing di backend untuk production

## Comparison dengan SoundLevel.swift

| Feature | SoundLevel.swift | AudioEngineService |
|---------|------------------|-------------------|
| RMS Calculation | ✅ Same formula | ✅ Same formula |
| dBFS Conversion | ✅ 20 * log10(RMS) | ✅ 20 * log10(RMS) |
| Gain Calculation | ✅ pow(10, gain/20) | ✅ pow(10, gain/20) |
| Clipping Prevention | ✅ clamp(-1, 1) | ✅ clamp(-1, 1) |
| Output Format | WAV 32-bit float | WAV 32-bit float |
| Use Case | Export to file | Real-time playback |

## Referensi

- **SoundLevel.swift**: `exportAudioWithTargetdBFS()` function
- **DualAudioPlayback.md**: Dokumentasi dual audio playback system
- **Question.swift**: Entity definition dengan mainRMS dan noiseRMS
