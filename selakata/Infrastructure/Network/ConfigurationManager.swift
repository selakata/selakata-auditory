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
        return "sk_994189a535350d078eb3316a1900405e5199003656622f47"
    }
    
    var localSelakataDataFilename: String {
        return "selakatasfile"
    }
}

