//
//  Level.swift
//  selakata
//
//  Created by ais on 12/11/25.
//

import Foundation

public struct Level: Codable, Identifiable {
    public let id: String
    let label: String
    let value: Int
    let isActive: Bool
    let createdAt: String
    let updatedAt: String
    let isUnlocked: Bool
    let isPassed: Bool
    let latestScore: Double?
    let questions: [Question?]?
}
