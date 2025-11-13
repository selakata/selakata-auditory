//
//  ProgressDataSource.swift
//  selakata
//
//  Created by Anisa Amalia on 12/11/25.
//

import Foundation

public protocol ProgressDataSource {
    func submitEarlyTest(
        data: EarlyTestSubmitRequest,
        completion: @escaping (Result<EmptyResponse, Error>) -> Void
    )
}
