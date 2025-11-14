import SwiftUI
import AVFoundation

struct SimpleAudioPlayer: View {
    let title: String
    let fileName: String
    let noiseFileName: String?
    let onAudioCompleted: (() -> Void)?
    let onReplayRequested: (() -> Void)?
    let shouldReplay: Bool
    @StateObject private var audioPlayer = AudioPlayerService()
    @StateObject private var noisePlayer = AudioPlayerService()
    @State private var hasAudio = false
    @State private var hasCompletedOnce = false
    @State private var timer: Timer?
    @State private var hasPlayedOnce = false
    @State private var showNoiseIndicator = false
    
    init(title: String, fileName: String, noiseFileName: String? = nil, onAudioCompleted: (() -> Void)? = nil, onReplayRequested: (() -> Void)? = nil, shouldReplay: Bool = false) {
        self.title = title
        self.fileName = fileName
        self.noiseFileName = noiseFileName
        self.onAudioCompleted = onAudioCompleted
        self.onReplayRequested = onReplayRequested
        self.shouldReplay = shouldReplay
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Audio Icon
            
//            Text(title)
//                .font(.headline)
            
            if hasAudio {
                // Progress
                VStack(spacing: 8) {
                    HStack {
                        Text(formatTime(audioPlayer.currentTime))
                            .font(.caption)
                        Spacer()
                        Text(formatTime(audioPlayer.duration))
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
                    ProgressView(value: audioPlayer.duration > 0 ? audioPlayer.currentTime / audioPlayer.duration : 0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                }
                
                // Noise indicator
                if showNoiseIndicator && noiseFileName != nil {
                    HStack(spacing: 4) {
                        Image(systemName: "waveform")
                            .font(.caption2)
                        Text("Background noise active")
                            .font(.caption2)
                    }
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
                }
                
                // Controls
                HStack(spacing: 20) {
                    Button(action: {
                        if audioPlayer.isPlaying {
                            audioPlayer.pause()
                            noisePlayer.pause()
                        } else {
                            // Check if audio is loaded
                            guard hasAudio else {
                                print("⚠️ Cannot play: Audio not loaded yet")
                                return
                            }
                            
                            // Check if this is a replay attempt
                            if hasPlayedOnce && hasCompletedOnce {
                                // Notify parent about replay request
                                onReplayRequested?()
                                // Don't return here, continue to play
                            }
                            
                            // Reset states for replay
                            hasCompletedOnce = false
                            
                            // Sequence: Noise → (1s) → Main Audio + Noise → Main ends → (1s) → Noise ends
                            if noiseFileName != nil {
                                // Show noise indicator
                                showNoiseIndicator = true
                                
                                // Stop any playing audio first
                                if audioPlayer.isPlaying {
                                    audioPlayer.stop()
                                }
                                if noisePlayer.isPlaying {
                                    noisePlayer.stop()
                                }
                                
                                // Wait for stop to complete, then start noise
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    print("🔊 Starting noise audio")
                                    self.noisePlayer.play()
                                    
                                    // Start main audio after 1 second
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        print("🎵 Starting main audio")
                                        self.audioPlayer.play()
                                    }
                                }
                            } else {
                                // No noise, just play main audio
                                if audioPlayer.isPlaying {
                                    audioPlayer.stop()
                                }
                                
                                // Wait for stop to complete
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    print("🎵 Starting main audio (no noise)")
                                    self.audioPlayer.play()
                                }
                            }
                            hasPlayedOnce = true
                        }
                    }) {
                        ZStack {
                            Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                            
                            // Show replay indicator if completed
                            if hasPlayedOnce && hasCompletedOnce && !audioPlayer.isPlaying {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .offset(x: 0, y: -2)
                            }
                        }
                    }
                    
//                    Button(action: {
//                        let rates: [Float] = [0.5, 1.0, 1.5, 2.0]
//                        if let currentIndex = rates.firstIndex(of: audioPlayer.playbackRate) {
//                            let nextIndex = (currentIndex + 1) % rates.count
//                            audioPlayer.setPlaybackRate(rates[nextIndex])
//                        }
//                    }) {
//                        Text("\(String(format: "%.1f", audioPlayer.playbackRate))x")
//                            .font(.caption)
//                            .padding(.horizontal, 8)
//                            .padding(.vertical, 4)
//                            .background(Color.blue.opacity(0.2))
//                            .cornerRadius(4)
//                    }
                    
                    // Debug button for testing completion
//                    Button(action: {
//                        print("🧪 Manual completion trigger")
//                        hasCompletedOnce = true
//                        onAudioCompleted?()
//                    }) {
//                        Text("Done")
//                            .font(.caption)
//                            .padding(.horizontal, 8)
//                            .padding(.vertical, 4)
//                            .background(Color.green.opacity(0.2))
//                            .foregroundColor(.green)
//                            .cornerRadius(4)
//                    }
                }
            } else {
                Text("Audio tidak tersedia")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button("Coba Lagi") {
                    loadAudio()
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onAppear {
            loadAudio()
            if let noiseFileName = noiseFileName {
                loadNoiseAudio(noiseFileName)
            }
        }
        .onDisappear {
            stopTimer()
            audioPlayer.stop()
            noisePlayer.stop()
        }
        .onChange(of: shouldReplay) { oldValue, newValue in
            if newValue {
                // Reset states and replay
                hasCompletedOnce = false
                hasPlayedOnce = false
                audioPlayer.stop()
                noisePlayer.stop()
                
                // Replay with sequence
                if noiseFileName != nil {
                    // Start noise first
                    noisePlayer.play()
                    
                    // Start main audio after 1 second
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        audioPlayer.play()
                    }
                } else {
                    // No noise, just play main audio
                    audioPlayer.play()
                }
            }
        }
        .onChange(of: fileName) { oldValue, newValue in
            print("🔄 Audio file changed from '\(oldValue)' to '\(newValue)'")
            audioPlayer.stop() // Stop current audio
            noisePlayer.stop() // Stop noise audio
            hasCompletedOnce = false // Reset completion flag
            showNoiseIndicator = false // Reset noise indicator
            stopTimer()
            loadAudio() // Load new audio
            if let noiseFileName = noiseFileName {
                loadNoiseAudio(noiseFileName)
            }
        }
        .onChange(of: audioPlayer.isPlaying) { oldValue, newValue in
            if newValue {
                // Audio started playing, start monitoring
                startCompletionTimer()
            } else {
                // Audio stopped, stop monitoring
                stopTimer()
            }
        }
    }
    
