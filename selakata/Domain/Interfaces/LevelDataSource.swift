//
//  LevelDataSource.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 20/6/24.
//

import Foundation

public protocol LevelDataSource {
    func fetchLevel(moduleId: String, completion: @escaping (Result<APIResponse<[Level]>, Error>) -> Void)
    func fetchDetailLevel(levelId: String, voiceId: String?, completion: @escaping (Result<APIResponse<Level>, Error>) -> Void)
    func updateLevelScore(levelId: String, score: Int, repetition: Int, responseTime: Double, completion: @escaping (Result<String, Error>) -> Void)
}

