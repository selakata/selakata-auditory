//
//  ModulesViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 18/10/25.
//

import Foundation

@MainActor
class ModulesViewModel: ObservableObject {
    
    func isModuleUnlocked(_ module: Module, in allModules: [Module]) -> Bool {
        if module.orderIndex == 0 {
            return true
        }

        if let previousModule = allModules.first(where: { $0.orderIndex == module.orderIndex - 1 }) {
            return previousModule.progress >= 1.0
        }

        return false
    }
}
