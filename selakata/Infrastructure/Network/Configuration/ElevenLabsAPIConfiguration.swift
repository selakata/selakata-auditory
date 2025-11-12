//
//  ElevenLabsAPIConfiguration.swift
//  selakata
//
//  Created by Anisa Amalia on 11/11/25.
//

import Foundation

public class ElevenLabsAPIConfiguration {
    private let configuration: ConfigurationProtocol
    
    init(configuration: ConfigurationProtocol) {
        self.configuration = configuration
    }
    
    func makeElevenLabsAddVoiceURL() -> URL? {
        return URL(string: "https://api.elevenlabs.io/v1/voices/add")
    }
    
    func getAPIKey() -> String {
        return configuration.apiKey
    }
}
