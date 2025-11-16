//  Created by Anisa Amalia on 18/10/25.

import Foundation

@MainActor
class ModulesViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let moduleUseCase: ModuleUseCase
    @Published var modules: [Module]?
    
    init(moduleUseCase: ModuleUseCase) {
        self.moduleUseCase = moduleUseCase
        fetchModule()
    }
    
    public func fetchModule() {
        isLoading = true
        errorMessage = nil
        
        moduleUseCase.fetchModule { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let modulResponse):
                    self?.modules = modulResponse.data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    public func refreshModules() {
        fetchModule()
    }
    
    func getQuestionCategory(for module: Module) -> QuestionCategory {
        switch module.label {
        case "Identification":
            return .identification
        case "Discrimination":
            return .discrimination
        case "Comprehension":
            return .comprehension
        case "Competing Speaker":
            return .identification  // Using identification for now
        default:
            return .identification
        }
    }
}
