import Foundation

protocol QuizRepositoryProtocol {
    func getQuestionsByCategory(category: QuestionCategory, level: Int) -> [QuestionDummy]
    func getAudioName(category: QuestionCategory, level: Int) -> [String]
}

class QuizRepository: QuizRepositoryProtocol {
    static let shared = QuizRepository()

    private init() {}

    func getQuestionsByCategory(category: QuestionCategory, level: Int) -> [QuestionDummy] {
        // Get data from Module structure
        let moduleIndex = getModuleIndex(for: category)
        guard moduleIndex < QuizData.dummyModule.count else {
            // Fallback to old data structure
            return getQuestionsFromOldStructure(category: category, level: level)
        }
        
        let module = QuizData.dummyModule[moduleIndex]
        guard let level = module.levelList.first(where: { $0.value == level }) else {
            return getQuestionsFromOldStructure(category: category, level: level)
        }
        
        // Convert Question to Question
        return level.question.map { question in
            let answers = question.answer.map { answer in
                AnswerDummy(title: answer.text, isCorrect: answer.isCorrect)
            }
            return QuestionDummy(text: question.text, answers: answers)
        }
    }

    func getAudioName(category: QuestionCategory, level: Int) -> [String] {
        // Get data from Module structure
        let moduleIndex = getModuleIndex(for: category)
        guard moduleIndex < QuizData.dummyModule.count else {
            // Fallback to old data structure
            return getAudioFromOldStructure(category: category, level: level)
        }
        
        let module = QuizData.dummyModule[moduleIndex]
        guard let level = module.levelList.first(where: { $0.value == level }) else {
            return getAudioFromOldStructure(category: category, level: level)
        }
        
        // Extract audio file URLs from Question
        return level.question.map { $0.audioFile.fileURL ?? "" }
    }
    
    // MARK: - Helper Methods
    private func getModuleIndex(for category: QuestionCategory) -> Int {
        switch category {
        case .identification:
            return 0
        case .discrimination:
            return 1
        case .comprehension:
            return 2
        case .competingSpeaker:
            return 3
        }
    }
    
    // Fallback methods for old data structure
    private func getQuestionsFromOldStructure(category: QuestionCategory, level: Int) -> [QuestionDummy] {
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
    
    private func getAudioFromOldStructure(category: QuestionCategory, level: Int) -> [String] {
        switch category {
        case .identification:
            return QuizData.audioIdentification[level-1]
        case .discrimination:
            return QuizData.audioDiscrimintion[level-1]
        case .comprehension:
            return QuizData.audioComprehension[level-1]
        case .competingSpeaker:
            return QuizData.audioCompetingSpeaker[level-1]
        }
    }
}

enum QuestionCategory: String {
    case identification = "identification"
    case discrimination = "discrimination"
    case comprehension = "comprehension"
    case competingSpeaker = "competing_speaker"
}
