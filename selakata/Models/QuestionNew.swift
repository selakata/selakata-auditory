//
//  QuestionNew.swift
//  selakata
//
//  Created by ais on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class QuestionNew {
    @Attribute(.unique) var id: UUID
    var text: String
    var urutan: Int
    var mainVolume: Int
    var noiseVolume: Int
    var createdAt: String
    var updatedAt: String
    var updatedBy: String
    var audioFile: AudioFile
    
    init(id: UUID, text: String, urutan: Int, mainVolume: Int, noiseVolume: Int, createdAt: String, updatedAt: String, updatedBy: String, audioFile: AudioFile) {
        self.id = id
        self.text = text
        self.urutan = urutan
        self.mainVolume = mainVolume
        self.noiseVolume = noiseVolume
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
        self.audioFile = audioFile
    }
}
