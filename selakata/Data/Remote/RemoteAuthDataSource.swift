//
//  RemoteAuthDataSource.swift
//  selakata
//
//  Created by ais on 07/11/25.
//

import Foundation

public class RemoteAuthDataSource: AuthDataSource {
    private let apiClient: APIClientProtocol
    private let apiConfiguration: AuthAPIConfiguration
    
    public init(apiClient: APIClientProtocol, apiConfiguration: AuthAPIConfiguration) {
        self.apiClient = apiClient
        self.apiConfiguration = apiConfiguration
    }
    
    public func auth(
        username: String,
        appleId: String,
        email: String,
        name: String,
        completion: @escaping (Result<AuthResponse, Error>) -> Void
    ) {
        guard let request = apiConfiguration.makeLoginURLRequest(username, appleId, email, name) else {
            completion(.failure(
                NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Request"])
            ))
            return
        }
        
        apiClient.request(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(AuthResponse.self, from: data)
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
