//
//  LevelModuleUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

public class ModuleUseCase {
    private let repository: ModuleRepository
    
    public init(repository: ModuleRepository) {
        self.repository = repository
    }
    
    public func fetchModule(completion: @escaping (Result<APIResponse<[Module]>, Error>) -> Void) {
        repository.fetchModule(completion: completion)
    }
}
