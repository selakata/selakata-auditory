//
//  WeatherAPIConfiguration.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

import Foundation

public class ModuleAPIConfiguration {
    private let configuration: ConfigurationProtocol
    
    init(configuration: ConfigurationProtocol) {
        self.configuration = configuration
    }
    
    func makeModuleURL() -> URL? {
        let baseURL = configuration.baseURL
        
        var components = URLComponents(string: baseURL)
        
        return components?.url
    }
}


