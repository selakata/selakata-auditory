//  Created by ais on 12/11/25.

public struct UpdateLevel: Codable {
    let levelId: String
    let score: Int
    let repetition: Int
    let responseTime: Double
    let questions: [QuestionTracker]
}

public struct QuestionTracker: Codable {
    let questionId: String
    let isCorrect: Bool
}
