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
        isPlaying = true
        currentTrackTitle = trackTitle
        reader.startDialogue(dialogue)
    }

    func stop() {
        isPlaying = false
        currentTrackTitle = nil
    }
}
