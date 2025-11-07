//
//  WeatherRepositoryImpl.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

import Foundation

public class ModuleRepositoryImpl: ModuleRepository {
    private let dataSource: ModuleDataSource
    
    public init(dataSource: ModuleDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetchModule(completion: @escaping (Result<ModuleAPI, Error>) -> Void) {
        dataSource.fetchModule (completion: completion)
    }
}

