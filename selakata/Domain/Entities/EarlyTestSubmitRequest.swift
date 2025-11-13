//
//  EarlyTestSubmitRequest.swift
//  selakata
//
//  Created by Anisa Amalia on 12/11/25.
//

import Foundation

public struct EarlyTestSubmitRequest: Encodable {
    let left: EarThresholds
    let right: EarThresholds
    let snrBaseline: Int
}

public struct EarThresholds: Encodable {
    let value500: Int
    let value1000: Int
    let value2000: Int
    let value4000: Int
    
    enum CodingKeys: String, CodingKey {
        case value500
        case value1000
        case value2000
        case value4000
    }
}
