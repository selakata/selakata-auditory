//
//  User.swift
//  selakata
//
//  Created by ais on 12/11/25.
//
import Foundation

public struct User: Codable {
    let id: String
    let username: String
    let appleId: String?
    let email: String
    let name: String
    let role: String
    let createdAt: String
    let updatedAt: String
    let snrBaselineHistories: [String]?
    let earThresholds: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case appleId
        case email
        case name
        case role
        case createdAt
        case updatedAt
        case snrBaselineHistories
        case earThresholds
    }
}
