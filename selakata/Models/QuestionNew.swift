//
//  Questions.swift
//  selakata
//
//  Created by ais on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class QuestionNew{
    var id: String
    var text: String
    var urutan: Int
    var mainVolume: Bool
    var noiseVolume: String
    var createdAt: String
    var updatedAt: String
    var updatedBy: String
    var answerList: [AnswerNew]
    
    init(id: String, text: String, urutan: Int, mainVolume: Bool, noiseVolume: String, createdAt: String, updatedAt: String, updatedBy: String, answerList: [AnswerNew]) {
        self.id = id
        self.text = text
        self.urutan = urutan
        self.mainVolume = mainVolume
        self.noiseVolume = noiseVolume
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
        self.answerList = answerList
    }
}
