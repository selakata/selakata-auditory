//
//  LevelDetailResponse.swift
//  selakata
//
//  Created by ais on 10/11/25.
//

import Foundation

// MARK: - LevelDetailResponse
public struct LevelDetailResponse: Codable {
    let data: LevelDetailData
}

// MARK: - LevelDetailData
struct LevelDetailData: Codable, Identifiable {
    let id: String
    let label: String
    let value: Int
    let isActive: Bool
    let createdAt: String
    let updatedAt: String
    let updatedBy: String
    let modul: ModuleData
    let questionList: [QuestionData]
}

// MARK: - ModuleData
struct ModuleData: Codable, Identifiable {
    let id: String
    let label: String
    let value: Int
    let description: String
    let isActive: Bool
    let createdAt: String
    let updatedAt: String
    let updatedBy: String
}

// MARK: - QuestionData
struct QuestionData: Codable, Identifiable {
    let id: String
    let text: String
    let urutan: Int
    let mainRMS: Double
    let noiseRMS: Double
    let isActive: Bool
    let snr: Double?
    let poin: Double?
    let type: Int
    let createdAt: String
    let updatedAt: String
    let updatedBy: String
    let answerList: [AnswerData]
    //let audioFile: AudioFileData
    let noiseFile: NoiseFile?
}

// MARK: - AnswerData
struct AnswerData: Codable, Identifiable {
    let id: String
    let text: String
    let urutan: Int
    let isCorrect: Bool
    let createdAt: String
    let updatedAt: String
}

