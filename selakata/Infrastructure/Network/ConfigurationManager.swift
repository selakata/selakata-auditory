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
        return "sk_66796f5ffc287f74e18ada77e4fc524ef2b32aa476ec7140"
    }
    
    var localSelakataDataFilename: String {
        return "selakatasfile"
    }
}

