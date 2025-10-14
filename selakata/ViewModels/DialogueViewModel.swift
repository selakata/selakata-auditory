import Foundation
import AVFoundation

@MainActor
class DialogueViewModel: ObservableObject {
    public let reader = DialogueReader()

    @Published var isPlaying = false
    @Published var currentSpeaker: String = ""
    @Published var currentLine: String = ""
    @Published var currentTrackTitle: String? = nil

    func playDialogue(_ dialogue: [DialogueLine], from trackTitle: String) {
        // kalau track yang sama sedang diputar → toggle pause/play
        if currentTrackTitle == trackTitle, isPlaying {
            pause()
            return
        }

        isPlaying = true
        currentTrackTitle = trackTitle
        reader.startDialogue(dialogue)
    }

    func pause() {
        isPlaying = false
        reader.pause()
    }

    func resume() {
        isPlaying = true
        reader.resume()
    }

    func stop() {
        isPlaying = false
        currentTrackTitle = nil
        reader.stop()
    }
}
