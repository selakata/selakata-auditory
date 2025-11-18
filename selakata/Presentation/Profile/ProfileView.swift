//  Created by Anisa Amalia on 07/11/25.

import SwiftUI
import SwiftData

struct ProfileView: View {
    @StateObject private var viewModel = DependencyContainer.shared.makeProfileViewModel()
    @Environment(\.modelContext) private var modelContext
    @AppStorage("selectedVoiceID") private var selectedVoiceID: String?
    
    @EnvironmentObject var authService: AuthenticationService
    @Query private var savedVoices: [LocalAudioFile]
    
    @State private var showLogoutConfirmation = false
    
    private var currentVoiceName: String {
        guard let selectedID = selectedVoiceID else {
            return "Default"
        }
        if let voice = savedVoices.first(where: { $0.voiceId == selectedID }) {
            return voice.voiceName
        }
        return "Default"
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 90))
                            .foregroundStyle(Color(.systemGray4))
                        
                        Text(authService.userFullName ?? "Learner")
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
                    NavigationLink(destination: PersonalVoiceListView()) {
                        HStack {
                            Image(systemName: "mic"); Text("Personalized voice")
                            Spacer()
                            Text(currentVoiceName)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    NavigationLink(destination: ReportView()) {
                        HStack(spacing: 13) {
                            Image(systemName: "progress.indicator")
                                .foregroundStyle(.secondary)
                            Text("Report")
                        }
                    }
                    
                    let submitUseCase = DependencyContainer.shared.submitEarlyTestUseCase
                    
                    NavigationLink(destination: HearingTestResultsView(
                        isFromProfile: true,
                        repository: viewModel.hearingTestRepository,
                        submitEarlyTestUseCase: submitUseCase
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
                
                Section {
                    Button(role: .destructive) {
                        showLogoutConfirmation = true
                    } label: {
                        HStack(spacing: 13) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(.red)
                            Text("Log out")
                                .foregroundStyle(.red)
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
            .confirmationDialog(
                "Are you sure you want to log out?",
                isPresented: $showLogoutConfirmation,
                titleVisibility: .visible
            ) {
                Button("Log out", role: .destructive) {
                    authService.signOut()
                }
                Button("Cancel", role: .cancel) { }
            }

        }
    }
}
