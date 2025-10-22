//
//  ModuleDetailViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 21/10/25.
//

import Foundation

@MainActor
class ModuleDetailViewModel: ObservableObject {

    func isLevelUnlocked(_ level: Level, in allLevels: [Level]) -> Bool {
        if level.orderIndex == 0 {
            return true
        }

        if let previousLevel = allLevels.first(where: { $0.orderIndex == level.orderIndex - 1 }) {
            return previousLevel.isCompleted
        }

        return false
    }
}
