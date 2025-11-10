//
//  QuizData.swift
//  selakata
//
//  Created by ais on 23/10/25.
//
import Foundation

struct QuestionDummy {
    let id = UUID()
    let text: String
    let answers: [AnswerDummy]
}

struct AnswerDummy: Identifiable {
    let id = UUID()
    let title: String
    let isCorrect: Bool
    
    init(title: String, isCorrect: Bool = false) {
        self.title = title
        self.isCorrect = isCorrect
    }
}

struct QuizData {
    //dummy for Module - Complete with all quiz data
    static let dummyModule: [Module] = [
        // Audio Identification Module
        Module(
            id: UUID(),
            label: "Identification",
            desc: "Test kemampuan identifikasi suara dan kata",
            isActive: true,
            createdAt: "2024-11-02",
            updatedAt: "2024-11-02",
            updatedBy: "system",
            levelList: [
                // Easy Level
                Level(
                    id: UUID(),
                    label: "Easy",
                    value: 1,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: identificationQuestions[0].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 80,
                            noiseVolume: 20,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioIdentification[0][index]).mp3",
                                fileURL: audioIdentification[0][index],
                                size: 1024,
                                duration: 3,
                                snr: 8,
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: false,
                                type: 1,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                ),
                // Medium Level
                Level(
                    id: UUID(),
                    label: "Medium",
                    value: 2,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: identificationQuestions[1].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 75,
                            noiseVolume: 25,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioIdentification[1][index]).mp3",
                                fileURL: audioIdentification[1][index],
                                size: 1024,
                                duration: 3,
                                snr: 5,
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: false,
                                type: 1,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                ),
                // Hard Level
                Level(
                    id: UUID(),
                    label: "Hard",
                    value: 3,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: identificationQuestions[2].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 70,
                            noiseVolume: 30,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioIdentification[2][index]).mp3",
                                fileURL: audioIdentification[2][index],
                                size: 1024,
                                duration: 3,
                                snr: 3,
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: false,
                                type: 1,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                )
            ]
        ),
        
        // Audio Discrimination Module
        Module(
            id: UUID(),
            label: "Discrimination",
            desc: "Test kemampuan diskriminasi suara",
            isActive: true,
            createdAt: "2024-11-02",
            updatedAt: "2024-11-02",
            updatedBy: "system",
            levelList: [
                // Easy Level
                Level(
                    id: UUID(),
                    label: "Easy",
                    value: 1,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: discriminationQuestions[0].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 80,
                            noiseVolume: 20,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioDiscrimintion[0][index]).mp3",
                                fileURL: audioDiscrimintion[0][index],
                                size: 1024,
                                duration: 3,
                                snr: 8,
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: false,
                                type: 2,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                ),
                // Medium Level
                Level(
                    id: UUID(),
                    label: "Medium",
                    value: 2,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: discriminationQuestions[1].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 75,
                            noiseVolume: 25,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioDiscrimintion[1][index]).mp3",
                                fileURL: audioDiscrimintion[1][index],
                                size: 1024,
                                duration: 3,
                                snr: 5,
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: false,
                                type: 2,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                ),
                // Hard Level
                Level(
                    id: UUID(),
                    label: "Hard",
                    value: 3,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: discriminationQuestions[2].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 70,
                            noiseVolume: 30,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioDiscrimintion[2][index]).mp3",
                                fileURL: audioDiscrimintion[2][index],
                                size: 1024,
                                duration: 3,
                                snr: 3,
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: false,
                                type: 2,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                )
            ]
        ),
        
        // Audio Comprehension Module
        Module(
            id: UUID(),
            label: "Comprehension",
            desc: "Test kemampuan pemahaman audio",
            isActive: true,
            createdAt: "2024-11-02",
            updatedAt: "2024-11-02",
            updatedBy: "system",
            levelList: [
                // Easy Level
                Level(
                    id: UUID(),
                    label: "Easy",
                    value: 1,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: comprehensionQuestions[0].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 80,
                            noiseVolume: 20,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioComprehension[0][index]).mp3",
                                fileURL: audioComprehension[0][index],
                                size: 1024,
                                duration: 5,
                                snr: 8,
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: false,
                                type: 3,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                ),
                // Medium Level
                Level(
                    id: UUID(),
                    label: "Medium",
                    value: 2,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: comprehensionQuestions[1].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 75,
                            noiseVolume: 25,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioComprehension[1][index]).mp3",
                                fileURL: audioComprehension[1][index],
                                size: 1024,
                                duration: 5,
                                snr: 5,
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: false,
                                type: 3,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                ),
                // Hard Level
                Level(
                    id: UUID(),
                    label: "Hard",
                    value: 3,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: comprehensionQuestions[2].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 70,
                            noiseVolume: 30,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioComprehension[2][index]).mp3",
                                fileURL: audioComprehension[2][index],
                                size: 1024,
                                duration: 5,
                                snr: 3,
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: false,
                                type: 3,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                )
            ]
        ),
        
        // Competing Speaker Module
        Module(
            id: UUID(),
            label: "Competing Speaker",
            desc: "Test kemampuan mendengar dalam lingkungan bising",
            isActive: true,
            createdAt: "2024-11-02",
            updatedAt: "2024-11-02",
            updatedBy: "system",
            levelList: [
                // Level II
                Level(
                    id: UUID(),
                    label: "Level II",
                    value: 2,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: computationSpeakerQuestions[0].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 70,
                            noiseVolume: 30,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioCompetingSpeaker[0][index]).mp3",
                                fileURL: audioCompetingSpeaker[0][index],
                                size: 2048,
                                duration: 8,
                                snr: [8, 5, 5, 3, 0][index],
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: true,
                                type: 4,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                ),
                // Level III
                Level(
                    id: UUID(),
                    label: "Level III",
                    value: 3,
                    isActive: true,
                    createdAt: "2024-11-02",
                    updatedAt: "2024-11-02",
                    updatedBy: "system",
                    question: computationSpeakerQuestions[1].enumerated().map { index, question in
                        LocalQuestion(
                            id: UUID(),
                            text: question.text,
                            urutan: index + 1,
                            mainVolume: 65,
                            noiseVolume: 35,
                            createdAt: "2024-11-02",
                            updatedAt: "2024-11-02",
                            updatedBy: "system",
                            audioFile: LocalAudioFile(
                                id: UUID(),
                                fileName: "\(audioCompetingSpeaker[1][index]).mp3",
                                fileURL: audioCompetingSpeaker[1][index],
                                size: 2048,
                                duration: 8,
                                snr: [8, 5, 5, 3, 0][index],
                                voiceId: "voice001",
                                voiceName: "Default Voice",
                                similiarityBoost: 0.75,
                                speed: 1.0,
                                stability: 0.8,
                                useSpeakerBoost: true,
                                type: 4,
                                createdAt: "2024-11-02",
                                updatedAt: "2024-11-02",
                                updatedBy: "system"
                            ),
                            answer: question.answers.enumerated().map { answerIndex, answer in
                                LocalAnswer(
                                    id: UUID(),
                                    text: answer.title,
                                    urutan: answerIndex + 1,
                                    isCorrect: answer.isCorrect,
                                    createdAt: "2024-11-02",
                                    updatedAt: "2024-11-02"
                                )
                            }
                        )
                    }
                )
            ]
        )
    ] 
    
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

    static let audioCompetingSpeaker: [[String]] = [
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
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Pipi", isCorrect: false),
                    AnswerDummy(title: "Tepi", isCorrect: false),
                    AnswerDummy(title: "Topi", isCorrect: true),
                    AnswerDummy(title: "Sapi", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Duku", isCorrect: false),
                    AnswerDummy(title: "Buku", isCorrect: true),
                    AnswerDummy(title: "Suku", isCorrect: false),
                    AnswerDummy(title: "Lugu", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Rapu", isCorrect: false),
                    AnswerDummy(title: "Saku", isCorrect: true),
                    AnswerDummy(title: "Satu", isCorrect: false),
                    AnswerDummy(title: "Sapu", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Kuta", isCorrect: false),
                    AnswerDummy(title: "Rupa", isCorrect: false),
                    AnswerDummy(title: "Supa", isCorrect: false),
                    AnswerDummy(title: "Kuda", isCorrect: true),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Kaki", isCorrect: true),
                    AnswerDummy(title: "Sari", isCorrect: false),
                    AnswerDummy(title: "Dari", isCorrect: false),
                    AnswerDummy(title: "Maki", isCorrect: false),
                ]
            ),
        ],
        [
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Gatal", isCorrect: false),
                    AnswerDummy(title: "Kapal", isCorrect: true),
                    AnswerDummy(title: "Kapan", isCorrect: false),
                    AnswerDummy(title: "Kapas", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Menggigil", isCorrect: false),
                    AnswerDummy(title: "Memanggil", isCorrect: true),
                    AnswerDummy(title: "Menggunting", isCorrect: false),
                    AnswerDummy(title: "Menggigit", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Jendara", isCorrect: false),
                    AnswerDummy(title: "Jendral", isCorrect: false),
                    AnswerDummy(title: "Jendela", isCorrect: true),
                    AnswerDummy(title: "Jembala", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Lembaran", isCorrect: true),
                    AnswerDummy(title: "Lebaran", isCorrect: false),
                    AnswerDummy(title: "Jembaran", isCorrect: false),
                    AnswerDummy(title: "Jembatan", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Belajar", isCorrect: true),
                    AnswerDummy(title: "Pelajar", isCorrect: false),
                    AnswerDummy(title: "Selancar", isCorrect: false),
                    AnswerDummy(title: "Derajat", isCorrect: false),
                ]
            ),
        ],
        [
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Komuter", isCorrect: false),
                    AnswerDummy(title: "Komputer", isCorrect: true),
                    AnswerDummy(title: "Komputel", isCorrect: false),
                    AnswerDummy(title: "Komputes", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Menari", isCorrect: true),
                    AnswerDummy(title: "Menarik", isCorrect: false),
                    AnswerDummy(title: "Menaruh", isCorrect: false),
                    AnswerDummy(title: "Memercik", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Kegaduhan", isCorrect: false),
                    AnswerDummy(title: "Kerapuhan", isCorrect: false),
                    AnswerDummy(title: "Kepatuhan", isCorrect: true),
                    AnswerDummy(title: "Keputusan", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Kecipratan", isCorrect: false),
                    AnswerDummy(title: "Kepintaran", isCorrect: false),
                    AnswerDummy(title: "Kecintaan", isCorrect: true),
                    AnswerDummy(title: "Keciptaan", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa kata yang diucapkan?",
                answers: [
                    AnswerDummy(title: "Keseringan", isCorrect: false),
                    AnswerDummy(title: "Kesenian", isCorrect: true),
                    AnswerDummy(title: "Keserian", isCorrect: false),
                    AnswerDummy(title: "Kesekian", isCorrect: false),
                ]
            ),
        ],
    ]

    static let discriminationQuestions = [
        [
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Botol", isCorrect: false),
                    AnswerDummy(title: "Bosan", isCorrect: true),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Dara", isCorrect: false),
                    AnswerDummy(title: "Dasi", isCorrect: true),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Layu", isCorrect: true),
                    AnswerDummy(title: "Layar", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Makan", isCorrect: true),
                    AnswerDummy(title: "Mandi", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Panjang", isCorrect: true),
                    AnswerDummy(title: "Ranjang", isCorrect: false),
                ]
            ),
        ],
        [
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Anting", isCorrect: true),
                    AnswerDummy(title: "Anjing", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Gayung", isCorrect: false),
                    AnswerDummy(title: "Dayung", isCorrect: true),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Gusur", isCorrect: true),
                    AnswerDummy(title: "Gugur", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Kasir", isCorrect: false),
                    AnswerDummy(title: "Pasir", isCorrect: true),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Risau", isCorrect: false),
                    AnswerDummy(title: "Pisau", isCorrect: true),
                ]
            ),
        ],
        [
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Ingin", isCorrect: false),
                    AnswerDummy(title: "Dingin", isCorrect: true),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Persiapan", isCorrect: true),
                    AnswerDummy(title: "Perpisahan", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Pintu Kata", isCorrect: true),
                    AnswerDummy(title: "Pintu Kaca", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Obat", isCorrect: false),
                    AnswerDummy(title: "Sempat", isCorrect: true),
                ]
            ),
            QuestionDummy(
                text: "Yang manakah suaranya?",
                answers: [
                    AnswerDummy(title: "Sifat Buruk", isCorrect: true),
                    AnswerDummy(title: "Sikap Buruk", isCorrect: false),
                ]
            ),
        ],
    ]

    static let comprehensionQuestions = [
        [
            QuestionDummy(
                text: "Apa yang Rina Minum?",
                answers: [
                    AnswerDummy(title: "Es", isCorrect: false),
                    AnswerDummy(title: "Jus", isCorrect: true),
                    AnswerDummy(title: "Kopi", isCorrect: false),
                    AnswerDummy(title: "Teh", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Kata sebelum \"dengan\" adalah?",
                answers: [
                    AnswerDummy(title: "Tahun", isCorrect: true),
                    AnswerDummy(title: "Memotong", isCorrect: false),
                    AnswerDummy(title: "Adik", isCorrect: false),
                    AnswerDummy(title: "Pisau", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa yang ayah perbaiki?",
                answers: [
                    AnswerDummy(title: "Motor", isCorrect: false),
                    AnswerDummy(title: "Sepeda", isCorrect: false),
                    AnswerDummy(title: "Mobil", isCorrect: true),
                    AnswerDummy(title: "Gerobak", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Kata sebelum \"sambil\" adalah?",
                answers: [
                    AnswerDummy(title: "Taman", isCorrect: true),
                    AnswerDummy(title: "Santai", isCorrect: false),
                    AnswerDummy(title: "Berjalan", isCorrect: false),
                    AnswerDummy(title: "Tongkat", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Kata sebelum \"makan\" adalah?",
                answers: [
                    AnswerDummy(title: "Piring", isCorrect: false),
                    AnswerDummy(title: "Untuk", isCorrect: false),
                    AnswerDummy(title: "Setelah", isCorrect: true),
                    AnswerDummy(title: "Ibunya", isCorrect: false),
                ]
            ),
        ],
        [
            QuestionDummy(
                text: "Kenapa Budi berhenti di perjalanan?",
                answers: [
                    AnswerDummy(title: "Ban motor bocor", isCorrect: false),
                    AnswerDummy(title: "Ada ujian Mendadak", isCorrect: false),
                    AnswerDummy(title: "Karena hujan", isCorrect: true),
                    AnswerDummy(title: "Sekolahnya tutup", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa yang Dina lupakan?",
                answers: [
                    AnswerDummy(title: "Bucket", isCorrect: false),
                    AnswerDummy(title: "Totebag", isCorrect: false),
                    AnswerDummy(title: "Dompet", isCorrect: true),
                    AnswerDummy(title: "Songket", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Mengapa Andi meminta adiknya mengecilkan suara TV?",
                answers: [
                    AnswerDummy(
                        title: "Karena Andi sedang rekaman",
                        isCorrect: false
                    ),
                    AnswerDummy(title: "Karena Andi sedang sakit", isCorrect: false),
                    AnswerDummy(
                        title: "Karena Andi sedang belajar",
                        isCorrect: true
                    ),
                    AnswerDummy(title: "Karena Andi kebisingan", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa yang dilakukan Raka saat koneksinya terputus??",
                answers: [
                    AnswerDummy(title: "Merestart Wi-Fi", isCorrect: false),
                    AnswerDummy(title: "Menyalakan hotspot", isCorrect: true),
                    AnswerDummy(title: "Membeli paket data", isCorrect: false),
                    AnswerDummy(
                        title: "Menghubungi service provider",
                        isCorrect: false
                    ),
                ]
            ),
            QuestionDummy(
                text: "Kenapa Sinta mengganti menu makan malamnya?",
                answers: [
                    AnswerDummy(title: "Karena gas habis", isCorrect: false),
                    AnswerDummy(title: "Karena saus tomat habis", isCorrect: true),
                    AnswerDummy(title: "Karena moodnya habis", isCorrect: false),
                    AnswerDummy(title: "Karena pastanya habis", isCorrect: false),
                ]
            ),
        ],
        [
            QuestionDummy(
                text: "Apa yang sebenarnya Mia pesan?",
                answers: [
                    AnswerDummy(title: "Salad dan jus mangga", isCorrect: false),
                    AnswerDummy(title: "Salad dan jus jeruk", isCorrect: true),
                    AnswerDummy(title: "Salad dan martabak telur", isCorrect: false),
                    AnswerDummy(title: "Salad dan alpukat", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Pukul berapa seharusnya kereta berangkat?",
                answers: [
                    AnswerDummy(title: "Pukul setengah tiga sore", isCorrect: false),
                    AnswerDummy(title: "Pukul lima sore", isCorrect: false),
                    AnswerDummy(title: "Pukul tiga sore", isCorrect: true),
                    AnswerDummy(title: "Pukul setengah lima sore", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Pukul berapa ujian dimulai?",
                answers: [
                    AnswerDummy(title: "Pukul 1 siang", isCorrect: false),
                    AnswerDummy(title: "Pukul 9", isCorrect: false),
                    AnswerDummy(title: "Pukul 9.30", isCorrect: true),
                    AnswerDummy(title: "Pukul 8.30", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Makanan apa yang dirasa Rani kurang asin?",
                answers: [
                    AnswerDummy(title: "Sop", isCorrect: true),
                    AnswerDummy(title: "Pastry", isCorrect: false),
                    AnswerDummy(title: "Sayur", isCorrect: false),
                    AnswerDummy(title: "Lodeh", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa yang seharusnya dipesan oleh Dafa?",
                answers: [
                    AnswerDummy(title: "Pasta", isCorrect: false),
                    AnswerDummy(title: "Pastry", isCorrect: true),
                    AnswerDummy(title: "Spagetthi", isCorrect: false),
                    AnswerDummy(title: "Sandwich", isCorrect: false),
                ]
            ),
        ],
    ]

    static let computationSpeakerQuestions = [
        [
            QuestionDummy(
                text: "Kenapa Nathan tidak ikut main basket hari ini?",
                answers: [
                    AnswerDummy(title: "Karena sedang berlibur", isCorrect: false),
                    AnswerDummy(title: "Karena sedang sakit", isCorrect: true),
                    AnswerDummy(title: "Karena ada tugas dadakan", isCorrect: false),
                    AnswerDummy(title: "Karena besok ulangan", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa minuman yang diminum pembicara utama hari ini?",
                answers: [
                    AnswerDummy(title: "Americano", isCorrect: false),
                    AnswerDummy(title: "Coffe Latte", isCorrect: false),
                    AnswerDummy(title: "Cappucino", isCorrect: true),
                    AnswerDummy(title: "Espresso", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Kegiatan apa yang sering pembaca lakukan di pagi hari?",
                answers: [
                    AnswerDummy(title: "Memeriksa email dan membuat daftar tugas", isCorrect: true),
                    AnswerDummy(title: "Memperbaiki pekerjaan hari kemarin", isCorrect: false),
                    AnswerDummy(title: "Membuat email untuk mengirim tugas", isCorrect: false),
                    AnswerDummy(title: "Membuat daftar tugas untuk laporan", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Kapan laporan di tim harus dikumpulkan?",
                answers: [
                    AnswerDummy(title: "Hari Selasa", isCorrect: true),
                    AnswerDummy(title: "Hari Senin", isCorrect: false),
                    AnswerDummy(title: "Hari Rabu", isCorrect: false),
                    AnswerDummy(title: "Hari Jum'at", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Jalur berapa yang harus dipilih untuk ke Blok M?",
                answers: [
                    AnswerDummy(title: "Jalur Satu", isCorrect: false),
                    AnswerDummy(title: "Jalur Dua", isCorrect: true),
                    AnswerDummy(title: "Jalur Empat", isCorrect: false),
                    AnswerDummy(title: "Jalur Lima", isCorrect: false),
                ]
            ),
        ],
        [
            QuestionDummy(
                text: "Diskon diadakan di hari apa?",
                answers: [
                    AnswerDummy(title: "Senin", isCorrect: true),
                    AnswerDummy(title: "Selasa", isCorrect: false),
                    AnswerDummy(title: "Rabu", isCorrect: false),
                    AnswerDummy(title: "Kamis", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Jam berapa file harus dikirim?",
                answers: [
                    AnswerDummy(title: "Besok Sore", isCorrect: false),
                    AnswerDummy(title: "Jam 7 Malam", isCorrect: false),
                    AnswerDummy(title: "Sebelum Pukul 5 Sore", isCorrect: false),
                    AnswerDummy(title: "Sebelum Pukul 6 Sore", isCorrect: true),
                ]
            ),
            QuestionDummy(
                text: "Mengapa banyak yang belum mengetahui perubahan jadwal?",
                answers: [
                    AnswerDummy(title: "Karena informasi melewati SMS", isCorrect: false),
                    AnswerDummy(title: "Informasi via mulut ke mulut", isCorrect: false),
                    AnswerDummy(title: "Email baru dikirim siang ini", isCorrect: true),
                    AnswerDummy(title: "Diumumkan di resepsionis", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Vendor apa yang harus dihubungi hari ini?",
                answers: [
                    AnswerDummy(title: "Cathering", isCorrect: true),
                    AnswerDummy(title: "Dekorasi", isCorrect: false),
                    AnswerDummy(title: "Make Up", isCorrect: false),
                    AnswerDummy(title: "Keamanan", isCorrect: false),
                ]
            ),
            QuestionDummy(
                text: "Apa fokus utama tim minggu ini?",
                answers: [
                    AnswerDummy(title: "Memastikan sistem pendingin stabil", isCorrect: true),
                    AnswerDummy(title: "Menguji kapasitas mesin di suhu tinggi", isCorrect: false),
                    AnswerDummy(title: "Memanggil teknisi berpengalaman", isCorrect: false),
                    AnswerDummy(title: "Servis mesin lama", isCorrect: false),
                ]
            ),
        ],

    ]
}
