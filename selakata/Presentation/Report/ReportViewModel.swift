import Foundation
import Combine

struct ReportData {
    var wordComp: Int? = nil
    var sentenceComp: Int? = nil
    var speechInNoiseEnv: Int? = nil
    var speechInNoiseConvo: Int? = nil
    
    var snrLevel: Double? = nil
    var repetitionRate: Int? = nil
    var responseTime: Double? = nil
}

@MainActor
class ReportViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var reportData: ReportData = ReportData()
    @Published var errorMessage: String? = nil
    
    private let reportUseCase: ReportUseCase
    
    init(reportUseCase: ReportUseCase) {
        self.reportUseCase = reportUseCase
        fetchReportData()
    }
    
    func fetchReportData() {
        self.isLoading = true
        self.errorMessage = nil
        
        reportUseCase.executeFetchReport { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let data):
                    self.reportData = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.reportData = ReportData()
                }
            }
        }
    }
    
    func exportToPDF() {
        print("Export to PDF")
    }
}
