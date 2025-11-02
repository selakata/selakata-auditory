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
    
    private let minDBFS: Float = -80
    private let maxDBFS: Float = -6
    
    init(repository: HearingTestRepository) {
        self.repository = repository
    }
    
    func loadResults() {
        self.leftResult = repository.loadResult(for: .left)
        self.rightResult = repository.loadResult(for: .right)
    }
    
    func convertDBFSToPercentage(dbfs: Float) -> Float {
        let clampedDBFS = min(max(dbfs, minDBFS), maxDBFS)
        let hearingRange = abs(minDBFS - maxDBFS)
        let distanceFromWorstHearing = abs(clampedDBFS - maxDBFS)
        
        let percentage = (distanceFromWorstHearing / hearingRange) * 100
        
        return percentage
    }
}
