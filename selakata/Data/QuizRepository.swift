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
            return QuizData.identificationQuestions[level-1]
        case .discrimination:
            return QuizData.discriminationQuestions[level-1]
        case .comprehension:
            return QuizData.comprehensionQuestions[level-1]
        case .competingSpeaker:
            return QuizData.computationSpeakerQuestions[level-1]
        }
    }

    func getAudioName(category: QuestionCategory, level: Int) -> [String] {
        switch category {
        case .identification:
            return QuizData.audioIdentification[level-1]
        case .discrimination:
            return QuizData.audioDiscrimintion[level-1]
        case .comprehension:
            return QuizData.audioComprehension[level-1]
        case .competingSpeaker:
            return QuizData.audioComputingSpeaker[level-1]
        }
    }
}

enum QuestionCategory: String {
    case identification = "identification"
    case discrimination = "discrimination"
    case comprehension = "comprehension"
    case competingSpeaker = "competing_speaker"
}
