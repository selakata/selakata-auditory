//
//  GetProfileDataUseCase.swift
//  selakata
//
//  Created by Anisa Amalia on 07/11/25.
//

import Foundation

class GetProfileDataUseCase {
    private let hearingRepo: HearingTestRepository
    private let profileRepo: ProfileRepository
    
    init(
        hearingRepo: HearingTestRepository,
        profileRepo: ProfileRepository
    ) {
        self.hearingRepo = hearingRepo
        self.profileRepo = profileRepo
    }
    
    func hasCompletedHearingTest() -> Bool {
        return hearingRepo.loadSNR() != nil
    }
    
    func getUserName() -> String {
        return profileRepo.getUserName()
    }
    
    func getHearingTestRepository() -> HearingTestRepository {
        return hearingRepo.getRepository()
    }
}
