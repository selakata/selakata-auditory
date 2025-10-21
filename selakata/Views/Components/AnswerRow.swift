//
//  AnswerRow.swift
//  selakata
//
//  Created by ais on 21/10/25.
//
import SwiftUI

struct AnswerRow: View {
    let answer: Answer
    let isSelected: Bool
    let action: () -> Void
    
    var borderColor: Color {
        if isSelected {
            return answer.isCorrect ? .blue : .red
        } else {
            return Color(.separator)
        }
    }

    var body: some View {
        Button(action: action) {
            Text(answer.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(.darkGray))
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            borderColor,
                            lineWidth: 1.5
                        )
                )
        }
    }
}

#Preview {
    AnswerRow(answer: Answer(title: "User"), isSelected: false, action: {})
}
