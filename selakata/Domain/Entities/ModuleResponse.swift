//
//  ModuleResponse.swift
//  selakata
//
//  Created by ais on 06/11/25.
//


import Foundation

// MARK: - Root Response
public struct ModuleResponse: Codable {
    let data: [Category]
    let meta: Meta
}

// MARK: - Data Model
struct Category: Codable {
    let id: String
    let label: String
    let value: Int
    var description: String = ""
    let isActive: Bool
    let createdAt: String
    let updatedAt: String
    let updatedBy: String
}

// MARK: - Meta Model
struct Meta: Codable {
    let currentPage: Int
    let from: Int
    let to: Int
    let lastPage: Int
    let perPage: Int
    let total: Int
}
