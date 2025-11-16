//
//  VoiceAPIConfiguration.swift
//  selakata
//
//  Created by Anisa Amalia on 11/11/25.
//

import Foundation

public class VoiceAPIConfiguration: BaseAPIConfiguration {
    func makeTeamAddVoiceURL() -> URL? {
        return makeURL(path: "/voice/add")
    }
    
    func makeGetVoicesRequest() -> URL? {
        return makeURL(path: "/voice")
    }
}
