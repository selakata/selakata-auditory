import Foundation
import SwiftUI

@MainActor
class QuizViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswer: Answer? = nil
    @Published var hasAnswered: Bool = false
    @Published var score: Int = 0
    @Published var showResults: Bool = false

    private let levelUseCase: LevelUseCase
    private let levelId: String

    @Published var questions: [Question] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(levelUseCase: LevelUseCase, levelId: String) {
        self.levelUseCase = levelUseCase
        self.levelId = levelId
        fetchQuestions()
    }

    func fetchQuestions() {
        levelUseCase.fetchDetailLevel(levelId: levelId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let questions):
                    self?.questions = [questions.data]
                    
                    print("AISDEBUG:\([questions.data])")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("AISDEBUG:\(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Computed Properties
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }

    var progress: Double {
        Double(currentQuestionIndex + 1) / Double(questions.count)
    }

    var audioFileName: String {
        ""
        //        currentQuestion.audioFile.fileURL ?? ""
    }

    var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }

    var totalQuestions: Int {
        questions.count
    }

    var questionNumber: String {
        "Question \(currentQuestionIndex + 1) of \(questions.count)"
    }

    var scoreText: String {
        "Score: \(score)/\(questions.count)"
    }

    var nextButtonText: String {
        isLastQuestion ? "Finish" : "Next"
    }

    var audioTitle: String {
        return ""
    }

    var audioSubdirectory: String {
        return "Resources/Audio"
    }

    // MARK: - Public Methods
    func selectAnswer(_ answer: Answer) {
        selectedAnswer = answer
        hasAnswered = true

        if answer.isCorrect {
            score += 1
        }
    }

    func nextQuestion() {
        if isLastQuestion {
            showQuizResults()
        } else {
            currentQuestionIndex += 1
            selectedAnswer = nil
            hasAnswered = false
        }
    }

    func showQuizResults() {
        showResults = true
    }

    func restartQuiz() {
        currentQuestionIndex = 0
        selectedAnswer = nil
        hasAnswered = false
        score = 0
        showResults = false
    }

    func dismissResults() {
        showResults = false
    }
}
