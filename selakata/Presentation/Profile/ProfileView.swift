//
//  ProfileView.swift
//  selakata
//
//  Created by Anisa Amalia on 07/11/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()

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
                }
                .listRowBackground(Color.clear)

                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bring familiar voices into your training!")
                        .font(.headline.weight(.bold))
                    Text("Subscribe to unlock custom voice made for you or of someone close to your heart.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                
                Section("Details") {
                    NavigationLink(destination: Text("Personal Voice")) {
                        HStack {
                            Image(systemName: "mic"); Text("Personalized voice")
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
                        repository: viewModel.hearingTestRepository
                    )) {
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
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}

#Preview {
    ProfileView()
}
