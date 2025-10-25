//
//  ModulesViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 18/10/25.
//

import Foundation

@MainActor
class ModulesViewModel: ObservableObject {
    @Published var modules: [Module] = []
    
    init() {
        loadModules()
    }
    
    private func loadModules() {
        modules = [
            Module(
                id: "identification",
                name: "Identification",
                details: "Learn to identify and recognize key sounds and speech patterns.",
                progress: 0.0,
                image: "ear.fill",
                orderIndex: 0
            ),
            Module(
                id: "discrimination",
                name: "Discrimination", 
                details: "Differentiate between similar sounds and speech patterns.",
                progress: 0.0,
                image: "waveform.path.ecg",
                orderIndex: 1
            ),
            Module(
                id: "comprehension",
                name: "Comprehension",
                details: "Understand the meaning and context of what you hear.",
                progress: 0.0,
                image: "brain.head.profile",
                orderIndex: 2
            ),
            Module(
                id: "competing_speaker",
                name: "Competing Speaker",
                details: "Focus on one voice in a noisy environment with multiple speakers.",
                progress: 0.0,
                image: "person.2.wave.2",
                orderIndex: 3
            )
        ]
    }
    
    func isModuleUnlocked(_ module: Module) -> Bool {
        return true // All modules are unlocked
    }
    
//    func updateModuleProgress(_ moduleId: String, progress: Double) {
//        if let index = modules.firstIndex(where: { $0.id == moduleId }) {
//            modules[index].progress = progress
//            
//            // Unlock next module if current is completed
//            if progress >= 70.0 {
//                let nextIndex = modules[index].orderIndex + 1
//                if let nextModuleIndex = modules.firstIndex(where: { $0.orderIndex == nextIndex }) {
//                    modules[nextModuleIndex].isUnlocked = true
//                }
//            }
//        }
//    }
    
    func getQuestionCategory(for module: Module) -> QuestionCategory {
        switch module.id {
        case "identification":
            return .identification
        case "discrimination":
            return .discrimination
        case "comprehension":
            return .comprehension
        case "competing_speaker":
            return .identification // Using identification for now
        default:
            return .identification
        }
    }
    
//    func completeQuiz(for category: QuestionCategory, score: Int, totalQuestions: Int) {
//        let percentage = Double(score) / Double(totalQuestions) * 100.0
//        
//        // Find module by category
//        if let moduleIndex = modules.firstIndex(where: { getQuestionCategory(for: $0) == category }) {
//            let currentProgress = modules[moduleIndex].progress
//            let newProgress = max(currentProgress, percentage)
//            
//            updateModuleProgress(modules[moduleIndex].id, progress: newProgress)
//        }
//    }
    
    // Legacy support for SwiftData Module
    func isModuleUnlocked(_ module: Module, in allModules: [Module]) -> Bool {
        if module.orderIndex == 0 {
            return true
        }

        if let previousModule = allModules.first(where: { $0.orderIndex == module.orderIndex - 1 }) {
            return previousModule.progress >= 1.0
        }

        return false
    }
}
