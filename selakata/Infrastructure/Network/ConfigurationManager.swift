//
//  AppConfiguration.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 20/6/24.
//

import Foundation

class AppConfiguration: ConfigurationProtocol {
    
    var baseURL: String {
        return "http://35.240.145.248:8080/api"
    }
    
    var apiKey: String {
        return "" 
    }
    
    var localSelakataDataFilename: String {
        return "selakatasfile"
    }
}

