//
//  Module.swift
//  selakata
//
//  Created by Anisa Amalia on 18/10/25.
//

import Foundation
import SwiftData

@Model
final class Module {
    @Attribute(.unique) var id: String
    var name: String
    var details: String
    var progress: Double
    var image: String
    var orderIndex: Int

    init(id: String, name: String, details: String, progress: Double, image: String, orderIndex: Int) {
        self.id = id
        self.name = name
        self.details = details
        self.progress = progress
        self.image = image
        self.orderIndex = orderIndex
    }
}
