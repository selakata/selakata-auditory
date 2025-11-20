import Foundation

public protocol ProgressDataSource {
    func submitEarlyTest(
        data: EarlyTestSubmitRequest,
        completion: @escaping (Result<EmptyResponse, Error>) -> Void
    )
    func fetchReport(completion: @escaping (Result<ReportAPIResponse, Error>) -> Void)
}
