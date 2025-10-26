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
    private let repository: QuizRepositoryProtocol
    private let questionCategory: QuestionCategory
    private let level: Int

    // MARK: - Computed Properties
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }

    var progress: Double {
        Double(currentQuestionIndex + 1) / Double(questions.count)
    }

    var allAudioFileNames: [String] {
        repository.getAudioName(category: questionCategory, level: level)
    }

    var audioFileName: String {
        allAudioFileNames[currentQuestionIndex]
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
        //        let difficultyLevel = getDifficultyLevel(for: currentQuestionIndex)
        //        let levelNumber = getLevelNumber(for: currentQuestionIndex)
        //        return "Audio \(difficultyLevel) Level \(levelNumber)"
        return ""
    }

    var audioSubdirectory: String {
        return "Resources/Audio"
    }

    // MARK: - Initialization
    init(
        repository: QuizRepositoryProtocol = QuizRepository.shared,
        category: QuestionCategory, level: Int
    ) {
        self.repository = repository
        self.questionCategory = category
        self.level = level
        self.questions = repository.getQuestionsByCategory(category: category, level: level)
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
