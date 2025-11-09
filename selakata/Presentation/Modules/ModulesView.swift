//
//  ModulesView.swift
//  selakata
//
//  Created by Anisa Amalia on 18/10/25.
//

import SwiftData
import SwiftUI

struct ModulesView: View {
    @StateObject private var viewModel: ModulesViewModel
    
    init(viewModel: ModulesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Exercise")
                        .font(.largeTitle.weight(.bold))
                        .padding([.horizontal, .top])

                    ForEach(viewModel.moduleResponse!.data.indices, id: \.self) { index in
                        NavigationLink(
                            destination: ModuleDetailView(module: QuizData.dummyModule[index])
                        ) {
                            ModuleCard(module: viewModel.moduleResponse!.data[index], showProgressBar: true)
                        }
                        .buttonStyle(.plain)
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
