//
//  LevelAPIConfiguration.swift
//  ExampleMVVM
//
//  Created by MacBook Air M1 on 19/6/24.
//

import Foundation

public class LevelAPIConfiguration: BaseAPIConfiguration {
    func makeLevelsURL(moduleId: String) -> URL? {
        makeURL(path: "/pub/level/\(moduleId)")
    }

    func makeDetailLevelURL(levelId: String) -> URL? {
        //makeURL(path: "/pub/level/detail/\(levelId)")
        makeURL(path: "/pub/level/detail/\(levelId)?voiceId=IYwvlItxjjy3CTdsk1fR")
    }
    
    func makeDetailLevelURL(levelId: String, voiceId: String) -> URL? {
        makeURL(path: "/pub/level/detail/\(levelId)?voiceId=\(voiceId)")
    }

    func makeUpdateLevelScoreBody(_ levelId: String, _ score: Int) -> Data? {
        let body: [String: Any] = [
            "levelId": levelId,
            "score": score,
        ]
        return try? JSONSerialization.data(withJSONObject: body)
    }

    func makeUpdateLevelScore(levelId: String, score: Int) -> URLRequest? {
        guard let url = URL(string: configuration.baseURL + "/user/update-level")
        else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = makeUpdateLevelScoreBody(levelId, score)

        return request
    }
}
