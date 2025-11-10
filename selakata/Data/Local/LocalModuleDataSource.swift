//
//  LocalModuleDataSource.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 20/6/24.
//

import Foundation

//public class LocalModuleDataSource: ModuleDataSource {
//    private let jsonLoader: JSONLoaderProtocol
//    private let configuration: ConfigurationProtocol
//    
//    public init(jsonLoader: JSONLoaderProtocol, configuration: ConfigurationProtocol) {
//        self.jsonLoader = jsonLoader
//        self.configuration = configuration
//    }
//    
//    public func fetchModule(completion: @escaping (Result<ModuleAPI, Error>) -> Void) {
//        let filename = configuration.localSelakataDataFilename
//        if let data = jsonLoader.loadJSON(filename: filename) {
//            do {
//                let forecast = try JSONDecoder().decode(ModuleAPI.self, from: data)
//                print(forecast)
//                completion(.success(forecast))
//            } catch {
//                completion(.failure(error))
//            }
//        } else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load local data"])))
//        }
//    }
//}



