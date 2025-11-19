import SwiftUI

struct QuizView: View {
    //   var level: Level
    //   var questionCategory: QuestionCategory
    @Environment(\.dismiss) private var dismiss

    @State private var audioCompleted: Bool = false
    @State private var hasPlayedOnce: Bool = false
    @State private var triggerReplay: Bool = false
    @State private var showExitConfirmation: Bool = false
    @State private var audioEngine: AudioEngineService?

    //    let category: Level
    @StateObject private var viewModel: QuizViewModel
    let levelId: String

    init(levelId: String) {
        self.levelId = levelId
        _viewModel = StateObject(
            wrappedValue: DependencyContainer.shared.makeQuizViewModel(
                levelId: levelId
            )
        )
    }

    var body: some View {
        if viewModel.isLoading {
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)

                if viewModel.isDownloadingAudio {
                    Text(viewModel.downloadProgress)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("Loading questions...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = viewModel.errorMessage {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)

                Text("Error loading questions")
                    .font(.headline)

                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button("Go Back") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.questions.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)

                Text("No questions available")
                    .font(.headline)

                Button("Go Back") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            quizContent
        }
    }

    private var quizContent: some View {
        GeometryReader { geo in
            VStack(spacing: 16) {
                // Top bar: Back button
                HStack(alignment: .center) {
                    Button(action: { 
                        showExitConfirmation = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .foregroundStyle(.primary)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)

//                ProgressView(value: viewModel.progress)
//                    .tint(.Primary._500)
//                    .progressViewStyle(.linear)
//                    .frame(height: 8)
//                    .padding(.horizontal, 32)
                
                ProgressView(value: viewModel.progress)
                    .progressViewStyle(
                        ThickProgressViewStyle(height: 10, tint: .Primary._500)
                    )
                    .padding(.horizontal, 26)

                // Simple Audio Player
                SimpleAudioPlayer(
                    fileName: viewModel.audioFileName,
                    noiseFileName: viewModel.noiseFileName,
                    mainRMS: viewModel.currentQuestion.mainRMS,
                    noiseRMS: viewModel.currentQuestion.noiseRMS,
                    onAudioCompleted: {
                        print("📱 QuizView received audio completion callback")
                        withAnimation(.easeInOut(duration: 0.5)) {
                            audioCompleted = true
                        }
                        // Start response timer when audio completes
                        viewModel.startResponseTimer()
                    },
                    onReplayRequested: {
                        // Reset audio state for replay
                        withAnimation(.easeInOut(duration: 0.3)) {
                            audioCompleted = false
                        }
                        hasPlayedOnce = false
                        viewModel.incrementReplayCount()
                    },
                    shouldReplay: triggerReplay,
                    autoPlay: !viewModel.isLoading && viewModel.isAudioReady,
                    onEngineReady: { engine in
                        audioEngine = engine
                    }
                )
                .padding(.horizontal, 32)
                .frame(height: geo.size.height * 0.3)

                //                Divider()

                // Answers - only show when audio completed
                VStack {
                    if audioCompleted {
                        // Show different view based on question type
                        if viewModel.currentQuestion.type == 2 {
                            // Type 2: Fill in the blank
                            FillInBlankView(
                                question: viewModel.currentQuestion,
                                userAnswer: $viewModel.userTextAnswer,
                                hasAnswered: viewModel.hasAnswered,
                                isCorrect: viewModel.hasAnswered ? viewModel.isTextAnswerCorrect : nil,
                                onSubmit: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.submitTextAnswer()
                                    }
                                }
                            )
                            .padding(.horizontal)
                            .transition(
                                .move(edge: .bottom).combined(with: .opacity)
                            )
                        } else {
                            // Type 1: Multiple choice (default)
                            AnswerView(
                                question: viewModel.currentQuestion,
                                selectedAnswer: viewModel.selectedAnswer,
                                hasAnswered: viewModel.hasAnswered,
                                layout: .list,
                                onSelect: { answer in
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.selectAnswer(answer)
                                    }
                                }
                            )
                            .padding(.horizontal)
                            .transition(
                                .move(edge: .bottom).combined(with: .opacity)
                            )
                        }
                    } else {
                        // Placeholder or instruction text
                        VStack(spacing: 16) {
                            Text("Listen to the audio first")
                                .font(.app(.subheadSemiBold))
                                .fontWeight(.semibold)
                                .foregroundColor(.Default._950)

                            Text(
                                "Please play and listen to the complete audio before answering"
                            )
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 40)
                    }

                    Spacer(minLength: 0)
                }.frame(height: geo.size.height * 0.5)

                // Next button - only show when answered
                if viewModel.hasAnswered {
                    UtilsButton(
                        title: viewModel.nextButtonText,
                        leftIcon: nil,
                        isLoading: false,
                        variant: .primary,
                        action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewModel.nextQuestion()
                            }
                        }
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(Color(.systemBackground))
            .toolbar(.hidden, for: .tabBar)
            .onChange(of: viewModel.currentQuestionIndex) {
                oldValue,
                newValue in
                // Reset audio completion when question changes
                audioCompleted = false
                hasPlayedOnce = false
            }
            .fullScreenCover(isPresented: $viewModel.showResults) {
                QuizResultsView(
                    correctAnswer: viewModel.correctAnswer,
                    totalQuestions: viewModel.totalQuestions,
                    repetitions: viewModel.totalReplayCount,
                    averageResponseTime: viewModel.averageResponseTimeString,
                    onRestart: {
                        viewModel.dismissResults()
                        viewModel.restartQuiz()
                    },
                    onDismiss: {
                        viewModel.dismissResults()
                        dismiss()
                    }
                )
            }
            .alert("Exit Quiz?", isPresented: $showExitConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Exit", role: .destructive) {
                    audioEngine?.stopAll()
                    dismiss()
                }
            } message: {
                Text("Your progress will be lost if you exit now.")
            }
            .onDisappear {
                // Stop audio when view disappears
                audioEngine?.stopAll()
            }
        }
    }
}

#Preview {
    NavigationStack {
        QuizView(levelId: "7d275cd3-6909-4492-9f66-17a558c11060")
    }
}
