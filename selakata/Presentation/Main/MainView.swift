//
//  MainView.swift
//  selakata
//
//  Created by ais on 05/11/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel: ModulesViewModel
    
    init() {
        let apiClient = APIClient()
        let appConfiguration = AppConfiguration()
        let apiConfiguration = ModuleAPIConfiguration(configuration: appConfiguration)
        let dataSource: ModuleDataSource = RemoteModuleDataSource(apiClient: apiClient, apiConfiguration: apiConfiguration)
        let repository = ModuleRepositoryImpl(dataSource: dataSource)
        let moduleUseCase = ModuleUseCase(repository: repository)
        
        // Buat ViewModel sekali di init
        _viewModel = StateObject(wrappedValue: ModulesViewModel(moduleUseCase: moduleUseCase))
    }
    
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
        .modelContainer(for: [AudioFile.self, Module.self, Level.self])
    }
}

#Preview {
    MainView()
}
