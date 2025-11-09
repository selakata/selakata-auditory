//
//  MainView.swift
//  selakata
//
//  Created by ais on 05/11/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ModulesView()
                .tabItem {
                    Label("Modules", systemImage: "ear.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
