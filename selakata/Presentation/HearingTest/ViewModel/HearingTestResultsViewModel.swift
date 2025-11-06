//
//  HearingTestResultsViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//

import Foundation

@MainActor
class HearingTestResultsViewModel: ObservableObject {
    @Published var leftThresholds: [Double: Float]?
    @Published var rightThresholds: [Double: Float]?
    @Published var snr: Int?
    
    let repository: HearingTestRepository
    
    private let minDBFS: Float = -80
    private let maxDBFS: Float = -6
    
    init(repository: HearingTestRepository) {
        self.repository = repository
    }
    
    func loadResults() {
        self.leftThresholds = repository.loadLeftThresholds()
        self.rightThresholds = repository.loadRightThresholds()
        self.snr = repository.loadSNR()
    }
    
    func calculatePTA(from thresholds: [Double: Float]?) -> Float? {
        return HearingTestCalculator.calculatePTA(from: thresholds)
    }
    
    func convertDBFSToPercentage(dbfs: Float?) -> Float {
        return HearingTestCalculator.convertDBFSToPercentage(dbfs: dbfs)
    }
}
