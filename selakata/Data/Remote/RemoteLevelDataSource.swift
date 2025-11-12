//
//  RemoteLevelDataSource.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 20/6/24.
//

import Foundation

public class RemoteLevelDataSource: LevelDataSource {
    private let apiClient: APIClientProtocol
    private let apiConfiguration: LevelAPIConfiguration
    
    public init(apiClient: APIClientProtocol, apiConfiguration: LevelAPIConfiguration) {
        self.apiClient = apiClient
        self.apiConfiguration = apiConfiguration
    }
    
    public func fetchLevel(moduleId: String, completion: @escaping (Result<LevelResponse, Error>) -> Void) {
        guard let url = apiConfiguration.makeLevelsURL(moduleId: moduleId) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        apiClient.request(url: url, method: .get, completion: completion)
    }
    
    public func fetchDetailLevel(levelId: String, completion: @escaping (Result<LevelDetailResponse, Error>) -> Void) {
        guard let url = apiConfiguration.makeDetailLevelURL(levelId: levelId) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        apiClient.request(url: url, method: .get, completion: completion)
    }
}


