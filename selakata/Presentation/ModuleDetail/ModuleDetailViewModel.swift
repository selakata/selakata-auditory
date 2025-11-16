import Foundation
import SwiftUI

@MainActor
class ModuleDetailViewModel: ObservableObject {
    @Published var levels: [LocalLevelData] = []
    
    @Published var level: [Level] = []
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
        levelUseCase.fetchLevel(moduleId: moduleId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let level):
                    self?.level = level.data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadLevels(for module: Module) {
        // Find corresponding Module from QuizData
        let moduleIds = ["identification", "discrimination", "comprehension", "competing_speaker"]
        guard let moduleIndex = moduleIds.firstIndex(of: module.label.lowercased()),
              moduleIndex < QuizData.dummyModule.count else {
            return
        }
        
        let module = QuizData.dummyModule[moduleIndex]
        
        // Convert Level to LevelData
        levels = module.levelList.enumerated().map { index, level in
            let difficulty: LevelDifficulty
            switch level.value {
            case 1:
                difficulty = .easy
            case 2:
                difficulty = .medium
            case 3:
                difficulty = .hard
            default:
                difficulty = .medium
            }
            
            return LocalLevelData(
                id: level.value,
                name: level.label,
                description: "\(level.label) \(module.label.lowercased()) exercises",
                difficulty: difficulty,
                progress: 0.0,
                isUnlocked: level.isActive,
                questionCount: level.question.count,
                moduleId: module.label
            )
        }
    }
    
    func isLevelUnlocked(_ level: LocalLevelData) -> Bool {
        return true // All levels are unlocked
    }
    
    func updateLevelProgress(_ levelId: Int, progress: Double) {
        if let index = levels.firstIndex(where: { $0.id == levelId }) {
            levels[index].progress = progress
            
            // Unlock next level if current is completed
            if progress >= 70.0 {
                let nextLevelId = levelId + 1
                if let nextIndex = levels.firstIndex(where: { $0.id == nextLevelId }) {
                    levels[nextIndex].isUnlocked = true
                }
            }
        }
    }
}

// MARK: - LevelData Model
struct LocalLevelData: Identifiable {
    var id: Int
    var name: String
    let description: String
    let difficulty: LevelDifficulty
    var progress: Double
    var isUnlocked: Bool
    let questionCount: Int
    let moduleId: String
    
    var progressPercentage: String {
        return String(format: "%.0f%%", progress)
    }
    
    var isCompleted: Bool {
        return progress >= 70.0
    }
    
    var difficultyColor: Color {
        switch difficulty {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
}

enum LevelDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}
