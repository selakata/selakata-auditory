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
    
    public func fetchDetailLevel(levelId: String, voiceId: String?, completion: @escaping (Result<APIResponse<Level>, Error>) -> Void) {
        if voiceId == nil {
            repository.fetchDetailLevel(levelId: levelId, completion: completion)
        }else {
            repository.fetchDetailLevel(levelId: levelId, voiceId: voiceId, completion: completion)
        }
        
    }
    
    public func updateLevelScore(levelId: String, score: Int, completion: @escaping (Result<String, Error>) -> Void) {
        repository.updateLevelScore(levelId: levelId, score: score, completion: completion)
    }
}
