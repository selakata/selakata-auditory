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
    @Published var mostRecentModule: LocalModule?
    @Published var firstAvailableModule: LocalModule?
    
    private let authService: AuthenticationService
    
    var userName: String {
        return " (ID: \(authService.userAuthId ?? "N/A"))"
    }
    
    var isAuthenticated: Bool {
        return authService.isAuthenticated
    }

    init(modelContext: ModelContext? = nil, authService: AuthenticationService? = nil) {
        self.authService = authService ?? AuthenticationService()
    }
    
    func processModules(_ modules: [LocalModule]) {
        let sortedModules = modules.sorted(by: { $0.orderIndex < $1.orderIndex })
        
        self.mostRecentModule = sortedModules.first { $0.progress < 1.0 }
        self.firstAvailableModule = sortedModules.first
    }
}

