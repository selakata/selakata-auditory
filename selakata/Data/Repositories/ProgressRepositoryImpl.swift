//
//  ProgressRepositoryImpl.swift
//  selakata
//
//  Created by Anisa Amalia on 12/11/25.
//

import Foundation

public class ProgressRepositoryImpl: ProgressRepository {
    private let dataSource: ProgressDataSource

    public init(dataSource: ProgressDataSource) {
        self.dataSource = dataSource
    }

    public func submitEarlyTest(
        data: EarlyTestSubmitRequest,
        completion: @escaping (Result<EmptyResponse, Error>) -> Void
    ) {
        dataSource.submitEarlyTest(data: data, completion: completion)
    }
    
    public func fetchReport(completion: @escaping (Result<ReportAPIData, Error>) -> Void) {
        dataSource.fetchReport { result in
            switch result {
            case .success(let apiResponse):
                completion(.success(apiResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
