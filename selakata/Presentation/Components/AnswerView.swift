import SwiftUI

enum AnswerLayout {
    case list
    case grid(columns: Int)
}

struct AnswerView: View {
    let question: LocalQuestion
    let selectedAnswer: LocalAnswer?
    let hasAnswered: Bool
    let layout: AnswerLayout
    let onSelect: (LocalAnswer) -> Void
    
    var sortedAnswers: [LocalAnswer] {
        question.answer.sorted { $0.urutan < $1.urutan }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Question Text
            Text(question.text)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Answers
            switch layout {
            case .grid(let columns):
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: columns), spacing: 12) {
                    ForEach(sortedAnswers, id: \.id) { answer in
                        AnswerButton(
                            answer: answer,
                            isSelected: selectedAnswer?.id == answer.id,
                            isCorrect: hasAnswered ? answer.isCorrect : nil,
                            isWrong: hasAnswered && selectedAnswer?.id == answer.id && !answer.isCorrect,
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
                        AnswerButton(
                            answer: answer,
                            isSelected: selectedAnswer?.id == answer.id,
                            isCorrect: hasAnswered ? answer.isCorrect : nil,
                            isWrong: hasAnswered && selectedAnswer?.id == answer.id && !answer.isCorrect,
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
    }
}
