//
//  Untitled.swift
//  selakata
//
//  Created by ais on 21/10/25.
//

import Foundation

struct Answer: Identifiable {
    let id = UUID()
    let title: String
    let isCorrect: Bool
    
    init(title: String, isCorrect: Bool = false) {
        self.title = title
        self.isCorrect = isCorrect
    }
}

struct Question {
    let id = UUID()
    let text: String
    let answers: [Answer]
}
