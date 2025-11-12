//
//  LevelRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

public protocol LevelRepository {
    func fetchLevel(moduleId: String, completion: @escaping (Result<APIResponse<[Level]>, Error>) -> Void)
    func fetchDetailLevel(levelId: String, completion: @escaping (Result<APIResponse<Level>, Error>) -> Void)
    func updateLevelScore(levelId: String, score: Int, completion: @escaping (Result<String, Error>) -> Void)
}
