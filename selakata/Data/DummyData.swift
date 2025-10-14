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
            
            Track(
                title: "Pagi di Kafe Langganan",
                dialogues: [
                    DialogueLine(
                        speaker: "A", text: "Pagi ini aku mulai hari",
                        voiceLanguage: "id-ID", pitch: 1.0, rate: 0.4,
                        delay: 0.05),
                    DialogueLine(
                        speaker: "A",
                        text: "dengan sarapan roti dan kopi di kafe langganan.",
                        voiceLanguage: "id-ID", pitch: 0.95, rate: 0.35,
                        delay: 0.25),

                    DialogueLine(
                        speaker: "A", text: "Biasanya aku pesan americano,",
                        voiceLanguage: "id-ID", pitch: 1.1, rate: 0.4,
                        delay: 0.15),
                    DialogueLine(
                        speaker: "A",
                        text: "tapi hari ini aku coba cappuccino.",
                        voiceLanguage: "id-ID", pitch: 1.0, rate: 0.38,
                        delay: 0.25),

                    DialogueLine(
                        speaker: "A", text: "Oh iya,", voiceLanguage: "id-ID",
                        pitch: 1.3, rate: 0.5, delay: 0.05),
                    DialogueLine(
                        speaker: "A",
                        text:
                            "barista-nya tadi bilang minggu depan mereka akan buka menu baru,",
                        voiceLanguage: "id-ID", pitch: 1.1, rate: 0.42,
                        delay: 0.1),
                    DialogueLine(
                        speaker: "A",
                        text: "kayak croissant isi keju dan coklat.",
                        voiceLanguage: "id-ID", pitch: 0.9, rate: 0.35,
                        delay: 0.3),
                ]
            ),

        ]
    }
}
