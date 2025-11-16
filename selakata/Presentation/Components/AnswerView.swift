import SwiftUI

enum AnswerLayout {
    case list
    case grid(columns: Int)
}

struct AnswerView: View {
    let question: Question
    let selectedAnswer: Answer?
    let hasAnswered: Bool
    let layout: AnswerLayout
    let onSelect: (Answer) -> Void

    var sortedAnswers: [Answer] {
        question.answerList.sorted { $0.urutan < $1.urutan }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Question Text
            Text(question.text)
                .font(.app(.body))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer().frame(height: 8)

            // Answers
            switch layout {
            case .grid(let columns):
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: 12),
                        count: columns
                    ),
                    spacing: 12
                ) {
                    ForEach(sortedAnswers, id: \.id) { answer in
                        let isSelected = selectedAnswer?.id == answer.id
                        // Only show correct/wrong status for selected answer
                        let showStatus = hasAnswered && isSelected
                        let isCorrect = showStatus ? answer.isCorrect : nil
                        let isWrong = showStatus && !answer.isCorrect

                        AnswerButton(
                            answer: answer,
                            isSelected: isSelected,
                            isCorrect: isCorrect,
                            isWrong: isWrong,
                            onTap: {
                                if !hasAnswered {
                                    onSelect(answer)
                                }
                            }
                        )
                    }
                }

            case .list:
                VStack(spacing: 12) {
                    ForEach(sortedAnswers, id: \.id) { answer in
                        let isSelected = selectedAnswer?.id == answer.id
                        // Only show correct/wrong status for selected answer
                        let showStatus = hasAnswered && isSelected
                        let isCorrect = showStatus ? answer.isCorrect : nil
                        let isWrong = showStatus && !answer.isCorrect

                        AnswerButton(
                            answer: answer,
                            isSelected: isSelected,
                            isCorrect: isCorrect,
                            isWrong: isWrong,
                            onTap: {
                                if !hasAnswered {
                                    onSelect(answer)
                                }
                            }
                        )
                    }

                }
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview("List Layout - Not Answered") {
    AnswerView(
        question: Question(
            id: "1",
            text: "Apa yang kamu dengar?",
            urutan: 1,
            mainRMS: 0.8,
            noiseRMS: 0.2,
            isActive: true,
            snr: 8.0,
            poin: 10,
            type: 1,
            createdAt: "2024-11-16",
            updatedAt: "2024-11-16",
            updatedBy: "system",
            answerList: [
                Answer(
                    id: "1",
                    text: "Kucing",
                    urutan: 1,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "2",
                    text: "Anjing",
                    urutan: 2,
                    isCorrect: true,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "3",
                    text: "Burung",
                    urutan: 3,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "4",
                    text: "Ikan",
                    urutan: 4,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
            ],
            audioFile: nil,
            noiseFile: nil
        ),
        selectedAnswer: nil,
        hasAnswered: false,
        layout: .list,
        onSelect: { answer in
            print("Selected: \(answer.text)")
        }
    )
    .padding()
}

#Preview("List Layout - Answered Correct") {
    AnswerView(
        question: Question(
            id: "1",
            text: "Apa yang kamu dengar?",
            urutan: 1,
            mainRMS: 0.8,
            noiseRMS: 0.2,
            isActive: true,
            snr: 8.0,
            poin: 10,
            type: 1,
            createdAt: "2024-11-16",
            updatedAt: "2024-11-16",
            updatedBy: "system",
            answerList: [
                Answer(
                    id: "1",
                    text: "Kucing",
                    urutan: 1,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "2",
                    text: "Anjing",
                    urutan: 2,
                    isCorrect: true,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "3",
                    text: "Burung",
                    urutan: 3,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "4",
                    text: "Ikan",
                    urutan: 4,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
            ],
            audioFile: nil,
            noiseFile: nil
        ),
        selectedAnswer: Answer(
            id: "2",
            text: "Anjing",
            urutan: 2,
            isCorrect: true,
            createdAt: "2024-11-16",
            updatedAt: "2024-11-16"
        ),
        hasAnswered: true,
        layout: .list,
        onSelect: { answer in
            print("Selected: \(answer.text)")
        }
    )
    .padding()
}

#Preview("List Layout - Answered Wrong") {
    AnswerView(
        question: Question(
            id: "1",
            text: "Apa yang kamu dengar?",
            urutan: 1,
            mainRMS: 0.8,
            noiseRMS: 0.2,
            isActive: true,
            snr: 8.0,
            poin: 10,
            type: 1,
            createdAt: "2024-11-16",
            updatedAt: "2024-11-16",
            updatedBy: "system",
            answerList: [
                Answer(
                    id: "1",
                    text: "Kucing",
                    urutan: 1,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "2",
                    text: "Anjing",
                    urutan: 2,
                    isCorrect: true,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "3",
                    text: "Burung",
                    urutan: 3,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "4",
                    text: "Ikan",
                    urutan: 4,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
            ],
            audioFile: nil,
            noiseFile: nil
        ),
        selectedAnswer: Answer(
            id: "1",
            text: "Kucing",
            urutan: 1,
            isCorrect: false,
            createdAt: "2024-11-16",
            updatedAt: "2024-11-16"
        ),
        hasAnswered: true,
        layout: .list,
        onSelect: { answer in
            print("Selected: \(answer.text)")
        }
    )
    .padding()
}

#Preview("Grid Layout - 2 Columns") {
    AnswerView(
        question: Question(
            id: "1",
            text: "Pilih gambar yang sesuai dengan audio",
            urutan: 1,
            mainRMS: 0.8,
            noiseRMS: 0.2,
            isActive: true,
            snr: 8.0,
            poin: 10,
            type: 1,
            createdAt: "2024-11-16",
            updatedAt: "2024-11-16",
            updatedBy: "system",
            answerList: [
                Answer(
                    id: "1",
                    text: "🐱",
                    urutan: 1,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "2",
                    text: "🐶",
                    urutan: 2,
                    isCorrect: true,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "3",
                    text: "🐦",
                    urutan: 3,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
                Answer(
                    id: "4",
                    text: "🐠",
                    urutan: 4,
                    isCorrect: false,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                ),
            ],
            audioFile: nil,
            noiseFile: nil
        ),
        selectedAnswer: nil,
        hasAnswered: false,
        layout: .grid(columns: 2),
        onSelect: { answer in
            print("Selected: \(answer.text)")
        }
    )
    .padding()
}
