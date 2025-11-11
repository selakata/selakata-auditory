//
//  PersonalVoiceListView.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import SwiftUI
import SwiftData

struct PersonalVoiceListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = PersonalVoiceViewModel()
    @StateObject private var audioPlayerService = AudioPlayerService()
    @AppStorage("selectedVoiceID") private var selectedVoiceID: String?

    @Query(sort: \LocalAudioFile.createdAt) private var savedVoices: [LocalAudioFile]

    var body: some View {
        NavigationStack {
            Group {
                if savedVoices.isEmpty {
                    emptyStateView
                } else {
                    voiceListView
                }
            }
            .navigationTitle("Personalized Voice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.addVoiceButtonTapped()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .sheet(isPresented: $viewModel.isShowingPrivacySheet) {
                PrivacyAgreementSheet(onContinue: {
                    viewModel.acceptPrivacy()
                })
                .presentationDetents([.fraction(0.3)])
            }
            .sheet(isPresented: $viewModel.shouldNavigateToRecorder) {
                NavigationStack {
                    VoiceRecordingGuideView(
                        isPresented: $viewModel.shouldNavigateToRecorder,
                        useCase: viewModel.useCase
                    )
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image("emptyVoice")
                .font(.system(size: 150))
                .foregroundStyle(Color(.systemGray4))
            
            Text("No personalized voice yet")
                .font(.title2.weight(.bold))
            
            Text("Tap the \"+\" button to create one.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            Spacer()
        }
        .padding()
    }
    
    private var voiceListView: some View {
        List(savedVoices) { voice in
            VoiceRowView(
                voice: voice,
                audioPlayerService: audioPlayerService,
                selectedVoiceID: $selectedVoiceID
            )
        }
    }
}

struct PrivacyAgreementSheet: View {
    var onContinue: () -> Void
    @State private var hasAgreed = false
    @State private var isShowingPrivacyNotice = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Privacy Agreement")
                .font(.title2.weight(.bold))
                .padding(.top)
            
            Text("Please review and agree to our Privacy Notice before continuing.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            HStack {
                Button(action: {
                    hasAgreed.toggle()
                }) {
                    Image(systemName: hasAgreed ? "checkmark.square.fill" : "square")
                        .font(.title3)
                        .foregroundStyle(hasAgreed ? .accent : .secondary)
                }
                
                HStack(spacing: 4) {
                    Text("I have agree and accept")
                    Button(action: {
                        isShowingPrivacyNotice = true
                    }) {
                        Text("Privacy Notice")
                            .foregroundColor(.accentColor)
                            .underline()
                    }
                }
                .font(.footnote)
                
                Spacer()
            }
            
            Button(action: onContinue) {
                Text("Continue")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .disabled(!hasAgreed)
        }
        .padding()
        .sheet(isPresented: $isShowingPrivacyNotice) {
            NavigationStack {
                PrivacyNoticeView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") { isShowingPrivacyNotice = false }
                        }
                    }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: LocalAudioFile.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
//    let voice1 = AudioFile(voiceName: "Flavia", rawText: "Test", localFileName: "file1.m4a", duration: 15)
//    let voice2 = AudioFile(voiceName: "Anisa", rawText: "Test", localFileName: "file2.m4a", duration: 20)
//    container.mainContext.insert(voice1)
//    container.mainContext.insert(voice2)

    return PersonalVoiceListView()
        .modelContainer(container)
}
