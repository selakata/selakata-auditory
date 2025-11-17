import Foundation
import SwiftUI

@MainActor
class ModuleDetailViewModel: ObservableObject {
    @Published var levels: [Level] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let levelUseCase: LevelUseCase
    private let moduleId: String
    
    init(levelUseCase: LevelUseCase, moduleId: String) {
        self.levelUseCase = levelUseCase
        self.moduleId = moduleId
        fetchLevels()
    }
    
    func fetchLevels() {
        self.isLoading = true
        
        levelUseCase.fetchLevel(moduleId: moduleId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let level):
                    self?.levels = level.data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
