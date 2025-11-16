//  Created by ais on 05/11/25.

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthenticationService
    
    var body: some View {
        SingleOnBoardingView(action: authService.signInWithApple,
                             isLoading: authService.isLoading,
                             errorMessage: authService.errorMessage)
        .padding(36)
        .background(Color(.systemBackground))
        
        // MARK: - Loading Overlay
        .overlay(
            Group {
                if authService.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: .white)
                        )
                        .scaleEffect(1.2)
                }
            }
        )
        
        // MARK: - Alert Handling
        .alert(
            "Authentication Error",
            isPresented: .constant(authService.errorMessage != nil)
        ) {
            Button("OK") {
                authService.errorMessage = nil
            }
        } message: {
            if let errorMessage = authService.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    LoginView()
}
