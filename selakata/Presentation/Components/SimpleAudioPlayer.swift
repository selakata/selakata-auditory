import AVFoundation
import SwiftUI

struct SimpleAudioPlayer: View {

    let fileName: String
    let noiseFileName: String?
    let onAudioCompleted: (() -> Void)?
    let onReplayRequested: (() -> Void)?
    let shouldReplay: Bool
    let autoPlay: Bool

    @StateObject private var engine = AudioEngineService()
    @State private var showNoiseIndicator = false
    @State private var hasCompletedOnce = false
    @State private var hasPlayedOnce = false
    @State private var audioLoaded = false

    var body: some View {
        VStack(spacing: 16) {

            if audioLoaded {
                if showNoiseIndicator {
                    HStack(spacing: 4) {
                        Image(systemName: "waveform")
                        Text("Background noise active")
                    }
                    .font(.caption2)
                    .foregroundColor(.orange)
                    .padding(6)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
                }

                Button(action: handlePlay) {
                    ZStack {
                        if hasPlayedOnce && hasCompletedOnce
                            && !engine.isMainPlaying
                        {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20))
                        } else {
                            Image(
                                systemName: engine.isMainPlaying
                                    ? "pause" : "speaker.wave.2.fill"
                            )
                            .font(.system(size: 20))
                        }
                    }
                    .frame(width: 28, height: 28)
                    .padding()
                    .background(Color.Primary._200)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

            } else {
                Text("Audio tidak tersedia")
                    .font(.caption)
                Button("Coba Lagi") { loadAudio() }
            }
        }
        .onAppear {
            setupCallbacks()
            loadAudio()
        }
        .onChange(of: fileName) { _, _ in
            // Reload audio when fileName changes (new question)
            hasCompletedOnce = false
            hasPlayedOnce = false
            showNoiseIndicator = false
            engine.stopAll()
            loadAudio()
            
            // Autoplay if enabled
            if autoPlay {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    handlePlay()
                }
            }
        }
        .onChange(of: shouldReplay) { _, newValue in if newValue { replay() } }
    }

    // MARK: - Actions

    private func handlePlay() {
        if engine.isMainPlaying {
            engine.pause()
            showNoiseIndicator = false
            return
        }

        if hasPlayedOnce && hasCompletedOnce {
            onReplayRequested?()
        }

        hasCompletedOnce = false
        hasPlayedOnce = true

        showNoiseIndicator = noiseFileName != nil
        engine.playSequence()
    }

    private func replay() {
        hasCompletedOnce = false
        hasPlayedOnce = false
        showNoiseIndicator = noiseFileName != nil
        engine.playSequence()
    }

    private func setupCallbacks() {
        engine.onMainAudioWillFinish = {
            self.hasCompletedOnce = true
            self.onAudioCompleted?()
        }

        engine.onMainAudioFinished = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showNoiseIndicator = false
            }
        }
    }

    // MARK: - Load Files

    private func loadAudio() {
        audioLoaded = false

        if let url = resolveURL(for: fileName) {
            engine.loadMainAudio(url: url)
            audioLoaded = true
        }

        if let noise = noiseFileName,
            let url = resolveURL(for: noise)
        {
            engine.loadNoiseAudio(url: url)
        }
    }

    private func resolveURL(for name: String) -> URL? {
        if name.hasPrefix("/") { return URL(fileURLWithPath: name) }
        if let url = URL(string: name), url.scheme != nil { return url }
        return Bundle.main.url(
            forResource: name,
            withExtension: "mp3",
            subdirectory: "Resources/Audio"
        )
            ?? Bundle.main.url(forResource: name, withExtension: "mp3")
    }
}

#Preview {
    SimpleAudioPlayer(
        fileName: "comprehension-easy-1",
        noiseFileName: "comprehension-easy-1",
        onAudioCompleted: {
            print("Preview: Main audio will finish soon!")
        },
        onReplayRequested: {
            print("Preview: Replay button tapped!")
        },
        shouldReplay: false,
        autoPlay: false
    )
    .padding()
}
