//
//  WeatherRepository.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

import SwiftUI

public protocol ModuleRepository {
    func fetchModule(completion: @escaping (Result<ModuleAPI, Error>) -> Void)
}
