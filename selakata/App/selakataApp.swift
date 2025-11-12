import SwiftUI
import SwiftData

@main
struct selakataApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                LoginView()
            } else {
                OnboardingView()
            }
        }
    }
}
