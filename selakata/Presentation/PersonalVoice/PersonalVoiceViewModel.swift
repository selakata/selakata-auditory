//
//  PersonalVoiceViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import Foundation

@MainActor
class PersonalVoiceViewModel: ObservableObject {
    
    @Published var isShowingPrivacySheet = false
    @Published var shouldNavigateToRecorder = false
    
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
