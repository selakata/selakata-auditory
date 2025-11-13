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
                    Text("Exercise")
                        .font(.largeTitle.weight(.bold))
                        .padding([.horizontal, .top])

                    if let response = viewModel.module {
                        if response.isEmpty {
                            // Jika data kosong
                            Text("Tidak ada modul yang tersedia.")
                                .foregroundColor(.secondary)
                                .padding()
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
                        ProgressView("Memuat modul...")
                            .padding()
                    } else if let errorMessage = viewModel.errorMessage {
                        VStack(spacing: 8) {
                            Text("Gagal memuat modul.")
                                .font(.headline)
                            Text(errorMessage)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Button("Coba Lagi") {
                                viewModel.fetchModule()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    } else {
                        // State awal (misalnya belum mulai load)
                        Text("Tidak ada data modul.")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
            }
            .navigationTitle("Journey")
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
