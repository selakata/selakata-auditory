//
//  LevelAPIConfiguration.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

import Foundation

public class LevelAPIConfiguration : BaseAPIConfiguration{
    func makeLevelsURL(moduleId: String) -> URL? {
        makeURL(path: "/pub/level/\(moduleId)")
    }
    
    func makeLevelDetailURL(levelId: String) -> URL? {
        makeURL(path: "/pub/level/detail/\(levelId)")
    }
}
