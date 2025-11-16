import SwiftUI
import SwiftData

@main
struct selakataApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @StateObject private var authService = DependencyContainer.shared.makeAuthenticationService()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authService.isAuthenticated && authService.isServerAuthenticated {
                    MainView()
                } else {
                    if hasSeenOnboarding {
                        LoginView()
                    } else {
                        OnboardingView()
                    }
                }
            }
            .environmentObject(authService)
            .preferredColorScheme(.light)
        }
    }
}
