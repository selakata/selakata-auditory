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

    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let token = getFromKeychain(for: "token") {
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(
                    .failure(
                        NSError(
                            domain: "",
                            code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey: "No data received"
                            ]
                        )
                    )
                )
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 [APIClient] Response JSON:")
                print(jsonString)
            } else {
                print("⚠️ [APIClient] No readable JSON response.")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(
                    T.self,
                    from: data
                )
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    public func request(
        request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        var mutableRequest = request
        
        if let token = getFromKeychain(for: "token") {
            if mutableRequest.value(forHTTPHeaderField: "Authorization") == nil {
                print("APIClient: Attaching Bearer token to URLRequest")
                mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        } else {
            print("APIClient: No Bearer Token found in Keychain for key 'token'.")
        }
        
        let task = URLSession.shared.dataTask(with: mutableRequest) { //
            data,
            response,
            error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📦 [APIClient] Response Status: \(httpResponse.statusCode)")
            }
            if let jsonString = String(data: data, encoding: .utf8), !jsonString.isEmpty {
                print("📦 [APIClient] Response JSON:")
                print(jsonString)
            } else {
                print("📦 [APIClient] Response: (Empty Body)")
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    func requestWithBody<T: Decodable, U: Encodable>(
        url: URL,
        method: HTTPMethod,
        body: U,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        if let token = getFromKeychain(for: "token") {
             request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
             print("APIClient: No Bearer Token found in Keychain for key 'token'.")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        // Send the request
        let task = session.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }

    private func handleResponse<T: Decodable>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let error = error {
            print("❌ [APIClient] Network Error: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ [APIClient] Error: Not an HTTP response")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ [APIClient] Server Error: Status \(httpResponse.statusCode)")
            if let data = data, let errorString = String(data: data, encoding: .utf8) {
                print("❌ [APIClient] Server Error Body: \(errorString)")
            }
            completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid server response (Code: \(httpResponse.statusCode))"])))
            return
        }
        
        // Handle successful but empty responses
        guard let data = data, !data.isEmpty else {
            print("✅ [APIClient] Success: Empty response (Code: \(httpResponse.statusCode))")
            if let emptySuccess = EmptyResponse() as? T {
                completion(.success(emptySuccess))
            } else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Successful response, but no data received."])
                completion(.failure(error))
            }
            return
        }
        
        // Handle successful responses with data
        do {
            print("✅ [APIClient] Success: Decoding response (Code: \(httpResponse.statusCode))")
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedResponse))
        } catch {
            print("❌ [APIClient] Decoding Error: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("❌ [APIClient] Failed to decode this JSON: \(jsonString)")
            }
            completion(.failure(error))
        }
    }


    func uploadFile<T: Decodable>(
        url: URL,
        fileURL: URL,
        voiceName: String,
        apiKey: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        // -- Add 'name' field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(voiceName)\r\n".data(using: .utf8)!)
        
        // -- Add 'labels' field
        let labels = "{\"language\":\"id\"}"
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"labels\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(labels)\r\n".data(using: .utf8)!)
        
        // -- Add 'files' field
        do {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
            body.append(try Data(contentsOf: fileURL))
            body.append("\r\n".data(using: .utf8)!)
        } catch {
            completion(.failure(error))
            return
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        

        let task = session.uploadTask(with: request, from: body) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
}
