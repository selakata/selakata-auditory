//
//  Answer.swift
//  selakata
//
//  Created by ais on 12/11/25.
//

public struct Answer: Codable {
    let id: String
    let text: String
    let urutan: Int
    let isCorrect: Bool
    let createdAt: String
    let updatedAt: String
}
