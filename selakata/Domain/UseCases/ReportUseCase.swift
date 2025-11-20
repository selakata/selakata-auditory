import Foundation

public class ReportUseCase {
    private let repository: ProgressRepository
    
    public init(repository: ProgressRepository) {
        self.repository = repository
    }
    
    func executeFetchReport(completion: @escaping (Result<ReportData, Error>) -> Void) {
        repository.fetchReport { result in
            switch result {
            case .success(let apiData):
                let finalData = ReportData(
                    wordComp: apiData.wordComprehension != nil ? Int(apiData.wordComprehension!) : nil,
                    sentenceComp: apiData.sentenceComprehension != nil ? Int(apiData.sentenceComprehension!) : nil,
                    speechInNoiseEnv: apiData.speechInNoiseEnvironment != nil ? Int(apiData.speechInNoiseEnvironment!) : nil,
                    speechInNoiseConvo: apiData.speechInNoiseConversation != nil ? Int(apiData.speechInNoiseConversation!) : nil,
                    
                    snrLevel: apiData.snrLevel,
                    
                    repetitionRate: apiData.repetitionRate != nil ? Int(apiData.repetitionRate!) : nil,
                    responseTime: apiData.responseTime
                )
                completion(.success(finalData))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
