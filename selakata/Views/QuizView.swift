//
//  Quiz.swift
//  selakata
//
//  Created by ais on 20/10/25.
//

import SwiftUI

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var progress: Double = 0.35
    @State private var selectedAnswer: Answer? = nil
    @State private var hasAnswered: Bool = false

    private let question = Question(
        text: "Kenapa Nathan tidak main basket?",
        answers: [
            Answer(title: "Sakit", isCorrect: true),
            Answer(title: "Melayat", isCorrect: false),
            Answer(title: "Cuti", isCorrect: false),
            Answer(title: "Urusan keluarga", isCorrect: false),
        ]
    )

    var body: some View {
        VStack(spacing: 16) {
            // Top bar: Back + Lives
            HStack(alignment: .center) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .foregroundStyle(.primary)

                Spacer()

                HStack(spacing: 12) {
                    Heart(isFilled: false)
                    Heart(isFilled: true)
                    Heart(isFilled: true)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // Progress bar
            ProgressView(value: progress)
                .tint(Color(.systemGray3))
                .progressViewStyle(.linear)
                .frame(height: 16)
                .padding(.horizontal, 32)

            // Simple Audio Player
            SimpleAudioPlayer(title: "Audio Soal", fileName: "identification1")
                .padding(.horizontal, 32)

            // Answers
            AnswerView(
                question: question,
                selectedAnswer: selectedAnswer,
                hasAnswered: hasAnswered,
                layout: .grid(columns: 2),
                onSelect: { answer in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedAnswer = answer
                        hasAnswered = true
                    }
                }
            )
            .padding(.horizontal)

            Spacer(minLength: 0)

            // Next button
            Button(action: {}) {
                Text("Next")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .background(
                Capsule().fill(Color(.systemIndigo))
            )
            .padding(.horizontal, 24)
            .padding(.bottom)
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack { QuizView() }
}
