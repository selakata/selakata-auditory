import Foundation

protocol QuizRepositoryProtocol {
    func getQuestions() -> [Question]
    func getQuestionsByCategory(_ category: String) -> [Question]
}

class QuizRepository: QuizRepositoryProtocol {
    static let shared = QuizRepository()
    
    private init() {}
    
    func getQuestions() -> [Question] {
        return QuizData.defaultQuestions
    }
    
    func getQuestionsByCategory(_ category: String) -> [Question] {
        switch category {
        case "identification":
            return QuizData.identificationQuestions
        case "discrimination":
            return QuizData.discriminationQuestions
        case "comprehension":
            return QuizData.comprehensionQuestions
        default:
            return QuizData.defaultQuestions
        }
    }
}

// MARK: - Quiz Data Extension
extension QuizData {
    static let identificationQuestions = [
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
    
    static let discriminationQuestions = [
        Question(
            text: "Manakah suara yang berbeda?",
            answers: [
                Answer(title: "Suara A", isCorrect: false),
                Answer(title: "Suara B", isCorrect: true),
                Answer(title: "Suara C", isCorrect: false),
                Answer(title: "Suara D", isCorrect: false),
            ]
        )
    ]
    
    static let comprehensionQuestions = [
        Question(
            text: "Apa maksud dari percakapan tersebut?",
            answers: [
                Answer(title: "Mengajak makan", isCorrect: true),
                Answer(title: "Mengajak jalan", isCorrect: false),
                Answer(title: "Mengajak belajar", isCorrect: false),
                Answer(title: "Mengajak tidur", isCorrect: false),
            ]
        )
    ]
}