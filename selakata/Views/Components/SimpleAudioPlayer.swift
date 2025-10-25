import SwiftUI
import AVFoundation

struct SimpleAudioPlayer: View {
    let title: String
    let fileName: String
    @StateObject private var audioPlayer = AudioPlayerService()
    @State private var hasAudio = false
    
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
                
                // Controls
                HStack(spacing: 20) {
                    Button(action: {
                        if audioPlayer.isPlaying {
                            audioPlayer.pause()
                        } else {
                            audioPlayer.play()
                        }
                    }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        let rates: [Float] = [0.5, 1.0, 1.5, 2.0]
                        if let currentIndex = rates.firstIndex(of: audioPlayer.playbackRate) {
                            let nextIndex = (currentIndex + 1) % rates.count
                            audioPlayer.setPlaybackRate(rates[nextIndex])
                        }
                    }) {
                        Text("\(String(format: "%.1f", audioPlayer.playbackRate))x")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(4)
                    }
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
        }
        .onChange(of: fileName) { oldValue, newValue in
            print("🔄 Audio file changed from '\(oldValue)' to '\(newValue)'")
            audioPlayer.stop() // Stop current audio
            loadAudio() // Load new audio
        }
    }
    
    private func loadAudio() {
        print("🎵 Loading audio file: \(fileName)")
        
        // Stop current audio if playing
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        
        // Try to load audio from Resources/Audio subdirectory
        let subdirectory = "Resources/Audio"
        
        if let audioURL = Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: subdirectory) {
            // Load audio using AudioPlayerService
            audioPlayer.loadAudioFromPath(fileName: fileName, subdirectory: subdirectory)
            hasAudio = true
            print("✅ Successfully loaded: \(fileName).mp3 from \(subdirectory)")
            print("   Full path: \(audioURL.path)")
        } else {
            // Fallback: try root bundle
            if let audioURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
                audioPlayer.loadAudio(fileName: fileName)
                hasAudio = true
                print("✅ Successfully loaded: \(fileName).mp3 from root bundle")
                print("   Full path: \(audioURL.path)")
            } else {
                hasAudio = false
                print("❌ Audio file not found: \(fileName).mp3")
                print("   Tried locations:")
                print("   - \(subdirectory)/\(fileName).mp3")
                print("   - \(fileName).mp3 (root)")
                
                // Debug: List all available MP3 files
                if let mp3Files = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: subdirectory) {
                    print("   Available files in \(subdirectory):")
                    for file in mp3Files {
                        print("     - \(file.lastPathComponent)")
                    }
                }
            }
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
}

#Preview {
    SimpleAudioPlayer(title: "Dengarkan Audio Ini", fileName: "identification1")
        .padding()
}
