//
//  HearingTestResultsViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//

import Foundation

@MainActor
class HearingTestResultsViewModel: ObservableObject {
    @Published var leftResult: HearingTestResult?
    @Published var rightResult: HearingTestResult?
    
    private let repository: HearingTestRepository
    
    init(repository: HearingTestRepository) {
        self.repository = repository
    }
    
    func loadResults() {
        self.leftResult = repository.loadResult(for: .left)
        self.rightResult = repository.loadResult(for: .right)
    }
    
    func getHearingLossDescription(for pta: Float) -> String {
        switch pta {
        case ..<(-60):
            return "Normal"
        case ..<(-40):
            return "Mild loss"
        case ..<(-25):
            return "Moderate loss"
        case ..<(-10):
            return "Severe loss"
        default:
            return "Profound Loss"
        }
    }
}
