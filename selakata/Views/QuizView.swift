import SwiftUI

struct QuizView: View {
    let module: Module
    let level: Level
    let questionCategory: QuestionCategory
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: QuizViewModel
    @State private var audioCompleted: Bool = false
    @State private var lives: Int = 3
    @State private var hasPlayedOnce: Bool = false
    @State private var showReplayConfirmation: Bool = false
    @State private var triggerReplay: Bool = false

    var answerLayout: AnswerLayout {
        if questionCategory == .comprehension || questionCategory == .competingSpeaker {
            .list
        } else {
            .grid(columns: 2)
        }
    }

    init(module: Module, level: Level, questionCategory: QuestionCategory) {
        self.module = module
        self.level = level
        self.questionCategory = questionCategory
        _viewModel = StateObject(
            wrappedValue: QuizViewModel(level: level)
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
                    ForEach(0..<3, id: \.self) { index in
                        Heart(isFilled: index < lives)
                    }
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
                },
                onReplayRequested: {
                    showReplayConfirmation = true
                },
                shouldReplay: triggerReplay
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
                            
                            // Reduce life if answer is wrong
                            if !answer.isCorrect {
                                lives = max(0, lives - 1)
                                
                                // Check if game over
                                if lives == 0 {
                                    // Handle game over
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        dismiss()
                                    }
                                }
                            }
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
        .toolbar(.hidden, for: .tabBar)
        .onChange(of: viewModel.currentQuestionIndex) { oldValue, newValue in
            // Reset audio completion when question changes
            audioCompleted = false
            hasPlayedOnce = false
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
        .alert("Replay Audio", isPresented: $showReplayConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Replay (-1 ❤️)") {
                if lives > 0 {
                    lives -= 1
                    // Reset audio state and replay
                    audioCompleted = false
                    hasPlayedOnce = false
                    // Trigger audio replay in SimpleAudioPlayer
                    triggerReplay.toggle()
                }
            }
        } message: {
            Text("Replaying audio will cost 1 life. You have \(lives) lives remaining.")
        }
    }
}

#Preview {
    NavigationStack { 
        QuizView(
            module: QuizData.dummyModule[0],
            level: QuizData.dummyModule[0].levelList[0],
            questionCategory: .identification
        ) 
    }
}
