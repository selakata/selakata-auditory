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
                .background(
                    Capsule().fill(Color(.systemGray5))
                        .frame(height: 6)
                )
                .progressViewStyle(.linear)
                .frame(height: 6)
                .padding(.horizontal)

            // Simple Audio Player
            SimpleAudioPlayer(title: "Audio Soal")
                .padding(.horizontal)
                .padding(.top, 4)

            // Question text
            Text("Kenapa Nathan tidak bisa ikut\nmain basket?")
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .padding(.horizontal, 24)
                .padding(.top, 4)

            // Answers
            VStack(spacing: 14) {
                ForEach(answers.indices, id: \.self) { index in
                    AnswerRow(title: answers[index], isSelected: selectedIndex == index) {
                        withAnimation(.snappy) { selectedIndex = index }
                    }
                }
            }
            .padding(.top, 4)
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
