//
//  Quiz.swift
//  selakata
//
//  Created by ais on 20/10/25.
//

import SwiftUI

struct QuizView: View {
    let questionCategory: QuestionCategory
    let level: Int
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: QuizViewModel
    @State private var audioCompleted: Bool = false

    var answerLayout: AnswerLayout {
        if questionCategory == .comprehension {
            .list
        } else {
            .grid(columns: 2)
        }
    }

    init(questionCategory: QuestionCategory, level: Int) {
        self.questionCategory = questionCategory
        self.level = level
        _viewModel = StateObject(
            wrappedValue: QuizViewModel(category: questionCategory, level: level)
        )
    }

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

            // Progress bar with question indicator
            VStack(spacing: 8) {
                HStack {
                    Text(viewModel.questionNumber)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
//                    Text("Audio: \(audioCompleted ? "✅" : "⏳")")
//                        .font(.caption)
//                        .foregroundColor(audioCompleted ? .green : .orange)
//                    Spacer()
                    Text(viewModel.scoreText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 32)

                ProgressView(value: viewModel.progress)
                    .tint(Color(.darkGray))
                    .progressViewStyle(.linear)
                    .frame(height: 6)
                    .padding(.horizontal, 32)
            }

            // Simple Audio Player
            SimpleAudioPlayer(
                title: viewModel.audioTitle,
                fileName: viewModel.audioFileName,
                onAudioCompleted: {
                    print("📱 QuizView received audio completion callback")
                    withAnimation(.easeInOut(duration: 0.5)) {
                        audioCompleted = true
                    }
                }
            )
            .padding(.horizontal, 32)

            // Answers - only show when audio completed
            if audioCompleted {
                AnswerView(
                    question: viewModel.currentQuestion,
                    selectedAnswer: viewModel.selectedAnswer,
                    hasAnswered: viewModel.hasAnswered,
                    layout: answerLayout,
                    onSelect: { answer in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.selectAnswer(answer)
                        }
                    }
                )
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                // Placeholder or instruction text
                VStack(spacing: 16) {
                    Image(systemName: "speaker.wave.2")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("Listen to the audio first")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Please play and listen to the complete audio before answering")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                .padding(.vertical, 40)
            }

            Spacer(minLength: 0)

            // Next button - only show when answered
            if viewModel.hasAnswered {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.nextQuestion()
                    }
                }) {
                    Text(viewModel.nextButtonText)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .background(
                    Capsule().fill(Color(.darkGray))
                )
                .padding(.horizontal, 24)
                .padding(.bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemBackground))
        .onChange(of: viewModel.currentQuestionIndex) { oldValue, newValue in
            // Reset audio completion when question changes
            audioCompleted = false
        }
        .sheet(isPresented: $viewModel.showResults) {
            QuizResultsView(
                score: viewModel.score,
                totalQuestions: viewModel.totalQuestions,
                onRestart: {
                    viewModel.dismissResults()
                    viewModel.restartQuiz()
                },
                onDismiss: {
                    viewModel.dismissResults()
                    dismiss()
                }
            )
            .presentationDetents([.height(280), .medium])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(20)
        }
    }
}

#Preview {
    NavigationStack { QuizView(questionCategory: .identification, level: 1) }
}
