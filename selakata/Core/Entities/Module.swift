//
//  Module.swift
//  selakata
//
//  Created by ais on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class Module{
    @Attribute(.unique) var id: UUID
    var label : String
    var desc: String
    var isActive: Bool
    var createdAt: String
    var updatedAt: String
    var updatedBy: String
    var levelList: [Level]
    var progress: Double
    var orderIndex: Int
    
    init(id: UUID, label: String, desc: String, isActive: Bool, createdAt: String, updatedAt: String, updatedBy: String, levelList: [Level]) {
        self.id = id
        self.label = label
        self.desc = desc
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
        self.levelList = levelList
        self.progress = 0.0
        self.orderIndex = 0
    }
}
