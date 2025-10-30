//
//  QuizData.swift
//  selakata
//
//  Created by ais on 23/10/25.
//

struct QuizData {
    static let audioIdentification = [
        [
            "identification-easy-1",
            "identification-easy-2",
            "identification-easy-3",
            "identification-easy-4",
            "identification-easy-5",
        ],
        [
            "identification-medium-1",
            "identification-medium-2",
            "identification-medium-3",
            "identification-medium-4",
            "identification-medium-5",
        ],
        [
            "identification-hard-1",
            "identification-hard-2",
            "identification-hard-3",
            "identification-hard-4",
            "identification-hard-5",
        ],
    ]

    static let audioDiscrimintion = [
        [
            "discrimination-easy-1",
            "discrimination-easy-2",
            "discrimination-easy-3",
            "discrimination-easy-4",
            "discrimination-easy-5",
        ],
        [
            "discrimination-medium-1",
            "discrimination-medium-2",
            "discrimination-medium-3",
            "discrimination-medium-4",
            "discrimination-medium-5",
        ],
        [
            "discrimination-hard-1",
            "discrimination-hard-2",
            "discrimination-hard-3",
            "discrimination-hard-4",
            "discrimination-hard-5",
        ],
    ]
    static let audioComprehension = [
        [
            "comprehension-easy-1",
            "comprehension-easy-2",
            "comprehension-easy-3",
            "comprehension-easy-4",
            "comprehension-easy-5",
        ],
        [
            "comprehension-medium-1",
            "comprehension-medium-2",
            "comprehension-medium-3",
            "comprehension-medium-4",
            "comprehension-medium-5",
        ],
        [
            "comprehension-hard-1",
            "comprehension-hard-2",
            "comprehension-hard-3",
            "comprehension-hard-4",
            "comprehension-hard-5",
        ],
    ]

    static let audioComputingSpeaker: [[String]] = [
        [
            "CS-II-1-SNR-(8dB)",
            "CS-II-2-SNR-(5dB)",
            "CS-II-3-SNR-(5dB)",
            "CS-II-4-SNR-(3dB)",
            "CS-II-5-SNR-(0dB)",
        ],
        [
            "CS-III-1-SNR-(8dB)",
            "CS-III-2-SNR-(5dB)",
            "CS-III-3-SNR-(5dB)",
            "CS-III-4-SNR-(3dB)",
            "CS-III-5-SNR-(0dB)",
        ],

    ]

