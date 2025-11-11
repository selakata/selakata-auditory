//
//  ProfileViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 07/11/25.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var hasHearingTestResult = false
    
    private let getProfileDataUseCase: GetProfileDataUseCase
    let hearingTestRepository: HearingTestRepository
    
    init(getProfileDataUseCase: GetProfileDataUseCase, hearingTestRepository: HearingTestRepository) {
        self.getProfileDataUseCase = getProfileDataUseCase
        self.hearingTestRepository = hearingTestRepository
    }
    
    func onAppear() {
        self.userName = getProfileDataUseCase.getUserFullName()
        self.hasHearingTestResult = getProfileDataUseCase.hasCompletedHearingTest()
    }
}
