import Foundation

public protocol ProgressRepository {
    func submitEarlyTest(
        data: EarlyTestSubmitRequest,
        completion: @escaping (Result<EmptyResponse, Error>) -> Void
    )
    func fetchReport(completion: @escaping (Result<ReportAPIData, Error>) -> Void)
}
