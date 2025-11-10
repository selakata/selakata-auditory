//
//  LevelRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

public protocol LevelRepository {
    func fetchLevel(completion: @escaping (Result<LevelResponse, Error>) -> Void)
}
