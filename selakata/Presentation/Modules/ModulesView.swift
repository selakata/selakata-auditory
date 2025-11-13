//  Created by Anisa Amalia on 18/10/25.

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
                    if let response = viewModel.module {
                        if response.isEmpty {
                            ErrorStateView(
                                title: "Tidak ada modul yang tersedia"
                            )
                        } else {
                            ForEach(response.indices, id: \.self) { index in
                                NavigationLink(
                                    destination: ModuleDetailView(module: response[index])
                                ) {
                                    ModuleCard(module: response[index], showProgressBar: true)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 24)
                        }
                    } else if viewModel.isLoading {
                        VStack(spacing: 20) {
                            ForEach(0..<4, id: \.self) { _ in
                                SkeletonView(height: 135, cornerRadius: 20)
                            }
                        }
                        .padding()
                    } else if let errorMessage = viewModel.errorMessage {
                        ErrorStateView(
                            title: "Gagal memuat modul",
                            description: errorMessage,
                            ctaText: "Coba Lagi",
                            onCtaTap: {
                                viewModel.fetchModule()
                            }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .padding(.top, 20)
            .navigationTitle("Journey")
        }
    }
}

#Preview {
    ModulesView(viewModel: DependencyContainer.shared.makeModulesViewModel())
}
