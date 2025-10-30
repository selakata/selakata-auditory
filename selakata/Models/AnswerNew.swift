//
//  Answer.swift
//  selakata
//
//  Created by ais on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class AnswerNew{
    var id: String
    var text: String
    var urutan: Int
    var isCorrect: Bool
    var createdAt: String
    var updatedAt: String
    
    init(id: String, text: String, urutan: Int, isCorrect: Bool, createdAt: String, updatedAt: String) {
        self.id = id
        self.text = text
        self.urutan = urutan
        self.isCorrect = isCorrect
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
