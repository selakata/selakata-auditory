//
//  ProgressAPIConfiguration.swift
//  selakata
//
//  Created by Anisa Amalia on 12/11/25.
//

import Foundation

public class ProgressAPIConfiguration: BaseAPIConfiguration {
    func makeSubmitEarlyTestRequest(
        data: EarlyTestSubmitRequest
    ) -> URLRequest? {
        guard let url = URL(string: configuration.baseURL + "/user/submit-early-test") else {
            print("Error: Invalid URL for submit early test")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(data)
        } catch {
            print("Error encoding EarlyTestSubmitRequest: \(error)")
            return nil
        }
        
        return request
    }
    
    func makeGetReportRequest() -> URLRequest? {
        guard let url = makeURL(path: "/user/report") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}
