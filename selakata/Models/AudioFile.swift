//
//  AudioFile.swift
//  selakata
//
//  Created by ais on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class AudioFile{
    @Attribute(.unique) var id: UUID
    var fileName: String
    var fileURL: String
    var size: Int
    var duration: Int
    var snr: Int
    var voiceId: String
    var voiceName: String
    var similiarityBoost : Double
    var speed: Double
    var stability: Double
    var useSpeakerBoost: Bool
    var type: Int
    var createdAt: String
    var updatedAt: String
    var updatedBy: String
    
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
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
    }
}
