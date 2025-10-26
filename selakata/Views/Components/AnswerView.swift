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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if question.text.isEmpty == false {
                Text(question.text)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
                    .frame(maxWidth: .infinity)
            }
            Spacer().frame(height: 8)
            switch layout {
            case .list:
                VStack(spacing: 10) {
                    ForEach(question.answers) { answer in
                        AnswerRow(
                            answer: answer,
                            isSelected: selectedAnswer?.id == answer.id,
                            hasAnswered: hasAnswered,
                            action: { onSelect(answer) }
                        )
                    }
                }
                
            case .grid(let columns):
                let gridItems = Array(repeating: GridItem(.flexible(), spacing: 10), count: columns)
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(question.answers) { answer in
                        AnswerRow(
                            answer: answer,
                            isSelected: selectedAnswer?.id == answer.id,
                            hasAnswered: hasAnswered,
                            action: { onSelect(answer) }
                        )
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    let question = Question(
        text: "Apa alasan kamu tidak masuk?",
        answers: [
            Answer(title: "Sakit"),
            Answer(title: "Melayat"),
            Answer(title: "Cuti"),
            Answer(title: "Urusan keluarga")
        ]
    )
    
    VStack(spacing: 30) {
        // Versi List (column)
        AnswerView(
            question: question,
            selectedAnswer: nil,
            hasAnswered: false,
            layout: .list,
            onSelect: { _ in }
        )
        
        // Versi Grid (2 kolom)
        AnswerView(
            question: question,
            selectedAnswer: nil,
            hasAnswered: false,
            layout: .grid(columns: 2),
            onSelect: { _ in }
        )
    }
    .padding()
}
