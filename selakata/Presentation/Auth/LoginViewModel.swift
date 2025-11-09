//
//  LoginViewModel.swift
//  selakata
//
//  Created by ais on 05/11/25.
//

import Combine
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Dependencies
    private let authService: AuthenticationService

    private let authUseCase: AuthUseCase
    @Published var authResponse: AuthResponse?
    @Published var errorMessage2: String?

    // MARK: - Published properties (observed by View)
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(authService: AuthenticationService? = nil, authUseCase: AuthUseCase) {
        // Construct the default dependency inside the main-actor isolated context
        self.authService = authService ?? AuthenticationService()
        self.authUseCase = authUseCase
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
        // --- 1. Update isAuthenticated binding biasa
        authService.$isAuthenticated
            .receive(on: RunLoop.main)
            .assign(to: &$isAuthenticated)
        
        // --- 2. Combine 3 publisher untuk user data
        Publishers.CombineLatest3(
            authService.$userAuthId,
            authService.$userEmail,
            authService.$userFullName
        )
        .compactMap { id, email, name -> (String, String, String)? in
            // Hanya lanjut kalau semua non-nil
            guard
                let id = id,
                let email = email,
                let name = name
            else { return nil }
            return (id, email, name)
        }
        // --- 3. Trigger hanya saat user benar-benar sudah authenticated
        .combineLatest(authService.$isAuthenticated)
        .filter { _, isAuthed in isAuthed } // pastikan user udah login
        .map { combined, _ in combined }    // ambil tuple (id, email, name)
        .receive(on: RunLoop.main)
        .sink { [weak self] (userId, email, fullName) in
            guard let self = self else { return }
            
            self.authUseCase.execute(
                username: userId,
                appleId: userId,
                email: email,
                name: fullName
            ) { [weak self] result in
                switch result {
                case .success(let authResponse):
                    DispatchQueue.main.async {
                        self?.authResponse = authResponse
                        print("✅ AUTH SUCCESS:", authResponse)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = error.localizedDescription
                        print("❌ AUTH ERROR:", error.localizedDescription)
                    }
                }
            }
        }
        .store(in: &cancellables)
        
        // --- 4. Loading & error binding
        authService.$isLoading
            .receive(on: RunLoop.main)
            .assign(to: &$isLoading)
        
        authService.$errorMessage
            .receive(on: RunLoop.main)
            .assign(to: &$errorMessage)
    }
}
