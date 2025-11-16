//  Created by ais on 12/11/25.

import Foundation

public struct User: Codable {
    let id: String
    let username: String
    let appleId: String?
    let email: String
    let name: String
    let role: String
    let createdAt: String
    let updatedAt: String
    let snrBaselineHistories: [SnrBaselineHistory]?
    let earThresholds: [EarThreshold]?
    let userVoices: [UserVoice]?
}

// MARK: - Snr Baseline
public struct SnrBaselineHistory: Codable {
    let id: String
    let value: Double
    let createdAt: String
    let updatedAt: String
}

// MARK: - Ear Threshold
public struct EarThreshold: Codable {
    let id: String
    let value500: Double
    let value1000: Double
    let value2000: Double
    let value4000: Double
    let type: Int
    let createdAt: String
    let updatedAt: String
}

// MARK: - User Voices
public struct UserVoice: Codable {
    let id: String
    let voiceId: String
    let voiceName: String
    let previewUrl: String
    let createdAt: String
    let updatedAt: String
}
