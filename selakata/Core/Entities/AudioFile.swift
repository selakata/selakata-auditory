//
//  AudioFile.swift
//  selakata
//
//  Created by ais on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class LocalAudioFile{
    @Attribute(.unique) var id: UUID
    var fileName: String
    var duration: Int
    var voiceName: String
    var isSynced: Bool
    
    var fileURL: String?
    var size: Int?
    var snr: Int?
    var voiceId: String?
    var similiarityBoost : Double?
    var speed: Double?
    var stability: Double?
    var useSpeakerBoost: Bool?
    var type: Int?
    var createdAt: Date
    var updatedAt: Date?
    var updatedBy: String?
    
    init(id: UUID, fileName: String, fileURL: String, size: Int, duration: Int, snr: Int, voiceId: String, voiceName: String, similiarityBoost: Double, speed: Double, stability: Double, useSpeakerBoost: Bool, type: Int, createdAt: String, updatedAt: String, updatedBy: String) {
        self.id = id
        self.fileName = fileName
        self.fileURL = fileURL
        self.size = size
        self.duration = duration
        self.snr = snr
        self.voiceId = voiceId
        self.voiceName = voiceName
        self.similiarityBoost = similiarityBoost
        self.speed = speed
        self.stability = stability
        self.useSpeakerBoost = useSpeakerBoost
        self.type = type
        let formatter = ISO8601DateFormatter()
        self.createdAt = formatter.date(from: createdAt) ?? Date()
        self.updatedAt = formatter.date(from: updatedAt)
        self.updatedBy = updatedBy
        self.isSynced = true
    }
    
    init(voiceName: String, fileName: String, duration: Int) {
        self.id = UUID()
        self.voiceName = voiceName
        self.fileName = fileName
        self.duration = duration
        self.createdAt = Date()
        self.isSynced = false
    }
}
