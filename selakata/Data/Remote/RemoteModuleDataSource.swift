//
//  RemoteModelDataSource.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 20/6/24.
//

import Foundation

public class RemoteModuleDataSource: ModuleDataSource {
    private let apiClient: APIClientProtocol
    private let apiConfiguration: ModuleAPIConfiguration
    
    public init(apiClient: APIClientProtocol, apiConfiguration: ModuleAPIConfiguration) {
        self.apiClient = apiClient
        self.apiConfiguration = apiConfiguration
    }
    
    public func fetchModule(completion: @escaping (Result<ModuleResponse, Error>) -> Void) {
        guard let url = apiConfiguration.makeModuleURL() else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        apiClient.request(url: url, method: .get, completion: completion)
    }
}


