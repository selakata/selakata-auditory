//
//  Level 2.swift
//  selakata
//
//  Created by ais on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class Level {
    @Attribute(.unique) var id: UUID
    var label: String
    var value: Int
    var isActive: Bool
    var createdAt: String
    var updatedAt: String
    var updatedBy: String
    var question: [Question]
    
    init(id: UUID, label: String, value: Int, isActive: Bool, createdAt: String, updatedAt: String, updatedBy: String, question: [Question] = []) {
        self.id = id
        self.label = label
        self.value = value
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
        self.question = question
    }
}
