import Foundation
import AVFoundation

@MainActor
class DialogueViewModel: ObservableObject {
    public let reader = DialogueReader()

    @Published var isPlaying = false
    @Published var currentSpeaker: String = ""
    @Published var currentLine: String = ""

    func playDialogue(from text: String) {
        let dialogue = parseDialogue(from: text)
        isPlaying = true
        reader.startDialogue(dialogue)
    }

    func stop() {
        isPlaying = false
    }
}
