//
//  Question.swift
//  selakata
//
//  Created by ais on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class Question {
    @Attribute(.unique) var id: UUID
    var text: String
    var urutan: Int
    var mainVolume: Int
    var noiseVolume: Int
    var createdAt: String
    var updatedAt: String
    var updatedBy: String
    var audioFile: AudioFile
    var answer: [Answer]
    
    init(id: UUID, text: String, urutan: Int, mainVolume: Int, noiseVolume: Int, createdAt: String, updatedAt: String, updatedBy: String, audioFile: AudioFile, answer: [Answer] = []) {
        self.id = id
        self.text = text
        self.urutan = urutan
        self.mainVolume = mainVolume
        self.noiseVolume = noiseVolume
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
        self.audioFile = audioFile
        self.answer = answer
    }
}
