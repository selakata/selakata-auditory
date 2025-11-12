//
//  ModuleRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

public protocol ModuleRepository {
    func fetchModule(completion: @escaping (Result<APIResponse<[Module]>, Error>) -> Void)
}
