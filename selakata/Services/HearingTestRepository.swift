//
//  HearingTestRepository.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//

import Foundation

struct HearingTestResult: Codable {
    var thresholds: [Double: Float]
    var pta: Float
    var snr: Float
}

class HearingTestRepository {
    private let userDefaults = UserDefaults.standard
    private let leftEarKey = "hearingTestResult_Left"
    private let rightEarKey = "hearingTestResult_Right"
    
    func saveResult(for ear: Ear, result: HearingTestResult) {
        let key = (ear == .left) ? leftEarKey : rightEarKey
        do {
            let data = try JSONEncoder().encode(result)
            userDefaults.setValue(data, forKey: key)
        } catch {
            print("HearingTestRepository: Failed to encode and save result: \(error)")
        }
    }
    
    func loadResult(for ear: Ear) -> HearingTestResult? {
        let key = (ear == .left) ? leftEarKey : rightEarKey
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            let result = try JSONDecoder().decode(HearingTestResult.self, from: data)
            return result
        } catch {
            print("HearingTestRepository: Failed to decode result: \(error)")
            return nil
        }
    }
}
