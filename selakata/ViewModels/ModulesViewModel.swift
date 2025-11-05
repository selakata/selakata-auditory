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
        // Convert Module from QuizData to Module for UI compatibility
        _ = [
            "ear.fill", "waveform.path.ecg", "brain.head.profile",
            "person.2.wave.2",
        ]
        _ = [
            "identification", "discrimination", "comprehension",
            "competing_speaker",
        ]

        modules = QuizData.dummyModule
    }

    func isModuleUnlocked(_ module: Module) -> Bool {
        return true  // All modules are unlocked
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

    //    func completeQuiz(for category: QuestionCategory, score: Int, totalQuestions: Int) {
    //        let percentage = Double(score) / Double(totalQuestions) * 100.0
    //
    //        // Find module by category
    //        if let moduleIndex = modules.firstIndex(where: { getQuestionCategory(for: $0) == category }) {
    //            let currentProgress = modules[moduleIndex].progress
    //            let Progress = max(currentProgress, percentage)
    //
    //            updateModuleProgress(modules[moduleIndex].id, progress: Progress)
    //        }
    //    }

    // Legacy support for SwiftData Module
    func isModuleUnlocked(_ module: Module, in allModules: [Module]) -> Bool {
        if module.orderIndex == 0 {
            return true
        }

        if let previousModule = allModules.first(where: {
            $0.orderIndex == module.orderIndex - 1
        }) {
            return previousModule.progress >= 1.0
        }

        return false
    }
}
