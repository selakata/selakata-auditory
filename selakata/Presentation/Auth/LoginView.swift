//  Created by ais on 05/11/25.

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = DependencyContainer.shared.makeLoginViewModel()
    
    var body: some View {
        SingleOnBoardingView(action: viewModel.signInWithApple,
                             isLoading: viewModel.isLoading,
                             errorMessage: viewModel.errorMessage)
        .padding(36)
        .background(Color(.systemBackground))
        
        // MARK: - Loading Overlay
        .overlay(
            Group {
                if viewModel.isLoading {
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
            isPresented: .constant(viewModel.errorMessage != nil)
        ) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    LoginView()
}
