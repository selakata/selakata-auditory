//
//  AuthRepository.swift
//  selakata
//
//  Created by ais on 07/11/25.
//

public protocol AuthRepository {
    func auth(username: String, appleId: String, email: String, name: String, completion: @escaping (Result<APIResponse<AuthData>, Error>) -> Void)
}
