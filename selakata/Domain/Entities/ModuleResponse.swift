//  Created by ais on 06/11/25.

import Foundation

public struct ModuleResponse: Codable {
    let data: [Category]
    let meta: Metadata
}

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
