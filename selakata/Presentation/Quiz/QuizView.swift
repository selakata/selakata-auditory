import SwiftUI

struct QuizView: View {
    //   var level: Level
    //   var questionCategory: QuestionCategory
    @Environment(\.dismiss) private var dismiss

    @State private var audioCompleted: Bool = false
    @State private var hasPlayedOnce: Bool = false
    @State private var triggerReplay: Bool = false

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
       //ˆ quizContent
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
                    Button(action: { dismiss() }) {
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

                ProgressView(value: viewModel.progress)
                    .tint(Color(.darkGray))
                    .progressViewStyle(.linear)
                    .frame(height: 8)
                    .padding(.horizontal, 32)

                // Simple Audio Player
                SimpleAudioPlayer(
                    fileName: viewModel.audioFileName,
                    noiseFileName: viewModel.noiseFileName,
                    onAudioCompleted: {
                        print("📱 QuizView received audio completion callback")
                        withAnimation(.easeInOut(duration: 0.5)) {
                            audioCompleted = true
                        }
                    },
                    onReplayRequested: {
                        // Reset audio state for replay
                        withAnimation(.easeInOut(duration: 0.3)) {
                            audioCompleted = false
                        }
                        hasPlayedOnce = false
                    },
                    shouldReplay: triggerReplay,
                    autoPlay: true
                )
                .padding(.horizontal, 32)
                .frame(height: geo.size.height * 0.3)

                //                Divider()

                // Answers - only show when audio completed
                VStack {
                    if audioCompleted {
                        AnswerView(
                            question: viewModel.currentQuestion,
                            selectedAnswer: viewModel.selectedAnswer,
                            hasAnswered: viewModel.hasAnswered,
                            layout: .list,  //debug
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
                    } else {
                        // Placeholder or instruction text
                        VStack(spacing: 16) {
                            Image(systemName: "speaker.wave.2")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)

                            Text("Listen to the audio first")
                                .font(.headline)
                                .foregroundColor(.secondary)

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
            .onChange(of: viewModel.currentQuestionIndex) {
                oldValue,
                newValue in
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
        }
    }
}

#Preview {
    NavigationStack {
        QuizView(levelId: "7d275cd3-6909-4492-9f66-17a558c11060")
    }
}
