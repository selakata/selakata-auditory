//
//  ModuleAPIConfiguration.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

import Foundation

public class ModuleAPIConfiguration : BaseAPIConfiguration{
    func makeModuleURL() -> URL? {
        makeURL(path: "/modul")
    }
}

//    private let configuration: ConfigurationProtocol
//
//    init(configuration: ConfigurationProtocol) {
//        self.configuration = configuration
//    }

//    func makeModuleURL() -> URL? {
//        let baseURL = configuration.baseURL
//
//        let components = URLComponents(string: baseURL + "/modul")
//
//        return components?.url
//    }
