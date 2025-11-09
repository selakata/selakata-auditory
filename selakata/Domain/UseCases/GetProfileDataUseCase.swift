//
//  GetProfileDataUseCase.swift
//  selakata
//
//  Created by Anisa Amalia on 07/11/25.
//

import Foundation

class GetProfileDataUseCase {
    private let hearingRepo: HearingTestRepositoryProtocol
    private let profileRepo: ProfileRepositoryProtocol
    
    init(
        hearingRepo: HearingTestRepositoryProtocol,
        profileRepo: ProfileRepositoryProtocol
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
    
    func getHearingTestRepository() -> HearingTestRepositoryProtocol {
        return hearingRepo.getRepository()
    }
}
