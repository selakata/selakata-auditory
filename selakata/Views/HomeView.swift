//
//  HomeView.swift
//  selakata
//
//  Created by Anisa Amalia on 18/10/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var authService = AuthenticationService()
    
    @Query(sort: \Module.orderIndex) private var allModules: [Module]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // buat mascot, sekarang placeholder pake icon aja ya
                    Image(systemName: "progress.indicator")
                        .font(.system(size: 150))
                        .foregroundStyle(.purple)
                        .padding(.top)

                    // greetings and authentication
                    VStack(spacing: 16) {
                        Text("Welcome back, \(authService.userName)!")
                            .font(.title3.weight(.bold))
                        
                        if !authService.isAuthenticated {
                            VStack(spacing: 12) {
                                Text("Sign in to save your progress")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                AppleSignInButton(
                                    action: {
                                        authService.signInWithApple()
                                    },
                                    isLoading: authService.isLoading
                                )
                                .padding(.horizontal, 24)
                                
                                if let errorMessage = authService.errorMessage {
                                    Text(errorMessage)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .padding(.horizontal, 24)
                                }
                            }
                        } else {
                            VStack(spacing: 8) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Signed in")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                if let email = authService.userEmail {
                                    Text(email)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                SignOutButton {
                                    authService.signOut()
                                }
                                .padding(.horizontal, 60)
                            }
                        }
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                    ReminderCard()
                        .padding(.horizontal, 24)
                    
                    progressCardSection
                    
                    NavigationLink(destination: HearingTestOnboardingView()){
                        HearingTestCard()
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
        }
        .onChange(of: allModules) {
            viewModel.processModules(allModules)
        }
        .onAppear {
            viewModel.processModules(allModules)
        }
    }
    
    private var progressCardSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let moduleToDisplay = viewModel.mostRecentModule ?? viewModel.firstAvailableModule {
                Text(moduleToDisplay.progress == 0.0 ? "Start your journey" : "Continue exercise")
                    .font(.headline)
                    .padding(.horizontal, 24)

                NavigationLink(destination: Text("Question Page")) {
                    ModuleCard(module: moduleToDisplay, showProgressBar: true)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
            } else {
                Text("Module not found")
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(20)
            }
        }
    }
}