    static let identificationQuestions = [
        [
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Pipi", isCorrect: false),
                    Answer(title: "Tepi", isCorrect: false),
                    Answer(title: "Topi", isCorrect: true),
                    Answer(title: "Sapi", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Duku", isCorrect: false),
                    Answer(title: "Buku", isCorrect: true),
                    Answer(title: "Suku", isCorrect: false),
                    Answer(title: "Lugu", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Rapu", isCorrect: false),
                    Answer(title: "Saku", isCorrect: true),
                    Answer(title: "Satu", isCorrect: false),
                    Answer(title: "Sapu", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Kuta", isCorrect: false),
                    Answer(title: "Rupa", isCorrect: false),
                    Answer(title: "Supa", isCorrect: false),
                    Answer(title: "Kuda", isCorrect: true),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Kaki", isCorrect: true),
                    Answer(title: "Sari", isCorrect: false),
                    Answer(title: "Dari", isCorrect: false),
                    Answer(title: "Maki", isCorrect: false),
                ]
            ),
        ],
        [
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Gatal", isCorrect: false),
                    Answer(title: "Kapal", isCorrect: true),
                    Answer(title: "Kapan", isCorrect: false),
                    Answer(title: "Kapas", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Menggigil", isCorrect: false),
                    Answer(title: "Memanggil", isCorrect: true),
                    Answer(title: "Menggunting", isCorrect: false),
                    Answer(title: "Menggigit", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Jendara", isCorrect: false),
                    Answer(title: "Jendral", isCorrect: false),
                    Answer(title: "Jendela", isCorrect: true),
                    Answer(title: "Jembala", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Lembaran", isCorrect: true),
                    Answer(title: "Lebaran", isCorrect: false),
                    Answer(title: "Jembaran", isCorrect: false),
                    Answer(title: "Jembatan", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Belajar", isCorrect: true),
                    Answer(title: "Pelajar", isCorrect: false),
                    Answer(title: "Selancar", isCorrect: false),
                    Answer(title: "Derajat", isCorrect: false),
                ]
            ),
        ],
        [
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Komuter", isCorrect: false),
                    Answer(title: "Komputer", isCorrect: true),
                    Answer(title: "Komputel", isCorrect: false),
                    Answer(title: "Komputes", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Menari", isCorrect: true),
                    Answer(title: "Menarik", isCorrect: false),
                    Answer(title: "Menaruh", isCorrect: false),
                    Answer(title: "Memercik", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Kegaduhan", isCorrect: false),
                    Answer(title: "Kerapuhan", isCorrect: false),
                    Answer(title: "Kepatuhan", isCorrect: true),
                    Answer(title: "Keputusan", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Kecipratan", isCorrect: false),
                    Answer(title: "Kepintaran", isCorrect: false),
                    Answer(title: "Kecintaan", isCorrect: true),
                    Answer(title: "Keciptaan", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa kata yang diucapkan?",
                answers: [
                    Answer(title: "Keseringan", isCorrect: false),
                    Answer(title: "Kesenian", isCorrect: true),
                    Answer(title: "Keserian", isCorrect: false),
                    Answer(title: "Kesekian", isCorrect: false),
                ]
            ),
        ],
    ]

    static let discriminationQuestions = [
        [
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Botol", isCorrect: false),
                    Answer(title: "Bosan", isCorrect: true),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Dara", isCorrect: false),
                    Answer(title: "Dasi", isCorrect: true),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Layu", isCorrect: true),
                    Answer(title: "Layar", isCorrect: false),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Makan", isCorrect: true),
                    Answer(title: "Mandi", isCorrect: false),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Panjang", isCorrect: true),
                    Answer(title: "Ranjang", isCorrect: false),
                ]
            ),
        ],
        [
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Anting", isCorrect: true),
                    Answer(title: "Anjing", isCorrect: false),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Gayung", isCorrect: false),
                    Answer(title: "Dayung", isCorrect: true),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Gusur", isCorrect: true),
                    Answer(title: "Gugur", isCorrect: false),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Kasir", isCorrect: false),
                    Answer(title: "Pasir", isCorrect: true),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Risau", isCorrect: false),
                    Answer(title: "Pisau", isCorrect: true),
                ]
            ),
        ],
        [
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Ingin", isCorrect: false),
                    Answer(title: "Dingin", isCorrect: true),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Persiapan", isCorrect: true),
                    Answer(title: "Perpisahan", isCorrect: false),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Pintu Kata", isCorrect: true),
                    Answer(title: "Pintu Kaca", isCorrect: false),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Obat", isCorrect: false),
                    Answer(title: "Sempat", isCorrect: true),
                ]
            ),
            Question(
                text: "Yang manakah suaranya?",
                answers: [
                    Answer(title: "Sifat Buruk", isCorrect: true),
                    Answer(title: "Sikap Buruk", isCorrect: false),
                ]
            ),
        ],
    ]

