//  Created by ais on 06/11/25.

import Foundation

// MARK: - Root Response
import Foundation

// MARK: - LevelResponse
public struct LevelResponse: Codable {
    let data: [LevelData]
    let meta: Metadata
}

// MARK: - LevelData
struct LevelData: Codable, Identifiable {
    let id: String
    let label: String
    let value: Int
    let isActive: Bool
    let createdAt: String
    let updatedAt: String
    let isUnlocked: Bool
    let isPassed: Bool
    let latestScore: Double?
}

// MARK: - Noise File (Nullable)
struct NoiseFile: Codable {}
