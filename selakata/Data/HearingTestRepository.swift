//
//  HearingTestRepository.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//

import Foundation

class HearingTestRepository {
    private let userDefaults = UserDefaults.standard
    private let ptaLeftKey = "hearingTestPTA_Left"
    private let ptaRightKey = "hearingTestPTA_Right"
    private let snrKey = "hearingTestSNR"
    
    func savePTA(for ear: Ear, pta: Float) {
            let key = (ear == .left) ? ptaLeftKey : ptaRightKey
            userDefaults.setValue(pta, forKey: key)
        }
    
    func loadLeftPTA() -> Float? {
        guard userDefaults.object(forKey: ptaLeftKey) != nil else {
            return nil
        }
        return userDefaults.float(forKey: ptaLeftKey)
    }
    
    func loadRightPTA() -> Float? {
        guard userDefaults.object(forKey: ptaRightKey) != nil else {
            return nil
        }
        return userDefaults.float(forKey: ptaRightKey)
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
