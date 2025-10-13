import Foundation

func parseDialogue(from text: String) -> [DialogueLine] {
    let lines = text.split(separator: "\n")
    var dialogues: [DialogueLine] = []

    for line in lines {
        let parts = line.split(separator: ":", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else { continue }
        let speaker = parts[0]
        let sentence = parts[1]

        let voiceLang = "id-ID"
        let pitch: Float
        let rate: Float
        let delay: TimeInterval
        
        if speaker == "A" {
            pitch = 1.0
            rate = 0.45
            delay = 0.2
        } else {
            pitch = 1.3
            rate = 0.4
            delay = 0.3
        }
        
        dialogues.append(
            DialogueLine(
                speaker: speaker,
                text: sentence,
                voiceLanguage: voiceLang,
                pitch: pitch,
                rate: rate,
                delay: delay
            )
        )
    }

    return dialogues
}
