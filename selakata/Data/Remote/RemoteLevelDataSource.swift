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
    
    public func fetchLevel(moduleId: String, completion: @escaping (Result<APIResponse<[Level]>, Error>) -> Void) {
        guard let url = apiConfiguration.makeLevelsURL(moduleId: moduleId) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        apiClient.request(url: url, method: .get, completion: completion)
    }
    
    public func fetchDetailLevel(levelId: String, voiceId: String?, completion: @escaping (Result<APIResponse<Level>, Error>) -> Void) {
        guard let url = apiConfiguration.makeDetailLevelURL(levelId: levelId, voiceId: voiceId) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        apiClient.request(url: url, method: .get, completion: completion)
    }
    
    
    public func updateLevelScore(updateLevel: UpdateLevel, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = apiConfiguration.makeUpdateLevelScore(updateLevel: updateLevel) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        apiClient.request(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(String.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


