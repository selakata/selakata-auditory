//
//  ModuleDataSource.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 20/6/24.
//

import Foundation

public protocol ModuleDataSource {
    func fetchModule(completion: @escaping (Result<APIResponse<[Module]>, Error>) -> Void)
}

