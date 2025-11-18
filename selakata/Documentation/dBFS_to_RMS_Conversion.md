# dBFS to RMS Conversion

## Overview
Backend bisa kirim nilai dalam 2 format:
1. **dBFS** (decibels Full Scale): Nilai negative, e.g., -15 dBFS
2. **RMS** (Root Mean Square): Nilai 0.0 - 1.0, e.g., 0.8

AudioEngineService otomatis detect dan convert ke format yang benar.

## Conversion Formula

### dBFS → RMS
```swift
RMS = 10^(dBFS / 20)

Contoh:
dBFS = -15
RMS = 10^(-15 / 20) = 10^(-0.75) = 0.178
```

### RMS → dBFS
```swift
dBFS = 20 * log10(RMS)

Contoh:
RMS = 0.8
dBFS = 20 * log10(0.8) = -1.94 dBFS
```

## Contoh Konversi

### Common dBFS Values

| dBFS | RMS | Volume Level | Keterangan |
|------|-----|--------------|------------|
| 0 dBFS | 1.0 | 100% | Maximum (clipping) |
| -3 dBFS | 0.708 | 70.8% | Very loud |
| -6 dBFS | 0.501 | 50.1% | Loud |
| -10 dBFS | 0.316 | 31.6% | Medium-loud |
| -12 dBFS | 0.251 | 25.1% | Medium |
| -15 dBFS | 0.178 | 17.8% | Medium-quiet |
| -18 dBFS | 0.126 | 12.6% | Quiet |
| -20 dBFS | 0.100 | 10.0% | Very quiet |
| -30 dBFS | 0.032 | 3.2% | Barely audible |
| -40 dBFS | 0.010 | 1.0% | Almost silent |

### Example Scenarios

#### Scenario 1: Easy Level
```
Backend sends:
mainRMS: -15 dBFS
noiseRMS: -30 dBFS

Converted to:
mainRMS: 0.178 (17.8%)
noiseRMS: 0.032 (3.2%)

SNR: -15 - (-30) = 15 dB (good)
Result: Main audio jelas, noise minimal
```

#### Scenario 2: Medium Level
```
Backend sends:
mainRMS: -18 dBFS
noiseRMS: -24 dBFS

Converted to:
mainRMS: 0.126 (12.6%)
noiseRMS: 0.063 (6.3%)

SNR: -18 - (-24) = 6 dB (moderate)
Result: Main audio cukup jelas, noise moderate
```

#### Scenario 3: Hard Level
```
Backend sends:
mainRMS: -20 dBFS
noiseRMS: -20 dBFS

Converted to:
mainRMS: 0.100 (10.0%)
noiseRMS: 0.100 (10.0%)

SNR: -20 - (-20) = 0 dB (equal)
Result: Main audio dan noise sama keras
```

## Implementation

### Auto-Detection
```swift
private func convertToRMS(_ value: Double) -> Double {
    if value < 0 {
        // Input is dBFS (negative)
        let rms = pow(10.0, value / 20.0)
        return rms
    } else if value > 0 && value <= 1.0 {
        // Input is already RMS
        return value
    } else {
        // Invalid or zero
        return 0.0
    }
}
```

### Usage
```swift
// Backend sends -15 dBFS
loadMainAudio(url: audioURL, targetRMS: -15)

// Auto-converted to:
// actualTargetRMS = 0.178

// Then normalized to that RMS level
```

## Log Output

### When Backend Sends dBFS
```
🎵 loadMainAudio called with input value: -15.0
   Input value: -15.0
   Converting dBFS to RMS: -15.0 dBFS → 0.178 RMS
   Converted to RMS: 0.178
🔄 Normalizing main audio to target RMS: 0.178
📊 Audio Analysis:
   Current RMS: 0.5 (-6.02 dBFS)
   Target RMS: 0.178 (-15.0 dBFS)
   Gain needed: -8.98 dB
   Linear gain: 0.356
✅ Audio normalized successfully
```

