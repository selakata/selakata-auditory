//
//  LevelNew.swift
//  selakata
//
//  Created by ais on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class LevelNew {
    @Attribute(.unique) var id: String
    var label: String
    var value: Int
    var isActive: Bool
    var createdAt: String
    var updatedAt: String
    var updatedBy: String
    @Relationship(deleteRule: .cascade)
    var questions: [QuestionNew]
    
    init (id: String, label: String, value: Int, isActive: Bool, createdAt: String, updatedAt: String, updatedBy: String, questions: [QuestionNew] = []) {
        self.id = id
        self.label = label
        self.value = value
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
        self.questions = questions
    }
}
