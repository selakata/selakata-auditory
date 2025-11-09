//
//  AuthenticationService.swift
//  selakata
//
//  Created by ais on 02/11/25.
//

import AuthenticationServices
import Foundation
import SwiftUI

@MainActor
final class AuthenticationService: NSObject, ObservableObject {
    // MARK: - Published states
    @Published var isAuthenticated = false
    @Published var userAuthId: String?
    @Published var userFullName: String?
    @Published var userEmail: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Keychain
    private let keychainService = "com.selakata.auth"
    private let keychainAccount = "appleUserId"

    // MARK: - Init
    override init() {
        super.init()
        checkAuthenticationState()
    }

    // MARK: - Sign In
    func signInWithApple() {
        isLoading = true
        errorMessage = nil

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [
            request
        ])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    // MARK: - Sign Out
    func signOut() {
        isAuthenticated = false
        userAuthId = nil
        userFullName = nil
        userEmail = nil

        // Hapus data dari Keychain dan UserDefaults
        KeychainHelper.shared.delete(
            service: keychainService,
            account: keychainAccount
        )
        UserDefaults.standard.removeObject(forKey: "user_name")
        UserDefaults.standard.removeObject(forKey: "user_email")

        print("🚪 User signed out and data cleared.")
    }

    // MARK: - Check state (auto login)
    private func checkAuthenticationState() {
        // Cek apakah userId tersimpan di Keychain
        guard
            let data = KeychainHelper.shared.read(
                service: keychainService,
                account: keychainAccount
            ),
            let userId = String(data: data, encoding: .utf8)
        else {
            print(
                "❌ Tidak ada Apple ID tersimpan di Keychain, tampilkan LoginView"
            )
            return
        }

        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userId) {
            [weak self] (state, error) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch state {
                case .authorized:
                    self.isAuthenticated = true
                    self.userFullName = UserDefaults.standard.string(
                        forKey: "user_name"
                    )
                    self.userEmail = UserDefaults.standard.string(
                        forKey: "user_email"
                    )
                    print("✅ Apple ID valid, langsung masuk Home (\(userId))")
                case .revoked, .notFound:
                    self.signOut()
                default:
                    break
                }
            }
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthenticationService: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        isLoading = false

        guard
            let credential = authorization.credential
                as? ASAuthorizationAppleIDCredential
        else {
            self.errorMessage = "Invalid Apple credential"
            return
        }

        let authId = credential.user
        let fullName = credential.fullName
        let email = credential.email

        print("🍏 Apple Sign In success:")
        print(" - userId:", authId)
        print(" - fullName:", fullName?.formatted() ?? "nil")
        print(" - email:", email ?? "nil")

        let data = Data(authId.utf8)
        KeychainHelper.shared.save(
            data,
            service: keychainService,
            account: keychainAccount
        )

        self.userAuthId = authId

        if let email = email {
            UserDefaults.standard.set(email, forKey: "user_email")
            self.userEmail = email
        }

        if let fullName = fullName {
            let displayName = PersonNameComponentsFormatter().string(
                from: fullName
            )
            if !displayName.isEmpty {
                UserDefaults.standard.set(displayName, forKey: "user_name")
                self.userFullName = displayName
            }
        }

        // Mark as authenticated
        self.isAuthenticated = true
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
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

        print("❌ Apple Sign In error:", errorMessage ?? "unknown error")
    }
}

// MARK: - Presentation Context
extension AuthenticationService:
    ASAuthorizationControllerPresentationContextProviding
{
    func presentationAnchor(for controller: ASAuthorizationController)
        -> ASPresentationAnchor
    {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
            let window = windowScene.windows.first
        else {
            return ASPresentationAnchor()
        }
        return window
    }
}
