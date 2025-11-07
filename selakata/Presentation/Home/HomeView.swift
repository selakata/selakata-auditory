//
//  HomeView.swift
//  selakata
//
//  Created by Anisa Amalia on 18/10/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isStartingTest = false
    
    @Query(sort: \Module.orderIndex) private var allModules: [Module]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // buat mascot, sekarang placeholder pake icon aja ya
                    Image(systemName: "progress.indicator")
                        .font(.system(size: 150))
                        .foregroundStyle(.purple)
                        .padding(.top)

                    ReminderCard()
                        .padding(.horizontal, 24)
                    
                    progressCardSection
                    
                    Button(action: {
                        isStartingTest = true
                    }) {
                        HearingTestCard()
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 24)
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $isStartingTest) {
                HearingTestOnboardingView(isStartingTest: $isStartingTest)
            }
        }
        .onChange(of: allModules) {
            viewModel.processModules(allModules)
        }
        .onAppear {
            viewModel.processModules(allModules)
        }
    }
    
    private var progressCardSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let moduleToDisplay = viewModel.mostRecentModule ?? viewModel.firstAvailableModule {
                Text(moduleToDisplay.progress == 0.0 ? "Start your journey" : "Continue exercise")
                    .font(.headline)
                    .padding(.horizontal, 24)

                NavigationLink(destination: Text("Question Page")) {
                    ModuleCard(module: moduleToDisplay, showProgressBar: true)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
            } else {
                Text("Module not found")
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(20)
            }
        }
    }
}


#Preview {
    HomeView()
}
