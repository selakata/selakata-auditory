import Foundation

protocol QuizRepositoryProtocol {
    func getQuestionsByCategory(category: QuestionCategory, level: Int) -> [Question]
    func getAudioName(category: QuestionCategory, level: Int) -> [String]
}

class QuizRepository: QuizRepositoryProtocol {
    static let shared = QuizRepository()

    private init() {}

    func getQuestionsByCategory(category: QuestionCategory, level: Int) -> [Question] {
        switch category {
        case .identification:
            return QuizData.identificationQuestions[level]
        case .discrimination:
            return QuizData.discriminationQuestions[level]
        case .comprehension:
            return QuizData.comprehensionQuestions[level]
        case .computationSpeaker:
            return QuizData.computationSpeakerQuestions[level]
        }
    }

    func getAudioName(category: QuestionCategory, level: Int) -> [String] {
        switch category {
        case .identification:
            return QuizData.audioIdentification[level]
        case .discrimination:
            return QuizData.audioDiscrimintion[level]
        case .comprehension:
            return QuizData.audioComprehension[level]
        case .computationSpeaker:
            return QuizData.audioComputingSpeaker[level]
        }
    }
}

enum QuestionCategory: String {
    case identification = "identification"
    case discrimination = "discrimination"
    case comprehension = "comprehension"
    case computationSpeaker = "competing_speaker"
}
