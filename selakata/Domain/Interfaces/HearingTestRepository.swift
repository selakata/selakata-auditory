//
//  HearingTestRepository.swift
//  selakata
//
//  Created by Anisa Amalia on 07/11/25.
//

import Foundation

protocol HearingTestRepository {
    func loadSNR() -> Int?
    func loadLeftThresholds() -> [Double: Float]?
    func loadRightThresholds() -> [Double: Float]?
    func getRepository() -> HearingTestRepository
    func saveSNR(_ snr: Int)
    func saveThresholds(for ear: Ear, thresholds: [Double: Float])
}
