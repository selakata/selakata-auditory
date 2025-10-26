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
    let hasAnswered: Bool
    let action: () -> Void
    
    var borderColor: Color {
        if hasAnswered && isSelected {
            return answer.isCorrect ? .blue : .red
        } else if hasAnswered && answer.isCorrect {
            // Show correct answer in blue even if not selected
            return .blue
        } else {
            return Color(.separator)
        }
    }
    
    var backgroundColor: Color {
        if hasAnswered && isSelected {
            return answer.isCorrect ? .blue.opacity(0.1) : .red.opacity(0.1)
        } else if hasAnswered && answer.isCorrect {
            return .blue.opacity(0.05)
        } else {
            return .clear
        }
    }

    var body: some View {
        Button(action: action) {
            Text(answer.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(.darkGray))
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            borderColor,
                            lineWidth: 1.5
                        )
                )
                .cornerRadius(10)
        }
        .disabled(hasAnswered)
    }
}

#Preview {
    VStack(spacing: 10) {
        AnswerRow(
            answer: Answer(title: "Correct Answer", isCorrect: true), 
            isSelected: true, 
            hasAnswered: true, 
            action: {}
        )
        
        AnswerRow(
            answer: Answer(title: "Wrong Answer", isCorrect: false), 
            isSelected: true, 
            hasAnswered: true, 
            action: {}
        )
        
        AnswerRow(
            answer: Answer(title: "Not Selected", isCorrect: false), 
            isSelected: false, 
            hasAnswered: false, 
            action: {}
        )
    }
    .padding()
}
