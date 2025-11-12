//
//  AuthUseCase.swift
//  selakata
//
//  Created by ais on 07/11/25.
//



public class AuthUseCase {
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute(
        username: String,
        appleId: String,
        email: String,
        name: String,
        completion: @escaping (Result<APIResponse<AuthData>, Error>) -> Void
    ) {
        repository.auth(
            username: username,
            appleId: appleId,
            email: email,
            name: name,
            completion: completion
        )
    }
}
