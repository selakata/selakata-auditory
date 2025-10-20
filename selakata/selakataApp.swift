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
            .modelContainer(for: Module.self) { result in
                switch result {
                case .success(let container):
                    initiateModules(context: container.mainContext)
                case .failure(let error):
                    fatalError("Failed to create model container: \(error.localizedDescription)")
                }
            }
        }
    }

    @MainActor
    func initiateModules(context: ModelContext) {
        let descriptor = FetchDescriptor<Module>()
        guard (try? context.fetchCount(descriptor)) == 0 else { return }

        let modules = [
            Module(id: "identification", name: "Identification", details: "Learn to identify and recognize key sounds.", progress: 0.0, image: "photo.fill", orderIndex: 0),
            Module(id: "discrimination", name: "Discrimination", details: "Differentiate between similar sounds and patterns.", progress: 0.0, image: "photo.fill", orderIndex: 1),
            Module(id: "comprehension", name: "Comprehension", details: "Understand the meaning and context of what you hear.", progress: 0.0, image: "photo.fill", orderIndex: 2),
            Module(id: "competing_speaker", name: "Competing Speaker", details: "Focus on one voice in a noisy environment.", progress: 0.0, image: "photo.fill", orderIndex: 3)
        ]

        modules.forEach { module in
            context.insert(module)
        }
    }
}
