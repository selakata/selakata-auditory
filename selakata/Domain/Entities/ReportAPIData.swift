import Foundation

public struct ReportAPIData: Decodable {
    let wordComprehension: Double?
    let sentenceComprehension: Double?
    let speechInNoiseEnvironment: Double?
    let speechInNoiseConversation: Double?
    let snrLevel: Double?
    let repetitionRate: Double?
    let responseTime: Double?
    
    enum CodingKeys: String, CodingKey {
        case wordComprehension
        case sentenceComprehension
        case speechInNoiseEnvironment = "speechInNoiseEnv"
        case speechInNoiseConversation = "speechInNoiseConv"
        case snrLevel
        case repetitionRate = "repetition"
        case responseTime
    }
}

public struct ReportAPIResponse: Decodable {
    let data: ReportAPIData
}
