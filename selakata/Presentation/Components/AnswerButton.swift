//
//  AnswerButton.swift
//  selakata
//
//  Created by ais on 02/11/25.
//
import Foundation
import SwiftUI

struct AnswerButton: View {
    let answer: LocalAnswer
    let isSelected: Bool
    let isCorrect: Bool?
    let isWrong: Bool
    let onTap: () -> Void
    
    var backgroundColor: Color {
        if let isCorrect = isCorrect {
            if isCorrect {
                return .green.opacity(0.2)
            } else if isWrong {
                return .red.opacity(0.2)
            }
        }
        
        if isSelected {
            return .blue.opacity(0.2)
        }
        
        return Color(.systemGray6)
    }
    
    var borderColor: Color {
        if let isCorrect = isCorrect {
            if isCorrect {
                return .green
            } else if isWrong {
                return .red
            }
        }
        
        if isSelected {
            return .blue
        }
        
        return .clear
    }
    
    var textColor: Color {
        if let isCorrect = isCorrect {
            if isCorrect {
                return .green
            } else if isWrong {
                return .red
            }
        }
        
        return .primary
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(answer.text)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if let isCorrect = isCorrect {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                        .font(.title3)
                } else if isSelected {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .disabled(isCorrect != nil)
    }
}

#Preview {
    VStack(spacing: 20) {
        AnswerView(
            question: QuizData.dummyModule[0].levelList[0].question[0],
            selectedAnswer: nil,
            hasAnswered: false,
            layout: .grid(columns: 2),
            onSelect: { _ in }
        )
        
        AnswerView(
            question: QuizData.dummyModule[2].levelList[0].question[0],
            selectedAnswer: nil,
            hasAnswered: false,
            layout: .list,
            onSelect: { _ in }
        )
    }
    .padding()
}
