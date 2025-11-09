//
//  HearingTestRepositoryProtocol.swift
//  selakata
//
//  Created by Anisa Amalia on 07/11/25.
//

import Foundation

protocol HearingTestRepositoryProtocol {
    func loadSNR() -> Int?
    func loadLeftThresholds() -> [Double: Float]?
    func loadRightThresholds() -> [Double: Float]?
    
    func getRepository() -> HearingTestRepositoryProtocol
}
