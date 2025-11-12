//
//  AppConfiguration.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 20/6/24.
//

import Foundation

class AppConfiguration: ConfigurationProtocol {
    
    var baseURL: String {
        return "https://api.selakata.com/api"
    }
    
    var apiKey: String {
        return "sk_65378202ef708d558682431fad159a6f5b4f943e744d777c"
    }
    
    var localSelakataDataFilename: String {
        return "selakatasfile"
    }
}