    static let comprehensionQuestions = [
        [
            Question(
                text: "Apa yang Rina Minum?",
                answers: [
                    Answer(title: "Es", isCorrect: false),
                    Answer(title: "Jus", isCorrect: true),
                    Answer(title: "Kopi", isCorrect: false),
                    Answer(title: "Teh", isCorrect: false),
                ]
            ),
            Question(
                text: "Kata sebelum \"dengan\" adalah?",
                answers: [
                    Answer(title: "Tahun", isCorrect: true),
                    Answer(title: "Memotong", isCorrect: false),
                    Answer(title: "Adik", isCorrect: false),
                    Answer(title: "Pisau", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa yang ayah perbaiki?",
                answers: [
                    Answer(title: "Motor", isCorrect: false),
                    Answer(title: "Sepeda", isCorrect: false),
                    Answer(title: "Mobil", isCorrect: true),
                    Answer(title: "Gerobak", isCorrect: false),
                ]
            ),
            Question(
                text: "Kata sebelum \"sambil\" adalah?",
                answers: [
                    Answer(title: "Taman", isCorrect: true),
                    Answer(title: "Santai", isCorrect: false),
                    Answer(title: "Berjalan", isCorrect: false),
                    Answer(title: "Tongkat", isCorrect: false),
                ]
            ),
            Question(
                text: "Kata sebelum \"makan\" adalah?",
                answers: [
                    Answer(title: "Piring", isCorrect: false),
                    Answer(title: "Untuk", isCorrect: false),
                    Answer(title: "Setelah", isCorrect: true),
                    Answer(title: "Ibunya", isCorrect: false),
                ]
            ),
        ],
        [
            Question(
                text: "Kenapa Budi berhenti di perjalanan?",
                answers: [
                    Answer(title: "Ban motor bocor", isCorrect: false),
                    Answer(title: "Ada ujian Mendadak", isCorrect: false),
                    Answer(title: "Karena hujan", isCorrect: true),
                    Answer(title: "Sekolahnya tutup", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa yang Dina lupakan?",
                answers: [
                    Answer(title: "Bucket", isCorrect: false),
                    Answer(title: "Totebag", isCorrect: false),
                    Answer(title: "Dompet", isCorrect: true),
                    Answer(title: "Songket", isCorrect: false),
                ]
            ),
            Question(
                text: "Mengapa Andi meminta adiknya mengecilkan suara TV?",
                answers: [
                    Answer(
                        title: "Karena Andi sedang rekaman",
                        isCorrect: false
                    ),
                    Answer(title: "Karena Andi sedang sakit", isCorrect: false),
                    Answer(
                        title: "Karena Andi sedang belajar",
                        isCorrect: true
                    ),
                    Answer(title: "Karena Andi kebisingan", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa yang dilakukan Raka saat koneksinya terputus??",
                answers: [
                    Answer(title: "Merestart Wi-Fi", isCorrect: false),
                    Answer(title: "Menyalakan hotspot", isCorrect: true),
                    Answer(title: "Membeli paket data", isCorrect: false),
                    Answer(
                        title: "Menghubungi service provider",
                        isCorrect: false
                    ),
                ]
            ),
            Question(
                text: "Kenapa Sinta mengganti menu makan malamnya?",
                answers: [
                    Answer(title: "Karena gas habis", isCorrect: false),
                    Answer(title: "Karena saus tomat habis", isCorrect: true),
                    Answer(title: "Karena moodnya habis", isCorrect: false),
                    Answer(title: "Karena pastanya habis", isCorrect: false),
                ]
            ),
        ],
        [
            Question(
                text: "Apa yang sebenarnya Mia pesan?",
                answers: [
                    Answer(title: "Salad dan jus mangga", isCorrect: false),
                    Answer(title: "Salad dan jus jeruk", isCorrect: true),
                    Answer(title: "Salad dan martabak telur", isCorrect: false),
                    Answer(title: "Salad dan alpukat", isCorrect: false),
                ]
            ),
            Question(
                text: "Pukul berapa seharusnya kereta berangkat?",
                answers: [
                    Answer(title: "Pukul setengah tiga sore", isCorrect: false),
                    Answer(title: "Pukul lima sore", isCorrect: false),
                    Answer(title: "Pukul tiga sore", isCorrect: true),
                    Answer(title: "Pukul setengah lima sore", isCorrect: false),
                ]
            ),
            Question(
                text: "Pukul berapa ujian dimulai?",
                answers: [
                    Answer(title: "Pukul 1 siang", isCorrect: false),
                    Answer(title: "Pukul 9", isCorrect: false),
                    Answer(title: "Pukul 9.30", isCorrect: true),
                    Answer(title: "Pukul 8.30", isCorrect: false),
                ]
            ),
            Question(
                text: "Makanan apa yang dirasa Rani kurang asin?",
                answers: [
                    Answer(title: "Sop", isCorrect: true),
                    Answer(title: "Pastry", isCorrect: false),
                    Answer(title: "Sayur", isCorrect: false),
                    Answer(title: "Lodeh", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa yang seharusnya dipesan oleh Dafa?",
                answers: [
                    Answer(title: "Pasta", isCorrect: false),
                    Answer(title: "Pastry", isCorrect: true),
                    Answer(title: "Spagetthi", isCorrect: false),
                    Answer(title: "Sandwich", isCorrect: false),
                ]
            ),
        ],
    ]

    static let computationSpeakerQuestions = [
        [
            Question(
                text: "Kenapa Nathan tidak ikut main basket hari ini?",
                answers: [
                    Answer(title: "Karena sedang berlibur", isCorrect: false),
                    Answer(title: "Karena sedang sakit", isCorrect: true),
                    Answer(title: "Karena ada tugas dadakan", isCorrect: false),
                    Answer(title: "Karena besok ulangan", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa minuman yang diminum pembicara utama hari ini?",
                answers: [
                    Answer(title: "Americano", isCorrect: false),
                    Answer(title: "Coffe Latte", isCorrect: false),
                    Answer(title: "Cappucino", isCorrect: true),
                    Answer(title: "Espresso", isCorrect: false),
                ]
            ),
            Question(
                text: "Kegiatan apa yang sering pembaca lakukan di pagi hari?",
                answers: [
                    Answer(
                        title: "Memeriksa email dan membuat daftar tugas",
                        isCorrect: true
                    ),
                    Answer(
                        title: "Memperbaiki pekerjaan hari kemarin",
                        isCorrect: false
                    ),
                    Answer(
                        title: "Membuat email untuk mengirim tugas",
                        isCorrect: false
                    ),
                    Answer(
                        title: "Membuat daftar tugas untuk laporan",
                        isCorrect: false
                    ),
                ]
            ),
            Question(
                text: "Kapan laporan di tim harus dikumpulkan?",
                answers: [
                    Answer(title: "Hari Selasa", isCorrect: true),
                    Answer(title: "Hari Senin", isCorrect: false),
                    Answer(title: "Hari Rabu", isCorrect: false),
                    Answer(title: "Hari Jum'at", isCorrect: false),
                ]
            ),
            Question(
                text: "Jalur berapa yang harus dipilih untuk ke Blok M?",
                answers: [
                    Answer(title: "Jalur Satu", isCorrect: false),
                    Answer(title: "Jalur Dua", isCorrect: true),
                    Answer(title: "Jalur Empat", isCorrect: false),
                    Answer(title: "Jalur Lima", isCorrect: false),
                ]
            ),
        ],
        [
            Question(
                text: "Diskon diadakan di hari apa?",
                answers: [
                    Answer(title: "Senin", isCorrect: true),
                    Answer(title: "Selasa", isCorrect: false),
                    Answer(title: "Rabu", isCorrect: false),
                    Answer(title: "Kamis", isCorrect: false),
                ]
            ),
            Question(
                text: "Jam berapa file harus dikirim?",
                answers: [
                    Answer(title: "Besok Sore", isCorrect: false),
                    Answer(title: "Jam 7 Malam", isCorrect: false),
                    Answer(title: "Sebelum Pukul 5 Sore", isCorrect: false),
                    Answer(title: "Sebelum Pukul 6 Sore", isCorrect: true),
                ]
            ),
            Question(
                text: "Mengapa banyak yang belum mengetahui perubahan jadwal?",
                answers: [

                    Answer(
                        title: "Karena informasi melewati SMS",
                        isCorrect: false
                    ),
                    Answer(
                        title: "Informasi via mulut ke mulut",
                        isCorrect: false
                    ),
                    Answer(
                        title: "Email baru dikirim siang ini",
                        isCorrect: true
                    ),
                    Answer(title: "Diumumkan di resepsionis", isCorrect: false),
                ]
            ),
            Question(
                text: "Vendor apa yang harus dihubungi hari ini?",
                answers: [
                    Answer(title: "Cathering", isCorrect: true),
                    Answer(title: "Dekorasi", isCorrect: false),
                    Answer(title: "Make Up", isCorrect: false),
                    Answer(title: "Keamanan", isCorrect: false),
                ]
            ),
            Question(
                text: "Apa fokus utama tim minggu ini?",
                answers: [
                    Answer(
                        title: "Memastikan sistem pendingin stabil",
                        isCorrect: true
                    ),
                    Answer(
                        title: "Menguji kapasitas mesin di suhu tinggi",
                        isCorrect: false
                    ),
                    Answer(
                        title: "Memanggil teknisi berpengalaman",
                        isCorrect: false
                    ),
                    Answer(title: "Servis mesin lama", isCorrect: false),
                ]
            ),
        ],

    ]
}
