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
    @StateObject private var viewModel = DependencyContainer.shared.makePersonalVoiceViewModel()
    @StateObject private var audioPlayerService = AudioPlayerService()
    @AppStorage("selectedVoiceID") private var selectedVoiceID: String?
    
    @State private var isPersonalVoiceOn: Bool
    @State private var expandedVoiceID: String? = nil
    @State private var showingConfirmationSheet = false
    @State private var pendingSelection: LocalAudioFile? = nil
    
    @Query(sort: \LocalAudioFile.createdAt) private var savedVoices: [LocalAudioFile]

    init() {
        let storedID = UserDefaults.standard.string(forKey: "selectedVoiceID")
        _isPersonalVoiceOn = State(initialValue: storedID != nil)
    }
    

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Toggle("Personalized Voice", isOn: $isPersonalVoiceOn)
                    .tint(.accentColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 20)

                if savedVoices.isEmpty {
                    emptyStateView
                        .frame(maxHeight: .infinity)
                        .disabled(!isPersonalVoiceOn)
                        .opacity(isPersonalVoiceOn ? 1.0 : 0.5)
                } else {
                    List {
                        voiceListView
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            .listRowSeparator(.visible)
                    }
                    .listStyle(.plain)
                    .disabled(!isPersonalVoiceOn)
                    .opacity(isPersonalVoiceOn ? 1.0 : 0.5)
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
                    .disabled(!isPersonalVoiceOn)
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
            .onChange(of: isPersonalVoiceOn) { _, isOn in
                if isOn {
                    if selectedVoiceID == nil {
                        selectedVoiceID = savedVoices.first?.voiceId
                    }
                } else {
                    selectedVoiceID = nil
                    expandedVoiceID = nil
                }
            }
            .sheet(isPresented: $showingConfirmationSheet) {
                ConfirmationSheetView(
                    onConfirm: {
                        if let newVoice = pendingSelection {
                            selectedVoiceID = newVoice.voiceId
                            expandedVoiceID = newVoice.voiceId
                        }
                        pendingSelection = nil
                        showingConfirmationSheet = false
                    },
                    onCancel: {
                        pendingSelection = nil
                        showingConfirmationSheet = false
                    }
                )
                .presentationDetents([.fraction(0.3)])
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image("emptyVoice")
                .font(.system(size: 150))
                .foregroundStyle(Color(.systemGray4))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("No personalized voice yet")
                .font(.title2.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Tap the \"+\" button to create one.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        .padding()
    }
    
    private var voiceListView: some View {
        ForEach(savedVoices) { voice in
            VoiceRowView(
                voice: voice,
                audioPlayerService: audioPlayerService,
                isSelected: selectedVoiceID == voice.voiceId,
                isExpanded: expandedVoiceID == voice.voiceId
            )
            .onTapGesture {
                handleVoiceTap(voice)
            }
            .buttonStyle(.plain)
        }
    }
    
    private func handleVoiceTap(_ voice: LocalAudioFile) {
        guard isPersonalVoiceOn else { return }
        
        let tappedNewVoice = selectedVoiceID != nil && selectedVoiceID != voice.voiceId
        let tappedSameVoice = selectedVoiceID == voice.voiceId
        
        if tappedSameVoice {
            withAnimation {
                expandedVoiceID = (expandedVoiceID == voice.voiceId) ? nil : voice.voiceId
            }
        } else if tappedNewVoice {
            pendingSelection = voice
            showingConfirmationSheet = true
        } else {
            withAnimation {
                selectedVoiceID = voice.voiceId
                expandedVoiceID = voice.voiceId
            }
        }
    }
}

struct ConfirmationSheetView: View {
    var onConfirm: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Are you sure you'd like to\nupdate your selected voice?")
                .font(.title2.weight(.bold))
                .multilineTextAlignment(.center)
            
            Button("Yes, please") {
                onConfirm()
            }
            .font(.headline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            
            Button("Cancel") {
                onCancel()
            }
            .font(.headline.weight(.semibold))
            
            Spacer()
        }
        .padding()
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
