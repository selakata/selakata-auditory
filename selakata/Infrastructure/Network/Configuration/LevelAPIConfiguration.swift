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

    func makeUpdateLevelScoreBody(
        _ levelId: String,
        _ score: Int,
        _ repetition: Int,
        _ responseTime: Double
    ) -> Data? {
        let body: [String: Any] = [
            "levelId": levelId,
            "score": score,
        ]
        return try? JSONSerialization.data(withJSONObject: body)
    }

    func makeUpdateLevelScore(
        levelId: String,
        score: Int,
        repetition: Int,
        responseTime: Double
    ) -> URLRequest? {
        guard
            let url = URL(string: configuration.baseURL + "/user/update-level")
        else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = makeUpdateLevelScoreBody(
            levelId,
            score,
            repetition,
            responseTime
        )

        return request
    }
}
