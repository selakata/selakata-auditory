//  Created by ais on 05/11/25.

import Combine
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Dependencies
    private let authService: AuthenticationService

    private let authUseCase: AuthUseCase
    @Published var authData: AuthData?
    @Published var errorMessage2: String?

    // MARK: - Published properties (observed by View)
    @Published var isAuthenticated: Bool = false
    @Published var isServerAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(authService: AuthenticationService? = nil, authUseCase: AuthUseCase) {
        self.authService = authService ?? AuthenticationService()
        self.authUseCase = authUseCase
        bindAuthService()
        
        if getFromKeychain(for: "token") != nil {
            self.isServerAuthenticated = true
            print("LoginViewModel: Token found in keychain. User is already authenticated.")
        }
    }

    // MARK: - Public functions
    func signInWithApple() {
        authService.signInWithApple()
    }

    func signOut() {
        authService.signOut()
        deleteFromKeychain(for: "token")
        self.isServerAuthenticated = false
        self.authData = nil
    }

    // MARK: - Private binding
    private func bindAuthService() {
        authService.$isAuthenticated
            .receive(on: RunLoop.main)
            .assign(to: &$isAuthenticated)

        authService.$userAuthId
            .compactMap { $0 }
            .combineLatest(authService.$isAuthenticated)
            .filter { (userId, isAuthed) in isAuthed }
            .map { (userId, isAuthed) in userId }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] (userId) in
                guard let self = self else { return }
                
                if self.isServerAuthenticated { return }
                
                let email = self.authService.userEmail
                            ?? UserDefaults.standard.string(forKey: "user_email")
                            ?? "\(userId)@privaterelay.appleid.com" // Default fallback

                let nameFromService = self.authService.userFullName
                let nameFromDefaults = UserDefaults.standard.string(forKey: "user_name")
                
                var name = "Learner"
                if let nameFromService = nameFromService, !nameFromService.isEmpty {
                    name = nameFromService
                } else if let nameFromDefaults = nameFromDefaults, !nameFromDefaults.isEmpty {
                    name = nameFromDefaults
                }
                

                print("LoginViewModel: Apple Sign-In success. Now logging into team server...")
                self.isLoading = true
                
                self.authUseCase.execute(
                    username: userId,
                    appleId: userId,
                    email: email,
                    name: name
                ) { [weak self] result in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        switch result {
                        case .success(let authResponse):
                            self.authData = authResponse.data
                            
                            // Save the token
                            saveToKeychain(value: authResponse.data.token, for: "token")
                            
                            
                            self.isServerAuthenticated = true
                            
                            print("[LoginViewModel] AISDEBUG:AUTH:SUCCESS: Real token saved. User is fully authenticated.")
                            
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            print("[LoginViewModel] AISDEBUG:AUTH:ERROR:", error.localizedDescription)
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        authService.$isLoading
            .receive(on: RunLoop.main)
            .assign(to: &$isLoading)
        
        authService.$errorMessage
            .receive(on: RunLoop.main)
            .assign(to: &$errorMessage)
    }
}
