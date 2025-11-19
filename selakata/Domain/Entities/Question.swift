//  Created by ais on 12/11/25.

public struct Question: Codable {
    let id: String
    let text: String
    let urutan: Int
    let mainRMS: Double
    let noiseRMS: Double
    let isActive: Bool
    let snr: Double?
    let poin: Int?
    let type: Int
    let createdAt: String
    let updatedAt: String
    let updatedBy: String?
    let answerList: [Answer]
    let audioFile: AudioFile?
    let noiseFile: AudioFile?
}