    private func loadAudio() {
        print("🎵 Loading audio file: \(fileName)")
        
        // Stop current audio if playing
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        
        // Check if fileName is a local file path (cached)
        if fileName.hasPrefix("/") {
            // Local file path
            let fileURL = URL(fileURLWithPath: fileName)
            if FileManager.default.fileExists(atPath: fileName) {
                audioPlayer.loadAudioFromURL(fileURL)
                hasAudio = true
                print("✅ Successfully loaded from cache: \(fileName)")
                return
            } else {
                print("⚠️ Cached file not found: \(fileName)")
            }
        }
        
        // Check if fileName is a URL (streaming)
        if fileName.hasPrefix("http://") || fileName.hasPrefix("https://") {
            if let url = URL(string: fileName) {
                audioPlayer.loadAudioFromURL(url)
                hasAudio = true
                print("✅ Successfully loaded from URL: \(fileName)")
                return
            }
        }
        
        // Fallback: Try to load from bundle (for local resources)
        let subdirectory = "Resources/Audio"
        
        if let audioURL = Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: subdirectory) {
            audioPlayer.loadAudioFromPath(fileName: fileName, subdirectory: subdirectory)
            hasAudio = true
            print("✅ Successfully loaded: \(fileName).mp3 from \(subdirectory)")
        } else if let audioURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            audioPlayer.loadAudio(fileName: fileName)
            hasAudio = true
            print("✅ Successfully loaded: \(fileName).mp3 from root bundle")
        } else {
            hasAudio = false
            print("❌ Audio file not found: \(fileName)")
        }
    }
    
    private func handleAudioError(_ error: Error) {
        switch error {
        case let error as AudioError:
            print("❌ Audio Error:", error.localizedDescription)
            
        default:
            print("❌ Unexpected Error:", error.localizedDescription)
        }
        
        // Optional: tampilkan alert atau fallback
        // showAlert(title: "Audio Error", message: error.localizedDescription)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func startCompletionTimer() {
        stopTimer() // Stop any existing timer
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            guard audioPlayer.duration > 0 else { return }
            
            // Show answers 1 second before audio completes
            let timeBeforeEnd = 1.0
            
            if audioPlayer.duration > 0 && 
               audioPlayer.currentTime >= audioPlayer.duration - timeBeforeEnd && 
               !hasCompletedOnce {
                
                print("🎵 Audio near completion! Duration: \(audioPlayer.duration), Current: \(audioPlayer.currentTime)")
                hasCompletedOnce = true
                
                // Call completion callback earlier (1 second before end)
                DispatchQueue.main.async {
                    self.onAudioCompleted?()
                }
                
                // If there's noise, stop it 1 second after main audio ends
                if self.noiseFileName != nil {
                    let delayUntilNoiseStop = audioPlayer.duration - audioPlayer.currentTime + 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayUntilNoiseStop) {
                        self.noisePlayer.stop()
                        self.showNoiseIndicator = false
                        print("🔇 Noise stopped 1 second after main audio")
                    }
                }
                
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func loadNoiseAudio(_ noiseFileName: String) {
        print("🔊 Loading noise audio: \(noiseFileName)")
        
        // Check if noiseFileName is a local file path (cached)
        if noiseFileName.hasPrefix("/") {
            let fileURL = URL(fileURLWithPath: noiseFileName)
            if FileManager.default.fileExists(atPath: noiseFileName) {
                noisePlayer.loadAudioFromURL(fileURL)
                print("✅ Noise audio loaded from cache: \(noiseFileName)")
                return
            }
        }
        
        // Check if noiseFileName is a URL (streaming)
        if noiseFileName.hasPrefix("http://") || noiseFileName.hasPrefix("https://") {
            if let url = URL(string: noiseFileName) {
                noisePlayer.loadAudioFromURL(url)
                print("✅ Noise audio loaded from URL: \(noiseFileName)")
                return
            }
        }
        
        // Fallback: Try to load from bundle
        let subdirectory = "Resources/Audio"
        if let audioURL = Bundle.main.url(forResource: noiseFileName, withExtension: "mp3", subdirectory: subdirectory) {
            noisePlayer.loadAudioFromPath(fileName: noiseFileName, subdirectory: subdirectory)
            print("✅ Noise audio loaded from bundle: \(noiseFileName)")
        } else {
            print("⚠️ Noise audio not found: \(noiseFileName)")
        }
    }
}

#Preview {
    SimpleAudioPlayer(
        title: "Dengarkan Audio Ini", 
        fileName: "identification1",
        onAudioCompleted: {
            print("Audio completed in preview")
        },
        onReplayRequested: {
            print("Replay requested in preview")
        }
    )
    .padding()
}
