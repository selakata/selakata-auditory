//
//  AuthAPIConfiguration.swift
//  selakata
//
//  Created by ais on 07/11/25.
//

import Foundation

public class AuthAPIConfiguration : BaseAPIConfiguration{
    func makeLoginRequestBody(_ username: String, _ appleId: String, _ email: String, _ name: String) -> Data? {
        let body: [String: Any] = [
            "username" : username,
            "appleId" : appleId,
            "email" : email,
            "name" : name,
        ]
        return try? JSONSerialization.data(withJSONObject: body)
    }
    
    func makeLoginURLRequest(_ username: String, _ appleId: String, _ email: String, _ name: String) -> URLRequest? {
        guard let url = URL(string: configuration.baseURL + "/auth/login-user") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = makeLoginRequestBody(username, appleId, email, name)
        
        return request
    }
}
