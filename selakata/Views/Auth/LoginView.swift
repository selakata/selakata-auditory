//
//  LoginView.swift
//  selakata
//
//  Created by ais on 05/11/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showingMainView = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // MARK: - Header
                VStack {
                    Text("SelaKata")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.top, 60)

                    Spacer()
                }
                .frame(height: geometry.size.height * 0.2)

                // MARK: - Description
                VStack(spacing: 16) {
                    Text(
                        "No more endless 'what?' moments. SelaKata keeps the convo rolling!"
                    )
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 32)
                }
                .frame(maxHeight: .infinity)

                // MARK: - Sign In Button
                VStack {
                    Spacer()

                    AppleSignInButton(
                        action: {
                            viewModel.signInWithApple()
                        },
                        isLoading: viewModel.isLoading
                    )
                    .padding(.horizontal, 24)

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 24)
                    }

                    Spacer()
                }
                .frame(height: geometry.size.height * 0.3)
            }
        }
        .padding(36)
        .background(Color(.systemBackground))
        // MARK: - Navigation
        .fullScreenCover(isPresented: $showingMainView) {
            MainView()
        }
        .onChange(of: viewModel.isAuthenticated) { oldValue, newValue in
            if newValue {
                showingMainView = true
            }
        }
        .onAppear {
            if viewModel.isAuthenticated {
                showingMainView = true
            }
        }
        // MARK: - Loading Overlay
        .overlay(
            Group {
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: .white)
                        )
                        .scaleEffect(1.2)
                }
            }
        )
        // MARK: - Alert Handling
        .alert(
            "Authentication Error",
            isPresented: .constant(viewModel.errorMessage != nil)
        ) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    LoginView()
}
