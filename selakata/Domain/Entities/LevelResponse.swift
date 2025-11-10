//
//  LevelResponse.swift
//  selakata
//
//  Created by ais on 06/11/25.
//


import Foundation

// MARK: - Root Response
import Foundation

// MARK: - LevelResponse
public struct LevelResponse: Codable {
    let data: [LevelData]
    let meta: MetaData
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

// MARK: - MetaData
struct MetaData: Codable {
    let currentPage: Int
    let from: Int
    let to: Int
    let lastPage: Int
    let perPage: Int
    let total: Int
}

// MARK: - Noise File (Nullable)
struct NoiseFile: Codable {}
