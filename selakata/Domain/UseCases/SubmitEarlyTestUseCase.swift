//
//  SubmitEarlyTestUseCase.swift
//  selakata
//
//  Created by Anisa Amalia on 12/11/25.
//

import Foundation

public class SubmitEarlyTestUseCase {
    private let repository: ProgressRepository

    public init(repository: ProgressRepository) {
        self.repository = repository
    }

    public func execute(
        leftThresholds: [Double: Float],
        rightThresholds: [Double: Float],
        snr: Int,
        completion: @escaping (Result<EmptyResponse, Error>) -> Void
    ) {
        func getThreshold(_ value: Float?) -> Int {
            let floatValue = value ?? 0.0
            let positiveValue = abs(floatValue)
            let roundedValue = positiveValue.rounded()
            return Int(roundedValue)
        }

        let leftData = EarThresholds(
            value500: getThreshold(leftThresholds[500.0]),
            value1000: getThreshold(leftThresholds[1000.0]),
            value2000: getThreshold(leftThresholds[2000.0]),
            value4000: getThreshold(leftThresholds[4000.0])
        )
        
        let rightData = EarThresholds(
            value500: getThreshold(rightThresholds[500.0]),
            value1000: getThreshold(rightThresholds[1000.0]),
            value2000: getThreshold(rightThresholds[2000.0]),
            value4000: getThreshold(rightThresholds[4000.0])
        )
        
        let requestData = EarlyTestSubmitRequest(
            left: leftData,
            right: rightData,
            snrBaseline: snr
        )
        
        repository.submitEarlyTest(data: requestData, completion: completion)
    }
}
