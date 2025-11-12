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
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var didSuccessfullySave: Bool = false

    let repository: HearingTestRepository
    private let submitEarlyTestUseCase: SubmitEarlyTestUseCase
    
    private let minDBFS: Float = -80
    private let maxDBFS: Float = -6
    
    init(repository: HearingTestRepository, submitEarlyTestUseCase: SubmitEarlyTestUseCase) {
        self.repository = repository
        self.submitEarlyTestUseCase = submitEarlyTestUseCase
    }
    
    func loadResults() {
        self.leftThresholds = repository.loadLeftThresholds()
        self.rightThresholds = repository.loadRightThresholds()
        self.snr = repository.loadSNR()
    }
    
    func submitResultsToBackend() {
        print("ViewModel: Attempting to submit results to backend.")
        
        guard let leftThresholds = leftThresholds,
              let rightThresholds = rightThresholds,
              let snr = snr else {
            self.errorMessage = "Cannot submit, results are incomplete."
            print("ViewModel: Submit failed. Data is missing.")
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        submitEarlyTestUseCase.execute(
            leftThresholds: leftThresholds,
            rightThresholds: rightThresholds,
            snr: snr
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success:
                    print("HearingTestResultsViewModel: SUCCESS. Results saved to backend.")
                    self.didSuccessfullySave = true
                    
                case .failure(let error):
                    print("HearingTestResultsViewModel: FAILED to save results. \(error.localizedDescription)")
                    self.errorMessage = "Error saving results: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func calculatePTA(from thresholds: [Double: Float]?) -> Float? {
        return HearingTestCalculator.calculatePTA(from: thresholds)
    }
    
    func convertDBFSToPercentage(dbfs: Float?) -> Float {
        return HearingTestCalculator.convertDBFSToPercentage(dbfs: dbfs)
    }
}
