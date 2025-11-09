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
        self.useCase = PersonalVoiceUseCase(
            repository: repository
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
