//
//  LevelRepositoryImpl.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

import Foundation

public class LevelRepositoryImpl: LevelRepository {
    private let dataSource: LevelDataSource
    
    public init(dataSource: LevelDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetchLevel(moduleId: String, completion: @escaping (Result<APIResponse<[Level]>, Error>) -> Void) {
        dataSource.fetchLevel (moduleId: moduleId, completion: completion)
    }
    
    public func fetchDetailLevel(levelId: String, completion: @escaping (Result<APIResponse<Level>, Error>) -> Void) {
        dataSource.fetchDetailLevel (levelId: levelId, completion: completion)
    }
    
    public func fetchDetailLevel(levelId: String, voiceId: String?, completion: @escaping (Result<APIResponse<Level>, Error>) -> Void) {
        dataSource.fetchDetailLevel (levelId: levelId, completion: completion)
    }
    
    public func updateLevelScore(levelId: String, score: Int, completion: @escaping (Result<String, Error>) -> Void) {
        dataSource.updateLevelScore(levelId: levelId, score: score, completion: completion)
    }
}

