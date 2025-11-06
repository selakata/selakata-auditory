import SwiftUI

struct MediaCard: View {
    let audioFileName: String
    let title: String
    let coverImage: String?
    let subdirectory: String?
    
    @StateObject private var audioPlayer = AudioPlayerService()
    
    init(audioFileName: String, title: String, coverImage: String? = nil, subdirectory: String? = nil) {
        self.audioFileName = audioFileName
        self.title = title
        self.coverImage = coverImage
        self.subdirectory = subdirectory
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemGray5))

            VStack(spacing: 20) {
                // Cover Image atau Icon
                Group {
                    if let coverImage = coverImage {
                        Image(coverImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "music.note")
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 80, height: 80)
                .foregroundStyle(Color(.systemGray3))
                
                // Title
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                // Media Controls
                VStack(spacing: 12) {
                    // Progress Bar
                    VStack(spacing: 4) {
                        HStack {
                            Text(formatTime(audioPlayer.currentTime))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(formatTime(audioPlayer.duration))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        ProgressView(value: audioPlayer.duration > 0 ? audioPlayer.currentTime / audioPlayer.duration : 0)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .onTapGesture { location in
                                // Seek functionality
                                let progress = location.x / UIScreen.main.bounds.width * 0.8
                                let seekTime = progress * audioPlayer.duration
                                audioPlayer.seek(to: seekTime)
                            }
                    }
                    
                    // Control Buttons
                    HStack(spacing: 20) {
                        // Play/Pause Button
                        Button(action: {
                            if audioPlayer.isPlaying {
                                audioPlayer.pause()
                            } else {
                                audioPlayer.play()
                            }
                        }) {
                            Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                .foregroundStyle(.white)
                                .font(.title2)
                                .padding(12)
                                .background(Circle().fill(Color.blue))
                        }
                        
                        // Speed Control
                        Button(action: {
                            let rates: [Float] = [0.5, 1.0, 1.5, 2.0]
                            if let currentIndex = rates.firstIndex(of: audioPlayer.playbackRate) {
                                let nextIndex = (currentIndex + 1) % rates.count
                                audioPlayer.setPlaybackRate(rates[nextIndex])
                            }
                        }) {
                            Text("\(String(format: "%.1f", audioPlayer.playbackRate))x")
                                .font(.subheadline)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color(.systemGray2)))
                        }
                    }
                }
            }
            .padding(20)
        }
        .frame(height: 280)
        .onAppear {
            if let subdirectory = subdirectory {
                audioPlayer.loadAudioFromPath(fileName: audioFileName, subdirectory: subdirectory)
            } else {
                audioPlayer.loadAudio(fileName: audioFileName)
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    MediaCard(
        audioFileName: "sample_audio",
        title: "Preview Audio"
    )
    .padding()
}
