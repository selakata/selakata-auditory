import AVFoundation

class DialogueReader: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var queue: [DialogueLine] = []
    private var currentIndex = 0
    
    var onLineStart: ((DialogueLine) -> Void)?

    func startDialogue(_ dialogue: [DialogueLine]) {
        queue = dialogue
        currentIndex = 0
        synthesizer.delegate = self
        speakNextLine()
    }

    private func speakNextLine() {
        guard currentIndex < queue.count else { return }
        let line = queue[currentIndex]

        let utterance = AVSpeechUtterance(string: line.text)
        utterance.voice = AVSpeechSynthesisVoice(language: line.voiceLanguage)
        utterance.pitchMultiplier = line.pitch
        utterance.rate = line.rate
        utterance.postUtteranceDelay = line.delay

        print("\(line.speaker): \(line.text)")

        onLineStart?(line)
        synthesizer.speak(utterance)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        currentIndex += 1
        speakNextLine()
    }
    
    func pause() {
        synthesizer.pauseSpeaking(at: .immediate)
    }

    func resume() {
        synthesizer.continueSpeaking()
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

}
