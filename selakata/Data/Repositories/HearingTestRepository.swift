//
//  HearingTestRepository.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//

import Foundation

class HearingTestRepository: HearingTestRepositoryProtocol {
    private let userDefaults = UserDefaults.standard
    private let thresholdsLeftKey = "hearingTestThresholds_Left"
    private let thresholdsRightKey = "hearingTestThresholds_Right"
    private let snrKey = "hearingTestSNR"
    
    func saveThresholds(for ear: Ear, thresholds: [Double: Float]) {
        let key = (ear == .left) ? thresholdsLeftKey : thresholdsRightKey
        
        let stringKeyedThresholds = Dictionary(uniqueKeysWithValues:
            thresholds.map { (doubleKey, value) in
                (String(doubleKey), value)
            }
        )
        
        userDefaults.setValue(stringKeyedThresholds, forKey: key)
    }
    
    func loadLeftThresholds() -> [Double: Float]? {
        guard let loadedDict = userDefaults.dictionary(forKey: thresholdsLeftKey) as? [String: Float] else {
            return nil
        }
        
        let doubleKeyedThresholds = Dictionary(uniqueKeysWithValues:
            loadedDict.compactMap { (stringKey, value) -> (Double, Float)? in
                guard let doubleKey = Double(stringKey) else {
                    print("Error decoding threshold key: \(stringKey)")
                    return nil
                }
                return (doubleKey, value)
            }
        )
        return doubleKeyedThresholds
    }
    
    func loadRightThresholds() -> [Double: Float]? {
        guard let loadedDict = userDefaults.dictionary(forKey: thresholdsRightKey) as? [String: Float] else {
            return nil
        }
        
        let doubleKeyedThresholds = Dictionary(uniqueKeysWithValues:
            loadedDict.compactMap { (stringKey, value) -> (Double, Float)? in
                guard let doubleKey = Double(stringKey) else {
                    print("Error decoding threshold key: \(stringKey)")
                    return nil
                }
                return (doubleKey, value)
            }
        )
        return doubleKeyedThresholds
    }
    
    func getRepository() -> HearingTestRepositoryProtocol {
        return self
    }
    
    func saveSNR(_ snr: Int) {
        userDefaults.setValue(snr, forKey: snrKey)
    }
    
    func loadSNR() -> Int? {
        guard userDefaults.object(forKey: snrKey) != nil else {
            return nil
        }
        return userDefaults.integer(forKey: snrKey)
    }
}
