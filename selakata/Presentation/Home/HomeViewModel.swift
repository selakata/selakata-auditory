//
//  HomeViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 18/10/25.
//

import Foundation
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var mostRecentModule: Module?
    @Published var firstAvailableModule: Module?
    
    private let authService: AuthenticationService
    
    var userName: String {
        return authService.userName
    }
    
    var isAuthenticated: Bool {
        return authService.isAuthenticated
    }

    init(modelContext: ModelContext? = nil, authService: AuthenticationService? = nil) {
        self.authService = authService ?? AuthenticationService()
    }
    
    func processModules(_ modules: [Module]) {
        let sortedModules = modules.sorted(by: { $0.orderIndex < $1.orderIndex })
        
        self.mostRecentModule = sortedModules.first { $0.progress < 1.0 }
        self.firstAvailableModule = sortedModules.first
    }
}

