//  Created by Anisa Amalia on 07/11/25.

import Foundation

class GetProfileDataUseCase {
    private let hearingRepo: HearingTestRepository
    
    init(
        hearingRepo: HearingTestRepository
    ) {
        self.hearingRepo = hearingRepo
    }
    
    func hasCompletedHearingTest() -> Bool {
        return hearingRepo.loadSNR() != nil
    }
    
    func getHearingTestRepository() -> HearingTestRepository {
        return hearingRepo.getRepository()
    }
}
