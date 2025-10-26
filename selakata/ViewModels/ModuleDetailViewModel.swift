import Foundation
import SwiftUI

@MainActor
class ModuleDetailViewModel: ObservableObject {
    @Published var levels: [LevelData] = []
    
    func loadLevels(for module: Module) {
        // Create 3 levels for each module
        levels = [
            LevelData(
                id: 1,
                name: "Level 1",
                description: "Basic \(module.name.lowercased()) exercises",
                difficulty: .easy,
                progress: 0.0,
                isUnlocked: true,
                questionCount: 5,
                moduleId: module.id,
            ),
            LevelData(
                id: 2,
                name: "Level 2", 
                description: "Intermediate \(module.name.lowercased()) challenges",
                difficulty: .medium,
                progress: 0.0,
                isUnlocked: true,
                questionCount: 5,
                moduleId: module.id
            ),
            LevelData(
                id: 3,
                name: "Level 3",
                description: "Advanced \(module.name.lowercased()) mastery",
                difficulty: .hard,
                progress: 0.0,
                isUnlocked: true,
                questionCount: 5,
                moduleId: module.id
            )
        ]
    }
    
    func isLevelUnlocked(_ level: LevelData) -> Bool {
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
struct LevelData: Identifiable {
    let id: Int
    let name: String
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
