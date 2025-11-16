//  Created by ais on 06/11/25.

public struct Module: Codable {
    let id: String
    let label: String
    let value: Int
    let description: String
    let isActive: Bool
    let createdAt: String
    let updatedAt: String
    let updatedBy: String?
    let isUnlocked: Bool
    let percentage: Double
}
