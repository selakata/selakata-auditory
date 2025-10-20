import SwiftUI
import AVFoundation

struct SimpleAudioPlayer: View {
    let title: String
    @StateObject private var audioPlayer = AudioPlayerService()
    @State private var hasAudio = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Audio Icon
            Image(systemName: hasAudio ? "speaker.wave.2.fill" : "speaker.slash.fill")
                .font(.system(size: 40))
                .foregroundColor(hasAudio ? .blue : .gray)
            
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
        // Debug: print all available audio files
        audioPlayer.debugAudioFiles()
        
        // Try to load audio from various locations
        let audioOptions = [
            ("identification1", "Resources/Audio"),
            ("identification", "Resources/Audio"),
            ("identification1", nil),
            ("identification", nil)
        ]
        
        for (fileName, subdirectory) in audioOptions {
            if Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: subdirectory) != nil {
                if let subdirectory = subdirectory {
                    audioPlayer.loadAudioFromPath(fileName: fileName, subdirectory: subdirectory)
                } else {
                    audioPlayer.loadAudio(fileName: fileName)
                }
                hasAudio = true
                print("✅ Successfully loaded: \(fileName).mp3")
                return
            }
        }
        
        hasAudio = false
        print("❌ No audio file found")
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    SimpleAudioPlayer(title: "Audio Soal")
        .padding()
}