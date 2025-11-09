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
    
    init() {
        let hearingRepo = HearingTestRepositoryImpl()
        let profileRepo = AuthenticationService()
        
        self.getProfileDataUseCase = GetProfileDataUseCase(
            hearingRepo: hearingRepo,
            profileRepo: profileRepo
        )
        
        self.hearingTestRepository = hearingRepo
    }
    
    func onAppear() {
        self.userName = getProfileDataUseCase.getUserName()
        self.hasHearingTestResult = getProfileDataUseCase.hasCompletedHearingTest()
    }
}
