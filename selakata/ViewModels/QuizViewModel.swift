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
    
    // MARK: - Computed Properties
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }
    
    var progress: Double {
        Double(currentQuestionIndex + 1) / Double(questions.count)
    }
    
    var audioFileName: String {
        "identification\(currentQuestionIndex + 1)"
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
        "Audio Soal \(currentQuestionIndex + 1)"
    }
    
    // MARK: - Initialization
    init(repository: QuizRepositoryProtocol = QuizRepository.shared, category: String? = nil) {
        self.repository = repository
        if let category = category {
            self.questions = repository.getQuestionsByCategory(category)
        } else {
            self.questions = repository.getQuestions()
        }
    }
    
    init(questions: [Question], repository: QuizRepositoryProtocol = QuizRepository.shared) {
        self.repository = repository
        self.questions = questions
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

// MARK: - Quiz Data
struct QuizData {
    static let defaultQuestions = [
        Question(
            text: "Kenapa Nathan tidak main basket?",
            answers: [
                Answer(title: "Sakit", isCorrect: true),
                Answer(title: "Melayat", isCorrect: false),
                Answer(title: "Cuti", isCorrect: false),
                Answer(title: "Urusan keluarga", isCorrect: false),
            ]
        ),
        Question(
            text: "Apa yang dilakukan Sarah di weekend?",
            answers: [
                Answer(title: "Belanja", isCorrect: false),
                Answer(title: "Belajar", isCorrect: true),
                Answer(title: "Tidur", isCorrect: false),
                Answer(title: "Nonton TV", isCorrect: false),
            ]
        ),
        Question(
            text: "Dimana mereka akan bertemu?",
            answers: [
                Answer(title: "Di kafe", isCorrect: true),
                Answer(title: "Di rumah", isCorrect: false),
                Answer(title: "Di kantor", isCorrect: false),
                Answer(title: "Di mall", isCorrect: false),
            ]
        )
    ]
}