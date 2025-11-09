//
//  APIClient.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

import Foundation

class APIClient: APIClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(url: URL, method: HTTPMethod, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            // 👇 Tambahkan debug log di sini
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [APIClient] Response JSON:")
                print(jsonString)
            } else {
                print("⚠️ [APIClient] No readable JSON response.")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func request(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [APIClient] Response JSON:")
                print(jsonString)
            } else {
                print("⚠️ [APIClient] No readable JSON response.")
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}


