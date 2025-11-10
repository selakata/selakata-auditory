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

    // MARK: - Private Properties
    private let questions: [Question]
    private let level: Level

    // MARK: - Computed Properties
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }

    var progress: Double {
        Double(currentQuestionIndex + 1) / Double(questions.count)
    }

    var audioFileName: String {
        currentQuestion.audioFile.fileURL ?? ""
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

    // MARK: - Initialization
    init(level: Level) {
        self.level = level
        self.questions = level.question.sorted { $0.urutan < $1.urutan }
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
