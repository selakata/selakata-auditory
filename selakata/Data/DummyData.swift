import Foundation

class DummyData {
    static let shared = DummyData()

    let tracks: [Track]

    private init() {
        tracks = [
            Track(
                title: "Koordinasi Laporan Bulanan",
                dialogues: [
                    DialogueLine(
                        speaker: "C", text: "Kita perlu kirim laporan bulanan",
                        voiceLanguage: "id-ID", pitch: 0.9, rate: 0.35,
                        delay: 0.1),
                    DialogueLine(
                        speaker: "C", text: "ke tim pusat",
                        voiceLanguage: "id-ID", pitch: 1.0, rate: 0.4,
                        delay: 0.05),
                    DialogueLine(
                        speaker: "C", text: "paling lambat hari Kamis.",
                        voiceLanguage: "id-ID", pitch: 0.8, rate: 0.3,
                        delay: 0.25),

                    DialogueLine(
                        speaker: "D",
                        text: "Berarti aku harus finalisasi data penjualan",
                        voiceLanguage: "id-ID", pitch: 1.3, rate: 0.55,
                        delay: 0.1),
                    DialogueLine(
                        speaker: "D", text: "hari ini ya?",
                        voiceLanguage: "id-ID", pitch: 1.4, rate: 0.45,
                        delay: 0.25),

                    DialogueLine(
                        speaker: "C", text: "Iya,", voiceLanguage: "id-ID",
                        pitch: 1.0, rate: 0.35, delay: 0.05),
                    DialogueLine(
                        speaker: "C",
                        text: "dan pastikan juga bagian pengeluaran",
                        voiceLanguage: "id-ID", pitch: 0.9, rate: 0.4,
                        delay: 0.05),
                    DialogueLine(
                        speaker: "C", text: "udah dikonfirmasi sama finance.",
                        voiceLanguage: "id-ID", pitch: 0.8, rate: 0.3,
                        delay: 0.25),

                    DialogueLine(
                        speaker: "D", text: "Oke,", voiceLanguage: "id-ID",
                        pitch: 1.5, rate: 0.5, delay: 0.05),
                    DialogueLine(
                        speaker: "D", text: "nanti aku kirim semua file-nya",
                        voiceLanguage: "id-ID", pitch: 1.3, rate: 0.55,
                        delay: 0.05),
                    DialogueLine(
                        speaker: "D", text: "sebelum jam enam sore.",
                        voiceLanguage: "id-ID", pitch: 1.2, rate: 0.45,
                        delay: 0.3),
                ]
            ),
        ]
    }
}