### When Backend Sends RMS
```
🎵 loadMainAudio called with input value: 0.8
   Input value: 0.8
   Input is already RMS: 0.8
   Converted to RMS: 0.8
🔄 Normalizing main audio to target RMS: 0.8
📊 Audio Analysis:
   Current RMS: 0.5 (-6.02 dBFS)
   Target RMS: 0.8 (-1.94 dBFS)
   Gain needed: 4.08 dB
   Linear gain: 1.6
✅ Audio normalized successfully
```

## Backend Recommendations

### Option 1: Send dBFS (Recommended)
```json
{
  "mainRMS": -15,
  "noiseRMS": -30
}
```

**Advantages:**
- Industry standard
- Easy to understand (0 dBFS = max)
- Clear SNR calculation
- Matches audio engineering tools

### Option 2: Send RMS
```json
{
  "mainRMS": 0.8,
  "noiseRMS": 0.2
}
```

**Advantages:**
- Direct amplitude value
- No conversion needed
- Simpler for non-audio engineers

### Recommended dBFS Ranges

#### Main Audio
- **Easy**: -12 to -15 dBFS (clear, loud)
- **Medium**: -15 to -18 dBFS (moderate)
- **Hard**: -18 to -24 dBFS (quiet)

#### Noise Audio
- **Easy**: -30 to -40 dBFS (minimal)
- **Medium**: -24 to -30 dBFS (moderate)
- **Hard**: -18 to -24 dBFS (loud)

#### SNR Guidelines
- **Easy**: SNR > 12 dB
- **Medium**: SNR 6-12 dB
- **Hard**: SNR 0-6 dB
- **Very Hard**: SNR < 0 dB (noise louder than signal)

## Testing

### Test with dBFS Values
```swift
// Di QuizView.swift:
SimpleAudioPlayer(
    fileName: viewModel.audioFileName,
    noiseFileName: viewModel.noiseFileName,
    mainRMS: -15,  // dBFS
    noiseRMS: -30   // dBFS
)
```

### Test with RMS Values
```swift
SimpleAudioPlayer(
    fileName: viewModel.audioFileName,
    noiseFileName: viewModel.noiseFileName,
    mainRMS: 0.8,  // RMS
    noiseRMS: 0.2   // RMS
)
```

### Expected Results
Both should work correctly with auto-conversion.

## Troubleshooting

### Issue: Audio too quiet
**Symptom:** Audio barely audible

**Possible Causes:**
- dBFS value too low (e.g., -40 dBFS)
- Converted RMS too small (< 0.05)

**Solution:**
- Increase dBFS value (closer to 0)
- Recommended: -12 to -20 dBFS for main audio

### Issue: Audio too loud/clipping
**Symptom:** Audio distorted

**Possible Causes:**
- dBFS value too high (e.g., -3 dBFS)
- Converted RMS too large (> 0.9)

**Solution:**
- Decrease dBFS value (further from 0)
- Recommended: < -6 dBFS to avoid clipping

### Issue: Wrong conversion
**Symptom:** Audio volume not as expected

**Check Log:**
```
Converting dBFS to RMS: -15.0 dBFS → 0.178 RMS
```

**Verify:**
- Input value is negative for dBFS
- Converted RMS is between 0.0 and 1.0
- Gain calculation is correct

## Reference

### Quick Conversion Table

| dBFS | RMS | % |
|------|-----|---|
| 0 | 1.000 | 100% |
| -1 | 0.891 | 89% |
| -2 | 0.794 | 79% |
| -3 | 0.708 | 71% |
| -4 | 0.631 | 63% |
| -5 | 0.562 | 56% |
| -6 | 0.501 | 50% |
| -7 | 0.447 | 45% |
| -8 | 0.398 | 40% |
| -9 | 0.355 | 36% |
| -10 | 0.316 | 32% |
| -12 | 0.251 | 25% |
| -15 | 0.178 | 18% |
| -18 | 0.126 | 13% |
| -20 | 0.100 | 10% |
| -24 | 0.063 | 6% |
| -30 | 0.032 | 3% |
| -40 | 0.010 | 1% |

### Calculator
```swift
// dBFS to RMS
let rms = pow(10.0, dBFS / 20.0)

// RMS to dBFS
let dBFS = 20 * log10(rms)
```
