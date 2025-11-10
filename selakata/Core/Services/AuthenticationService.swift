//
//  AuthenticationService.swift
//  selakata
//
//  Created by ais on 02/11/25.
//

import Foundation
import AuthenticationServices
import SwiftUI

@MainActor
class AuthenticationService: NSObject, ObservableObject, ProfileRepository {
    @Published var isAuthenticated = false
    @Published var userName = "Learner"
    @Published var userEmail: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let keychainService = "com.selakata.auth"
    private let keychainAccount = "appleUserId"
    
    override init() {
        super.init()
        checkAuthenticationState()
    }
    
    func signInWithApple() {
        isLoading = true
        errorMessage = nil
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func signOut() {
        isAuthenticated = false
        userName = "Learner"
        userEmail = nil
        
        // Hapus data dari Keychain dan UserDefaults
        KeychainHelper.shared.delete(service: keychainService, account: keychainAccount)
        UserDefaults.standard.removeObject(forKey: "user_name")
        UserDefaults.standard.removeObject(forKey: "user_email")
    }
    
    private func checkAuthenticationState() {
        // Cek apakah userId tersimpan di Keychain
        if let data = KeychainHelper.shared.read(service: keychainService, account: keychainAccount),
           let userId = String(data: data, encoding: .utf8) {
            
            // Validasi ke Apple
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userId) { [weak self] (credentialState, error) in
                DispatchQueue.main.async {
                    switch credentialState {
                    case .authorized:
                        self?.isAuthenticated = true
                        self?.userName = UserDefaults.standard.string(forKey: "user_name") ?? "Learner"
                        self?.userEmail = UserDefaults.standard.string(forKey: "user_email")
                        print("✅ Apple ID valid, langsung masuk Home")
                    case .revoked, .notFound:
                        self?.signOut()
                    default:
                        break
                    }
                }
            }
        } else {
            print("❌ Tidak ada Apple ID tersimpan di Keychain, tampilkan LoginView")
        }
    }
    
    func getUserName() -> String {
        return self.userName
    }
}

extension AuthenticationService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        isLoading = false
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // Simpan user ID ke Keychain
            let data = Data(userIdentifier.utf8)
            KeychainHelper.shared.save(data, service: keychainService, account: keychainAccount)
            
            // Simpan data tambahan
            if let email = email {
                UserDefaults.standard.set(email, forKey: "user_email")
                self.userEmail = email
            }
            
            if let fullName = fullName {
                let displayName = PersonNameComponentsFormatter().string(from: fullName)
                if !displayName.isEmpty {
                    UserDefaults.standard.set(displayName, forKey: "user_name")
                    self.userName = displayName
                }
            }
            
            self.isAuthenticated = true
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isLoading = false
        
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled: errorMessage = "Sign in was canceled"
            case .failed: errorMessage = "Sign in failed"
            case .invalidResponse: errorMessage = "Invalid response"
            case .notHandled: errorMessage = "Sign in not handled"
            case .unknown: errorMessage = "Unknown error occurred"
            @unknown default: errorMessage = "An error occurred"
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
}

extension AuthenticationService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return ASPresentationAnchor()
        }
        return window
    }
}
