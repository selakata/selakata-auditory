//  Created by ais on 02/11/25.

import AuthenticationServices
import Foundation
import Combine

@MainActor
final class AuthenticationService: NSObject, ObservableObject {
    // MARK: - Published states
    @Published var isAuthenticated = false
    @Published var isServerAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var userAuthId: String?
    @Published var userFullName: String?
    @Published var userEmail: String?
    @Published var token: String?
    
    private let authUseCase: AuthUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private let keychainKey = "appleUserId"
    private let tokenKey = "token"
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
        super.init()
        checkAuthenticationState()
    }
    
    func signInWithApple() {
        isLoading = true
        errorMessage = nil
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func signOut() {
        isAuthenticated = false
        isServerAuthenticated = false
        userAuthId = nil
        userFullName = nil
        userEmail = nil
        
        deleteFromKeychain(for: keychainKey)
        deleteFromKeychain(for: tokenKey)
        UserDefaults.standard.removeObject(forKey: "user_name")
        UserDefaults.standard.removeObject(forKey: "user_email")
    }
    
    private func authenticateWithServer(userId: String, email: String, name: String) {
        isLoading = true
        
        authUseCase.execute(
            username: userId,
            appleId: userId,
            email: email,
            name: name
        ) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    self.isServerAuthenticated = true
                    self.userFullName = response.data.user.name
                    saveToKeychain(value: response.data.token, for: "token")
                    print("Server auth success. Token saved.")
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Server auth failed:", error.localizedDescription)
                }
            }
        }
    }
    
    private func getMyProfile() {
        isLoading = true
        
        authUseCase.getMe { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.data.name, forKey: "user_name")
                    UserDefaults.standard.set(response.data.email, forKey: "user_email")
                    
                    self.userFullName = response.data.name
                    self.userEmail = response.data.email
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Get profile filed:", error.localizedDescription)
                }
            }
        }
    }
    
    private func checkAuthenticationState() {
        guard
            let userId = getFromKeychain(for: keychainKey),
            let token = getFromKeychain(for: tokenKey),
            !userId.isEmpty,
            !token.isEmpty
        else {
            print("Automatic signout: missing userId or token in Keychain")
            signOut()
            return
        }
        
        self.token = token
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userId) { [weak self] (state, _) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch state {
                case .authorized:
                    let cachedName = UserDefaults.standard.string(forKey: "user_name")
                    let cachedEmail = UserDefaults.standard.string(forKey: "user_email")
                    
                    if cachedName == nil || cachedEmail == nil {
                        print("Missing profile cache — calling getMyProfile()")
                        self.getMyProfile()
                    } else {
                        self.userFullName = cachedName
                        self.userEmail = cachedEmail
                    }
                    
                    self.isAuthenticated = true
                    self.isServerAuthenticated = true
                case .revoked, .notFound:
                    self.signOut()
                default:
                    break
                }
            }
        }
    }
    
    func getUserFullName() -> String {
        return self.userFullName ?? "Learner"
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthenticationService: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        isLoading = false
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.errorMessage = "Invalid Apple credential"
            return
        }
        
        let userId = credential.user
        
        let nameComponents = credential.fullName
        let fullName = [
            nameComponents?.givenName,
            nameComponents?.familyName
        ].compactMap { $0 }.joined(separator: " ")
        let finalName = fullName.isEmpty
        ? (UserDefaults.standard.string(forKey: "user_name") ?? "Learner")
        : fullName
        
        let email = credential.email
        ?? UserDefaults.standard.string(forKey: "user_email")
        ?? "\(userId)@privaterelay.appleid.com"
        
        print("🍏 Apple Sign In success:")
        print(" - userId:", userId)
        print(" - fullName:", finalName)
        print(" - email:", email)
        
        saveToKeychain(value: userId, for: keychainKey)
        
        self.userAuthId = userId
        self.userEmail = email
        self.userFullName = finalName
        self.isAuthenticated = true
        
        UserDefaults.standard.set(email, forKey: "user_email")
        UserDefaults.standard.set(finalName, forKey: "user_name")
        
        authenticateWithServer(userId: userId, email: email, name: finalName)
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        self.errorMessage = error.localizedDescription
        self.isLoading = false
        
        print("Apple Sign-In error:", error.localizedDescription)
    }
}

// MARK: - Presentation Context
extension AuthenticationService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else {
            return ASPresentationAnchor()
        }
        return window
    }
}
