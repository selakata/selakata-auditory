//
//  ProfileView.swift
//  selakata
//
//  Created by Anisa Amalia on 04/11/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    private let repository = HearingTestRepository()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 90))
                            .foregroundStyle(Color(.systemGray4))
                        
                        Text(viewModel.userName)
                            .font(.system(size: 30).weight(.bold))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                }
                .listRowBackground(Color.clear)

                Section("Details") {
                    NavigationLink(destination: Text("Personalized Voice Page")) {
                        HStack(spacing: 13) {
                            Image(systemName: "mic.fill")
                                .foregroundStyle(.secondary)
                            Text("Personalized voice")
                            Spacer()
                            Text("Flavia") // tar ganti based on the current active personal voice
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    NavigationLink(destination: Text("Progress Page")) {
                        HStack(spacing: 13) {
                            Image(systemName: "progress.indicator")
                                .foregroundStyle(.secondary)
                            Text("Progress")
                        }
                    }
                    
                    NavigationLink(destination: HearingTestResultsView(
                        isFromProfile: true,
                        isStartingTest: .constant(false),
                        repository: repository)) {
                        HStack(spacing: 13) {
                            Image(systemName: "doc.badge.clock")
                                .foregroundStyle(.secondary)
                            Text("Hearing test result")
                        }
                    }
                    .disabled(!viewModel.hasHearingTestResult)
                }
                
                Section("Legal") {
                    NavigationLink(destination: PrivacyNoticeView()) {
                        HStack(spacing: 13) {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundStyle(.secondary)
                            Text("Privacy notice")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profile")
            .navigationBarHidden(true)
            .onAppear {
                viewModel.checkHearingTestStatus()
            }
        }
    }
}

#Preview {
    ProfileView()
}
