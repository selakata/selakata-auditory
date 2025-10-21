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
    @State private var selectedIndex: Int? = 0

    private let answers = ["Sakit", "Melayat", "Ujian"]
    private let question = Question(
        text: "Kenapa Nathan tidak main basket?",
        answers: [
            Answer(title: "Sakit"),
            Answer(title: "Melayat"),
            Answer(title: "Cuti"),
            Answer(title: "Urusan keluarga"),
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
                selectedAnswer: nil,
                layout: .grid(columns: 2),
                onSelect: { _ in }
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
