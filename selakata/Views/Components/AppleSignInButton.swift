//
//  AppleSignInButton.swift
//  selakata
//
//  Created by Kiro on 02/11/25.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: View {
    let action: () -> Void
    let isLoading: Bool
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "applelogo")
                        .font(.system(size: 18, weight: .medium))
                }
                
                Text(isLoading ? "Signing In..." : "Sign in with Apple")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color.slColor)
            .cornerRadius(20)
        }
        .disabled(isLoading)
    }
}

struct SignOutButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .medium))
                
                Text("Sign Out")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color.red.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        AppleSignInButton(action: {}, isLoading: false)
        AppleSignInButton(action: {}, isLoading: true)
        SignOutButton(action: {})
    }
    .padding()
}
