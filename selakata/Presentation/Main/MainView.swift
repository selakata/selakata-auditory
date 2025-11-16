//  Created by ais on 05/11/25.

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var mainVM = MainViewModel()
    @StateObject private var viewModel = DependencyContainer.shared.makeModulesViewModel()
    
    var body: some View {
        ZStack {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                ModulesView(viewModel: viewModel)
                    .tabItem {
                        Label("Journey", systemImage: "flag")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
            .environmentObject(mainVM)
            
            if mainVM.isModalVisible {
                Modal(
                    image: mainVM.modalData.image ?? Image("mascot"),
                    title: mainVM.modalData.title,
                    description: mainVM.modalData.description,
                    ctaText: mainVM.modalData.ctaText,
                    onCtaTap: {
                        mainVM.hideModal()
                    }
                )
                .transition(.opacity)
                .zIndex(10)
            }
        }
        .modelContainer(for: [LocalAudioFile.self, LocalModule.self, LocalLevel.self])
    }
}

#Preview {
    MainView()
}
