//
//  MainView.swift
//  selakata
//
//  Created by ais on 05/11/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel = DependencyContainer.shared.makeModulesViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ModulesView(viewModel: viewModel)
                .tabItem {
                    Label("Modules", systemImage: "ear.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .modelContainer(for: [LocalAudioFile.self, Module.self, Level.self])
    }
}

#Preview {
    MainView()
}
