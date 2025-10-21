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

    var body: some View {
        Button(action: action) {
            Text(answer.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(.darkGray))
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : Color(.separator), lineWidth: 1.5)
                )
        }
    }
}
