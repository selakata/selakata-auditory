//
//  AuthRepositoryImpl.swift
//  selakata
//
//  Created by ais on 07/11/25.
//


import Foundation

public class AuthRepositoryImpl: AuthRepository {
    private let dataSource: AuthDataSource
    
    public init(dataSource: AuthDataSource) {
        self.dataSource = dataSource
    }
    
    public func auth(username: String, appleId: String, email: String, name: String, completion: @escaping (Result<APIResponse<AuthData>, Error>) -> Void) {
        dataSource.auth(username: username, appleId: appleId, email: email, name: name, completion: completion)
    }
}
