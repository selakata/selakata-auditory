//
//  FetchModuleUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

public class FetchModuleUseCase {
    private let repository: ModuleRepository
    
    public init(repository: ModuleRepository) {
        self.repository = repository
    }
    
    public func execute(completion: @escaping (Result<ModuleResponse, Error>) -> Void) {
        repository.fetchModule(completion: completion)
    }
}
