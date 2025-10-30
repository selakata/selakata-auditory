//
//  ModuleNew.swift
//  selakata
//
//  Created by ais on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class ModuleNew{
    @Attribute(.unique) var id: UUID
    var label : String
    var desc: String
    var isActive: Bool
    var createdAt: String
    var updatedAt: String
    var updatedBy: String
    var levelList: [LevelNew]
    
    init(id: UUID, label: String, desc: String, isActive: Bool, createdAt: String, updatedAt: String, updatedBy: String, levelList: [LevelNew]) {
        self.id = id
        self.label = label
        self.desc = desc
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.updatedBy = updatedBy
        self.levelList = levelList
    }
}
