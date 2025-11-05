//
//  ProfileViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 04/11/25.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    
    @Published var hasHearingTestResult = false
    
    let userName = "Learner" // placeholder ajah
    private let repository = HearingTestRepository()

    func checkHearingTestStatus() {
        if repository.loadSNR() != nil {
            hasHearingTestResult = true
        } else {
            hasHearingTestResult = false
        }
    }
}
