//
//  HearingTestCalculator.swift
//  selakata
//
//  Created by Anisa Amalia on 03/11/25.
//

import Foundation

struct HearingTestCalculator {

    private static let minDBFS: Float = -80
    private static let maxDBFS: Float = -6
    
    static func calculatePTA(from thresholds: [Double: Float]?) -> Float? {
        guard let thresholds = thresholds else { return nil }
        
        let pta500 = thresholds[500] ?? 0
        let pta1000 = thresholds[1000] ?? 0
        let pta2000 = thresholds[2000] ?? 0
        let pta4000 = thresholds[4000] ?? 0
        
        let pta = (pta500 + pta1000 + pta2000 + pta4000) / 4.0
        return pta
    }
    
    static func convertDBFSToPercentage(dbfs: Float?) -> Float {
        guard let dbfs = dbfs else { return 0 }
        
        let clampedDBFS = min(max(dbfs, minDBFS), maxDBFS)
        let hearingRange = abs(minDBFS - maxDBFS)
        let distanceFromWorst = abs(clampedDBFS - maxDBFS)
        
        let percentage = (distanceFromWorst / hearingRange) * 100
        return percentage
    }
}
