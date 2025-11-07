//
//  FetchWeatherUseCase.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

import SwiftUI

public class FetchModuleUseCase {
    private let repository: ModuleRepository
    
    public init(repository: ModuleRepository) {
        self.repository = repository
    }
    
    public func execute(city: String, completion: @escaping (Result<ModuleAPI, Error>) -> Void) {
        repository.fetchModule(completion: completion)
    }
}
