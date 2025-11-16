//
//  PersonalVoiceViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import Foundation
import SwiftData

@MainActor
class PersonalVoiceViewModel: ObservableObject {
    
    @Published var isShowingPrivacySheet = false
    @Published var shouldNavigateToRecorder = false
    
    @Published var isSyncing = false
    private var modelContext: ModelContext?
    private var hasBeenSetup = false
    
    let useCase: PersonalVoiceUseCase

    private let privacyKey = "hasAcceptedVoicePrivacy"
    
    init() {
        let repository = PersonalVoiceRepositoryImpl()
        let apiClient = APIClient()
        let appConfig = AppConfiguration()
        let voiceConfig = VoiceAPIConfiguration(configuration: appConfig)
        let elevenLabsConfig = ElevenLabsAPIConfiguration(configuration: appConfig)
        
        let recorder = AudioRecorderService()
        let player = AudioPlayerService()

        self.useCase = PersonalVoiceUseCase(
            recorder: recorder,
            player: player,
            repository: repository,
            apiClient: apiClient,
            voiceConfig: voiceConfig,
            elevenLabsConfig: elevenLabsConfig
        )
    }
    
    func setup(with context: ModelContext) {
        guard !hasBeenSetup else { return }
        self.modelContext = context
        self.hasBeenSetup = true
    }
    
    func syncVoiceList() {
        guard let context = modelContext, !isSyncing else {
            if modelContext == nil {
                print("Sync failed, modelContext is nil.")
            }
            return
        }
        
        isSyncing = true
        useCase.syncVoiceList(context: context) { [weak self] result in
            self?.isSyncing = false
            switch result {
            case .success:
                print("Sync complete.")
            case .failure(let error):
                print("Sync failed: \(error.localizedDescription)")
            }
        }
    }
    
    func addVoiceButtonTapped() {
        if hasAcceptedPrivacy() {
            shouldNavigateToRecorder = true
        } else {
            isShowingPrivacySheet = true
        }
    }
    
    func acceptPrivacy() {
        UserDefaults.standard.setValue(true, forKey: privacyKey)
        isShowingPrivacySheet = false
        shouldNavigateToRecorder = true
    }
    
    private func hasAcceptedPrivacy() -> Bool {
        return UserDefaults.standard.bool(forKey: privacyKey)
    }
}
