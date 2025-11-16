import SwiftUI

struct SingleOnBoardingView: View {
    let action: () -> Void
    let isLoading: Bool
    let errorMessage: String?
    
    var body: some View {
        VStack {
            Chip(text: "Non-clinical based",
                 leftIcon: Image("icon-warning"))
            .padding(.top, 40)
            
            Spacer()
            
            VStack(spacing: 24) {
                
                Text("Start your journey today with your own voice")
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundColor(.gray.opacity(0.7))
                    .padding(.horizontal, 40)
                
            }
            .frame(height: 320)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 24)
            }
            
            UtilsButton(
                title: "Continue with Apple",
                leftIcon: Image("icon-apple"),
                isLoading: isLoading,
                variant: .primary,
                action: action
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    SingleOnBoardingView(action: {}, isLoading: false, errorMessage: "Sign In Failed")
}
