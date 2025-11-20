//
//  RemoteProgressDataSource.swift
//  selakata
//
//  Created by Anisa Amalia on 12/11/25.
//

import Foundation

public class RemoteProgressDataSource: ProgressDataSource {
    private let apiClient: APIClientProtocol
    private let apiConfiguration: ProgressAPIConfiguration

    public init(apiClient: APIClientProtocol, apiConfiguration: ProgressAPIConfiguration) {
        self.apiClient = apiClient
        self.apiConfiguration = apiConfiguration
    }

    public func submitEarlyTest(
        data: EarlyTestSubmitRequest,
        completion: @escaping (Result<EmptyResponse, Error>) -> Void
    ) {
        guard let request = apiConfiguration.makeSubmitEarlyTestRequest(data: data) else {
            completion(.failure(
                NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Request"])
            ))
            return
        }
        
        print("RemoteProgressDataSource: Sending submitEarlyTest request...")
        
        apiClient.request(request: request) { result in
            switch result {
            case .success(_):
                print("RemoteProgressDataSource: Submit success.")
                completion(.success(EmptyResponse()))
                
            case .failure(let error):
                print("RemoteProgressDataSource: Submit failed. \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    public func fetchReport(completion: @escaping (Result<ReportAPIResponse, Error>) -> Void) {
        guard let request = apiConfiguration.makeGetReportRequest() else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Request URL"])))
            return
        }
        
        apiClient.request(request: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(ReportAPIResponse.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    print("RemoteProgressDataSource: Decoding error: \(error)")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
