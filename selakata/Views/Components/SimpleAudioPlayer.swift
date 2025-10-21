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
            
            Text(title)
                .font(.headline)
            
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
    }
    
    private func loadAudio() {
        // Debug: print available audio files in bundle
        audioPlayer.debugAudioFiles()
        
        do {
            // Coba cari file audio di bundle
            guard let audioURL = Bundle.main.url(
                forResource: fileName,
                withExtension: "mp3",
            ) else {
                throw AudioError.fileNotFound(fileName: fileName)
            }
            
            // Coba load audio
            audioPlayer.loadAudioFromPath(fileName: fileName)
            hasAudio = true
            print("✅ Successfully loaded: \(fileName).mp3 from \(audioURL.lastPathComponent)")
            
        } catch {
            hasAudio = false
            handleAudioError(error)
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
