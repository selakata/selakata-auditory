# Dual Audio Playback for Quiz

## Overview
Quiz sekarang support simultaneous playback dari main audio dan noise audio untuk simulate real-world listening conditions dengan background noise.

## Features

### 1. Dual Audio Playback
- Main audio (question/speech)
- Noise audio (background noise)
- Play simultaneously untuk simulate SNR (Signal-to-Noise Ratio)

### 2. Early Answer Display
- Soal muncul **1 detik sebelum audio selesai**
- User bisa mulai baca jawaban sambil audio masih playing
- Mengurangi waiting time
- Lebih natural flow

## Implementation

### SimpleAudioPlayer
```swift
// Dual audio player
@StateObject private var audioPlayer = AudioPlayerService()  // Main audio
@StateObject private var noisePlayer = AudioPlayerService()  // Noise audio

// Initialize with noise
SimpleAudioPlayer(
    title: "Question",
    fileName: "main-audio.mp3",
    noiseFileName: "noise-audio.mp3"  // Optional
)
```

### Play Control
```swift
// Play both simultaneously
audioPlayer.play()
if noiseFileName != nil {
    noisePlayer.play()
}

// Pause both
audioPlayer.pause()
noisePlayer.pause()

// Stop both
audioPlayer.stop()
noisePlayer.stop()
```

### Completion Timing
```swift
// Show answers 1 second before audio ends
let timeBeforeEnd = 1.0

if audioPlayer.currentTime >= audioPlayer.duration - timeBeforeEnd {
    onAudioCompleted?()  // Trigger answer display
}
```

## Data Structure

### Question Entity
```swift
struct Question {
    let audioFile: AudioFile?      // Main audio
    let noiseFile: AudioFile?      // Noise audio (optional)
    let mainRMS: Double            // Main audio volume
    let noiseRMS: Double           // Noise audio volume
    let snr: Double?               // Signal-to-Noise Ratio
}
```

### Audio Download
Both main and noise audio are downloaded and cached:
```swift
var audioURLs: [String] = []

for question in questions {
    if let mainAudioURL = question.audioFile?.fileURL {
        audioURLs.append(mainAudioURL)
    }
    if let noiseAudioURL = question.noiseFile?.fileURL {
        audioURLs.append(noiseAudioURL)
    }
}
```

## User Experience

### Without Noise
```
Play → Main audio only → Show answers (1s before end)
```

### With Noise (Sequence)
```
Play → Noise starts (1s) → Main audio starts + Noise continues → 
Main audio ends → Noise continues (1s) → Noise stops

Timeline:
[Noise 1s] → [Main Audio + Noise] → [Noise 1s]
```

### Timeline Example
```
-1s ──────────────────────────────────────── 6s
│                                             │
│   ├─ Play main audio (5s) ────────────┤   │
├───┼───────────────────────────────────┼───┤
│   Noise starts                  Noise ends │
│   (1s before)                   (1s after) │
│                                       ↑     │
│                                 Show answers│
│                                 (at 4s)     │
└─────────────────────────────────────────────┘

Sequence:
0s:  Noise starts 🔊
1s:  Main audio starts 🎵 (noise continues)
4s:  Answers appear ✨ (1s before main ends)
5s:  Main audio ends (noise continues)
6s:  Noise ends 🔇
```

## Benefits

### 1. Realistic Training
- Simulate real-world listening conditions
- Train auditory processing with background noise
- Improve speech-in-noise comprehension

### 2. Better UX
- No waiting for audio to completely finish
- Answers appear while audio still playing
- More engaging and faster flow
- Reduced perceived waiting time

### 3. Flexible SNR Control
- Backend can control SNR via `mainRMS` and `noiseRMS`
- Different difficulty levels
- Adaptive training

## Configuration

### Timing Adjustment
Change when answers appear:
```swift
// In SimpleAudioPlayer.swift
let timeBeforeEnd = 1.0  // Show 1 second before end

// Options:
// 0.5 = Very close to end
// 1.0 = Balanced (recommended)
// 1.5 = More time to read
// 2.0 = Very early
```

### Volume Control
Controlled by backend via RMS values:
- `mainRMS`: Main audio volume
- `noiseRMS`: Noise audio volume
- `snr`: Signal-to-Noise Ratio

## Technical Details

### Audio Synchronization
- Both audio players start simultaneously
- No explicit sync needed (iOS handles it)
- If one audio is shorter, it stops naturally

### Cache Strategy
- Both main and noise audio are cached
- Downloaded together during quiz loading
- Smooth playback without buffering

### Error Handling
- If noise audio fails to load, main audio still plays
- Graceful degradation
- No blocking errors

## Future Enhancements

- [ ] Volume mixer for main/noise balance
- [ ] Visual indicator for noise presence
- [ ] SNR difficulty indicator
- [ ] Adaptive noise based on user performance
- [ ] Multiple noise types (cafe, traffic, etc)
- [ ] Real-time SNR adjustment
