//
//  LevelResponse.swift
//  selakata
//
//  Created by ais on 06/11/25.
//


import Foundation

// MARK: - Root Response
public struct LevelResponse: Codable {
    let data: [Category]
    let meta: Meta
}
