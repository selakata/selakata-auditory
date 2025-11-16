//
//  AnswerButton.swift
//  selakata
//
//  Created by ais on 02/11/25.
//
import Foundation
import SwiftUI

struct AnswerButton: View {
    let answer: Answer
    let isSelected: Bool
    let isCorrect: Bool?
    let isWrong: Bool
    let onTap: () -> Void

    var backgroundColor: Color {
        if let isCorrect = isCorrect {
            if isCorrect {
                return .Primary._200
            } else if isWrong {
                return .red.opacity(0.1)
            }
        }

        if isSelected {
            return .white.opacity(0)
        }

        return .white.opacity(0)
    }

    var borderColor: Color {
        if let isCorrect = isCorrect {
            if isCorrect {
                return .Primary._500
            } else if isWrong {
                return .red.opacity(0.5)
            }
        }

        if isSelected {
            return Color.Default._200
        }

        return Color.Default._200
    }

    var textColor: Color {
        if let isCorrect = isCorrect {
            if isCorrect {
                return .Primary._500
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
                    Image(
                        systemName: isCorrect
                            ? "checkmark.circle.fill" : "xmark.circle.fill"
                    )
                    .foregroundColor(
                        isCorrect ? .Primary._500 : .red.opacity(0.5)
                    )
                    .font(.title3)
                } else if isSelected {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isCorrect != nil)
    }
}

#Preview("Default State") {
    VStack(spacing: 16) {
        AnswerButton(
            answer: Answer(
                id: "1",
                text: "Kucing",
                urutan: 1,
                isCorrect: false,
                createdAt: "2024-11-16",
                updatedAt: "2024-11-16"
            ),
            isSelected: false,
            isCorrect: nil,
            isWrong: false,
            onTap: { print("Tapped") }
        )
    }
    .padding()
}

#Preview("Selected State") {
    VStack(spacing: 16) {
        AnswerButton(
            answer: Answer(
                id: "1",
                text: "Anjing",
                urutan: 1,
                isCorrect: true,
                createdAt: "2024-11-16",
                updatedAt: "2024-11-16"
            ),
            isSelected: true,
            isCorrect: nil,
            isWrong: false,
            onTap: { print("Tapped") }
        )
    }
    .padding()
}

#Preview("Correct Answer") {
    VStack(spacing: 16) {
        AnswerButton(
            answer: Answer(
                id: "1",
                text: "Burung",
                urutan: 1,
                isCorrect: true,
                createdAt: "2024-11-16",
                updatedAt: "2024-11-16"
            ),
            isSelected: true,
            isCorrect: true,
            isWrong: false,
            onTap: { print("Tapped") }
        )
    }
    .padding()
}

#Preview("Wrong Answer") {
    VStack(spacing: 16) {
        AnswerButton(
            answer: Answer(
                id: "1",
                text: "Ikan",
                urutan: 1,
                isCorrect: false,
                createdAt: "2024-11-16",
                updatedAt: "2024-11-16"
            ),
            isSelected: true,
            isCorrect: false,
            isWrong: true,
            onTap: { print("Tapped") }
        )
    }
    .padding()
}

#Preview("All States") {
    VStack(spacing: 16) {
        Text("Default")
            .font(.caption)
            .foregroundColor(.secondary)
        AnswerButton(
            answer: Answer(
                id: "1",
                text: "Default State",
                urutan: 1,
                isCorrect: false,
                createdAt: "2024-11-16",
                updatedAt: "2024-11-16"
            ),
            isSelected: false,
            isCorrect: nil,
            isWrong: false,
            onTap: {}
        )

        Text("Selected")
            .font(.caption)
            .foregroundColor(.secondary)
        AnswerButton(
            answer: Answer(
                id: "2",
                text: "Selected State",
                urutan: 2,
                isCorrect: false,
                createdAt: "2024-11-16",
                updatedAt: "2024-11-16"
            ),
            isSelected: true,
            isCorrect: nil,
            isWrong: false,
            onTap: {}
        )

        Text("Correct")
            .font(.caption)
            .foregroundColor(.secondary)
        AnswerButton(
            answer: Answer(
                id: "3",
                text: "Correct Answer",
                urutan: 3,
                isCorrect: true,
                createdAt: "2024-11-16",
                updatedAt: "2024-11-16"
            ),
            isSelected: true,
            isCorrect: true,
            isWrong: false,
            onTap: {}
        )

        Text("Wrong")
            .font(.caption)
            .foregroundColor(.secondary)
        AnswerButton(
            answer: Answer(
                id: "4",
                text: "Wrong Answer",
                urutan: 4,
                isCorrect: false,
                createdAt: "2024-11-16",
                updatedAt: "2024-11-16"
            ),
            isSelected: true,
            isCorrect: false,
            isWrong: true,
            onTap: {}
        )
    }
    .padding()
}
