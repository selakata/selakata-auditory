//
//  LevelDetailResponse.swift
//  selakata
//
//  Created by ais on 10/11/25.
//

import Foundation

// MARK: - LevelDetailResponse
public struct LevelDetailResponse: Codable {
    let data: QuestionResponse
}

struct QuestionResponse: Codable {
    let id: String
    let label: String
    let value: Int
    let isActive: Bool
    let createdAt: String
    let updatedAt: String
    let updatedBy: String
    let modul: Modul
    let questionList: [Question]
}

struct Modul: Codable {
    let id: String
    let label: String
    let value: Int
    let description: String
    let isActive: Bool
    let createdAt: String
    let updatedAt: String
    let updatedBy: String
}

struct Question: Codable {
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
    let updatedBy: String
    let answerList: [Answer]
    let audioFile: AudioFile?
    let noiseFile: String?
}

struct Answer: Codable {
    let id: String
    let text: String
    let urutan: Int
    let isCorrect: Bool
}

struct AudioFile: Codable {
    let id: String
    let fileName: String
    let fileURL: String
    let rawText: String
    let size: Int
    let duration: Double
    let voiceId: String
    let voiceName: String
    let similarityBoost: Double
    let speed: Double
    let stability: Double
    let useSpeakerBoost: Bool
    let type: Int
}
