//
//  ModulesView.swift
//  selakata
//
//  Created by Anisa Amalia on 18/10/25.
//

import SwiftData
import SwiftUI

struct ModulesView: View {
    @StateObject private var viewModel = ModulesViewModel()

    @Query(sort: \Module.orderIndex) private var allModules: [Module]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Exercise")
                        .font(.largeTitle.weight(.bold))
                        .padding([.horizontal, .top])

                    ForEach(allModules) { module in
                        let isUnlocked = true
                        
                        // Coba konversi nama module ke QuestionCategory
                        if let category = QuestionCategory(rawValue: module.id) {
//                            NavigationLink(
//                                destination: QuizView(questionCategory: category)
//                            ) {
//                                ModuleCard(module: module, showProgressBar: false)
//                                    .overlay(isUnlocked ? nil : LockOverlay())
//                            }
//                            .buttonStyle(.plain)
//                            .disabled(!isUnlocked)
                        } else {
                            // Kalau name tidak cocok dengan enum, bisa tampilkan placeholder / error handler
                            Text("Invalid category for module: \(module.name)")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationTitle("Exercise")
            .navigationBarHidden(true)
        }
    }
}

struct LockOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)

            Image(systemName: "lock.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
        .cornerRadius(20)
    }
}
