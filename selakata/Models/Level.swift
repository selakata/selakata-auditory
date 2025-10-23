//
//  Level.swift
//  selakata
//
//  Created by Anisa Amalia on 21/10/25.
//

import Foundation
import SwiftData

@Model
final class Level {
    @Attribute(.unique) var id: UUID
    var name: String
    var orderIndex: Int
    var isCompleted: Bool
    var module: Module?
    
    init (name: String, orderIndex: Int, isCompleted: Bool = false, module: Module? = nil) {
        self.id = UUID()
        self.name = name
        self.orderIndex = orderIndex
        self.isCompleted = isCompleted
        self.module = module
    }
}
