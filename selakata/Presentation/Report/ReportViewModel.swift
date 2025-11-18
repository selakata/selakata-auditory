import Foundation
import Combine

struct ReportData {
    var wordComp: Int? = nil
    var sentenceComp: Int? = nil
    var speechInNoiseEnv: Int? = nil
    var speechInNoiseConvo: Int? = nil
    
    var snrLevel: Int? = nil
    var repetitionRate: Int? = nil
    var responseTime: Double? = nil
}

@MainActor
class ReportViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var reportData: ReportData = ReportData()
    
    init() {
        loadPlaceholderData()
    }
    
    func loadPlaceholderData() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.reportData = ReportData()
            self.isLoading = false
 
            // self.reportData = ReportData(
            //     wordComp: 50,
            //     sentenceComp: 50,
            //     speechInNoiseEnv: 50,
            //     speechInNoiseConvo: 50,
            //     snrLevel: 5,
            //     repetitionRate: 50,
            //     responseTime: 2.5
            // )
            // self.isLoading = false
        }
    }
    
    func fetchReportData() {
        self.isLoading = true
    }
    
    func exportToPDF() {
        print("Export to PDF")
    }
}
