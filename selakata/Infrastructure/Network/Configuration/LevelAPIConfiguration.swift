import Foundation

public class LevelAPIConfiguration: BaseAPIConfiguration {
    func makeLevelsURL(moduleId: String) -> URL? {
        makeURL(path: "/pub/level/\(moduleId)")
    }

    func makeDetailLevelURL(levelId: String, voiceId: String?) -> URL? {
        var path = "/pub/level/detail/\(levelId)"
        if let voiceId = voiceId {
            path += "?voiceId=\(voiceId)"
        }
        return makeURL(path: path)
    }
    
    func makeUpdateLevelScoreBody(updateLevel body: UpdateLevel) -> Data? {
        let questionsArray: [[String: Any]] = body.questions.map { question in
            return [
                "questionId": question.questionId,
                "isCorrect": question.isCorrect
            ]
        }
        
        let bodyDict: [String: Any] = [
            "levelId": body.levelId,
            "score": body.score,
            "repetition": body.repetition,
            "responseTime": body.responseTime,
            "questions": questionsArray
        ]
        
        return try? JSONSerialization.data(withJSONObject: bodyDict)
    }

//    func makeUpdateLevelScore(
//        updateLevel body: UpdateLevel
//    ) -> URLRequest? {
//        guard
//            let url = URL(string: configuration.baseURL + "/user/update-level")
//        else {
//            return nil
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = makeUpdateLevelScoreBody(
//            updateLevel: body
//        )
//
//        return request
//    }
    
    func makeUpdateLevelScore(
        updateLevel body: UpdateLevel
    ) -> URLRequest? {
        guard
            let url = URL(string: configuration.baseURL + "/user/update-level")
        else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Generate http body
        let jsonData = makeUpdateLevelScoreBody(updateLevel: body)
        request.httpBody = jsonData
        
        // 🔥 Log JSON body yang dikirim
        if let jsonData = jsonData,
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("📤 Sending JSON Body:")
            print(jsonString)
        } else {
            print("❌ Failed to encode JSON body")
        }
        
        return request
    }

}
