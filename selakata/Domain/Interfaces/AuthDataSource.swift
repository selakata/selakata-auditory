//
//  AuthDataSource.swift
//  selakata
//
//  Created by ais on 07/11/25.
//

import Foundation

public protocol AuthDataSource {
    func auth(username: String, appleId: String, email: String, name: String, completion: @escaping (Result<APIResponse<AuthData>, Error>) -> Void)
}

