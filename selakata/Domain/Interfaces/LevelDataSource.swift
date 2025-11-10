//
//  LevelDataSource.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 20/6/24.
//

import Foundation

public protocol LevelDataSource {
    func fetchLevel(moduleId: String, completion: @escaping (Result<LevelResponse, Error>) -> Void)
}

