//
//  LoginViewModel.swift
//  selakata
//
//  Created by ais on 05/11/25.
//

import SwiftUI
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Dependencies
    private let authService: AuthenticationService
    
    // MARK: - Published properties (observed by View)
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(authService: AuthenticationService? = nil) {
        // Construct the default dependency inside the main-actor isolated context
        self.authService = authService ?? AuthenticationService()
        bindAuthService()
    }
    
    // MARK: - Public functions
    func signInWithApple() {
        authService.signInWithApple()
    }
    
    func signOut() {
        authService.signOut()
    }
    
    // MARK: - Private binding
    private func bindAuthService() {
        authService.$isAuthenticated
            .receive(on: RunLoop.main)
            .assign(to: &$isAuthenticated)
        
        authService.$isLoading
            .receive(on: RunLoop.main)
            .assign(to: &$isLoading)
        
        authService.$errorMessage
            .receive(on: RunLoop.main)
            .assign(to: &$errorMessage)
    }
}
