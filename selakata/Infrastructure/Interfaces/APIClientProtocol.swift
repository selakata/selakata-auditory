//
//  APIClientProtocol.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 20/6/24.
//

import Foundation

public protocol APIClientProtocol {
    func request<T: Decodable>(url: URL, method: HTTPMethod, completion: @escaping (Result<T, Error>) -> Void)
    func request(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
    
    func requestWithBody<T: Decodable, U: Encodable>(
        url: URL,
        method: HTTPMethod,
        body: U,
        completion: @escaping (Result<T, Error>) -> Void
    )
    
    func uploadFile<T: Decodable>(
        url: URL,
        fileURL: URL,
        voiceName: String,
        apiKey: String,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

public struct EmptyResponse: Decodable {}
