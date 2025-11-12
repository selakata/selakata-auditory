//
//  LevelUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

public class LevelUseCase {
    private let repository: LevelRepository
    
    public init(repository: LevelRepository) {
        self.repository = repository
    }
    
    public func fetchLevel(moduleId: String, completion: @escaping (Result<APIResponse<[Level]>, Error>) -> Void) {
        repository.fetchLevel(moduleId: moduleId, completion: completion)
    }
    
    public func fetchDetailLevel(levelId: String, completion: @escaping (Result<APIResponse<Question>, Error>) -> Void) {
        repository.fetchDetailLevel(levelId: levelId, completion: completion)
    }
}
