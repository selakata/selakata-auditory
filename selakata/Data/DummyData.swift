import Foundation

class DummyData {
    static let shared = DummyData()

    let tracks: [Track]

    private init() {
        tracks = [
            Track(
                title: "Percakapan Pagi",
                dialogues: [
                    DialogueLine(
                        speaker: "A", text: "Selamat pagi! Udah siap kerja?",
                        voiceLanguage: "id-ID", pitch: 0.8, rate: 0.2,
                        delay: 0.2),
                    DialogueLine(
                        speaker: "B", text: "Pagi! Masih ngopi dulu nih.",
                        voiceLanguage: "id-ID", pitch: 1.5, rate: 0.6,
                        delay: 0.3),
                    DialogueLine(
                        speaker: "A", text: "Haha, jangan kebanyakan ya!",
                        voiceLanguage: "id-ID", pitch: 0.8, rate: 0.2,
                        delay: 0.2),
                ]
            ),
            Track(
                title: "Obrolan Siang",
                dialogues: [
                    DialogueLine(
                        speaker: "A", text: "Udah makan siang belum?",
                        voiceLanguage: "id-ID", pitch: 0.8, rate: 0.2,
                        delay: 0.2),
                    DialogueLine(
                        speaker: "B",
                        text: "Belum, lagi bingung mau makan apa.",
                        voiceLanguage: "id-ID", pitch: 1.5, rate: 0.6,
                        delay: 0.3),
                    DialogueLine(
                        speaker: "A", text: "Yuk makan bareng aja!",
                        voiceLanguage: "id-ID", pitch: 0.8, rate: 0.2,
                        delay: 0.2),
                ]
            ),
        ]
    }
}
