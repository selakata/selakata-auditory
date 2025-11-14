# Audio Cache Implementation

## Overview
Implementasi download dan cache audio untuk Quiz feature dengan progressive download strategy.

## Architecture

### Components

1. **AudioCacheService** (`Core/Services/AudioCacheService.swift`)
   - Singleton service untuk manage audio cache
   - Download audio dari URL
   - Store di app's cache directory
   - Support batch download dengan progress tracking

2. **QuizViewModel** (`Presentation/Quiz/QuizViewModel.swift`)
   - Fetch questions dari API
   - Download semua audio files setelah fetch questions
   - Provide cached audio URL ke view
   - Fallback ke streaming jika cache gagal

3. **SimpleAudioPlayer** (`Presentation/Components/SimpleAudioPlayer.swift`)
   - Support 3 audio sources:
     - Local file path (cached)
     - Remote URL (streaming)
     - Bundle resources (local assets)

## Flow

```
1. User buka Quiz
   ↓
2. QuizViewModel fetch questions dari API
   ↓
3. Extract audio URLs dari questions
   ↓
4. AudioCacheService download semua audio
   ↓
5. Show progress: "Downloading audio X/Y"
   ↓
6. Audio ready to play from cache
   ↓
7. SimpleAudioPlayer load dari cache
   ↓
8. Smooth playback tanpa buffering
```

## Features

### ✅ Implemented
- Download audio files dari URL
- Cache di local storage
- Progress indicator saat download
- Fallback ke streaming jika cache gagal
- Support replay tanpa re-download
- Auto-detect audio source (cache/URL/bundle)

### 🔄 Optional Features
- Clear cache setelah quiz selesai
- Pre-download audio di background
- Cache size management
- Offline mode detection

## Usage

### Download Audio
```swift
AudioCacheService.shared.downloadAndCache(from: urlString) { result in
    switch result {
    case .success(let cachedURL):
        // Use cached URL
    case .failure(let error):
        // Handle error
    }
}
```

### Batch Download
```swift
AudioCacheService.shared.downloadMultiple(urls: audioURLs) { downloaded, total in
    // Update progress
} completion: { result in
    // All done
}
```

### Get Cached URL
```swift
if let cachedURL = AudioCacheService.shared.getCachedURL(for: urlString) {
    // Use cached file
} else {
    // Download or stream
}
```

### Clear Cache
```swift
// Clear all
AudioCacheService.shared.clearCache()

// Clear specific
AudioCacheService.shared.clearCache(for: urlString)
```

## Cache Location
```
~/Library/Caches/AudioCache/
```

## Benefits

1. **Better UX**: Smooth playback tanpa buffering
2. **Data Saving**: Download sekali, play berkali-kali
3. **Offline Support**: Bisa play setelah download
4. **Reliability**: Tidak terpengaruh koneksi saat play
5. **Performance**: Instant replay tanpa delay

## Future Improvements

- [ ] Cache expiration policy
- [ ] Maximum cache size limit
- [ ] Background download saat idle
- [ ] Pre-cache next level audio
- [ ] Compression untuk save storage
- [ ] Analytics untuk cache hit rate
