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
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Answers
            switch layout {
            case .grid(let columns):
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: columns), spacing: 12) {
                    ForEach(sortedAnswers, id: \.id) { answer in
                        let isSelected = selectedAnswer?.id == answer.id
                        let isCorrect = hasAnswered ? answer.isCorrect : nil
                        let isWrong = hasAnswered && isSelected && !answer.isCorrect
                        
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
                        let isCorrect = hasAnswered ? answer.isCorrect : nil
                        let isWrong = hasAnswered && isSelected && !answer.isCorrect
                        
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
    }
}
