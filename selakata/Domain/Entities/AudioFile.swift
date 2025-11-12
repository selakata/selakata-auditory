//
//  AudioFile.swift
//  selakata
//
//  Created by ais on 12/11/25.
//

public struct AudioFile: Codable {
    let id: String
    let historyItemId: String?
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
    let createdAt: String
    let updatedAt: String
    let updatedBy: String?
    let compositions: [String]
}
