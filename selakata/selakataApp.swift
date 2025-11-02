//
//  selakataApp.swift
//  selakata
//
//  Created by Fachry Anwar on 13/10/25.
//

import SwiftUI
import SwiftData

@main
struct selakataApp: App {
    var body: some Scene {
        WindowGroup {
//            DialogueView()
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                ModulesView()
                    .tabItem {
                        Label("Modules", systemImage: "ear.fill")
                    }

                Text("Profile Page")
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
        }
    }
}
