//
//  AuthenticationService.swift
//  selakata
//
//  Created by Kiro on 02/11/25.
//

import Foundation
import AuthenticationServices
import SwiftUI

@MainActor
class AuthenticationService: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var userName = "Learner"
    @Published var userEmail: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
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
        
        // Clear stored user data
        UserDefaults.standard.removeObject(forKey: "user_identifier")
        UserDefaults.standard.removeObject(forKey: "user_name")
        UserDefaults.standard.removeObject(forKey: "user_email")
    }
    
    private func checkAuthenticationState() {
        guard let userIdentifier = UserDefaults.standard.string(forKey: "user_identifier") else {
            return
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userIdentifier) { [weak self] (credentialState, error) in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    self?.isAuthenticated = true
                    self?.userName = UserDefaults.standard.string(forKey: "user_name") ?? "Learner"
                    self?.userEmail = UserDefaults.standard.string(forKey: "user_email")
                case .revoked, .notFound:
                    self?.signOut()
                default:
                    break
                }
            }
        }
    }
}

extension AuthenticationService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        isLoading = false
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // Store user data
            UserDefaults.standard.set(userIdentifier, forKey: "user_identifier")
            
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
            
//            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
//                print("User ID:", credential.user)
//                print("Email:", credential.email ?? "N/A")
//                print("Full name:", credential.fullName?.givenName ?? "N/A")
//                print("Identity token:", credential.identityToken != nil ? "✅ available" : "❌ missing")
//                print("Authorization code:", credential.authorizationCode != nil ? "✅ available" : "❌ missing")
//                print("Real user status:", credential.realUserStatus.rawValue)
//            }
            
            self.isAuthenticated = true
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isLoading = false
        
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                errorMessage = "Sign in was canceled"
            case .failed:
                errorMessage = "Sign in failed"
            case .invalidResponse:
                errorMessage = "Invalid response"
            case .notHandled:
                errorMessage = "Sign in not handled"
            case .unknown:
                errorMessage = "Unknown error occurred"
            @unknown default:
                errorMessage = "An error occurred"
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
