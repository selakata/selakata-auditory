import SwiftUI
import Combine

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @State private var currentPage = 0
    @State private var hasReachedLastPage = false
    @State private var timerCancellable: Cancellable?
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Imagine train with a voice that feels familiar, comforting, and truly yours",
            imageName: "photo"
        ),
        OnboardingPage(
            title: "With SelaKata’s Personalized Voice, you can make it happen!",
            imageName: "photo"
        ),
        OnboardingPage(
            title: "Start your journey today with your own voice.",
            imageName: "photo"
        )
    ]
    
    private let timer = Timer.publish(every: 2, on: .main, in: .common)
    
    var body: some View {
        VStack {
            Chip(text: "Non-clinical based",
                 leftIcon: Image("icon-warning"))
            .padding(.top, 40)
            
            Spacer()
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 24) {
                        
                        Text(pages[index].title)
                            .font(.title3.bold())
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                        
                        Image(systemName: pages[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray.opacity(0.7))
                            .padding(.horizontal, 40)
                        
                    }
                    .tag(index)
                }
            }
            .frame(height: 320)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear {
                timerCancellable = timer.autoconnect().sink { _ in
                    guard currentPage < pages.count - 1 else {
                        stopTimer()
                        return
                    }
                    withAnimation {
                        currentPage += 1
                    }
                }
            }
            .onChange(of: currentPage) { _, newValue in
                    if newValue == pages.count - 1 {
                        hasReachedLastPage = true
                        stopTimer()
                    }
                }
            
            PageIndicator(total: pages.count, current: currentPage)
                .padding(.top, 24)
            
            Spacer()
            
            PrimaryButton(
                title: "Continue with Apple",
                leftIcon: Image("icon-apple"),
                isDisabled: !hasReachedLastPage
            ) {
                hasSeenOnboarding = true
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .animation(.easeInOut, value: currentPage)
    }
    
    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}

struct OnboardingPage {
    let title: String
    let imageName: String
}

#Preview {
    OnboardingView()
}
