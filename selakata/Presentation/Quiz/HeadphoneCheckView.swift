import SwiftUI

struct HeadphoneCheckView: View {
    @StateObject private var monitor = HeadphoneMonitor()
    let levelId: String
    @State private var navigateToQuiz = false

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            if monitor.isConnected {
                Image(systemName: "headphones")
                    .font(.system(size: 200))
                    .foregroundStyle(Color(hex: 0xEEEBFF))
                
                Text("Headphones connected")
                    .font(.title2.weight(.semibold))
                    .padding(.bottom, 10)
                
                Text("Headphones are required to get the best training experience.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
            } else {
                Image(systemName: "headphones.slash")
                    .font(.system(size: 200))
                    .foregroundStyle(Color(hex: 0xEEEBFF))
                
                Text("Connect your headphones")
                    .font(.title2.weight(.semibold))
                    .padding(.bottom, 10)
                
                Text("Headphones are required to get the best training experience.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
        }
        .padding(40)
        .navigationDestination(isPresented: $navigateToQuiz) {
            QuizView(levelId: levelId)
        }
        .onAppear {
            if monitor.isConnected {
                proceedToQuiz()
            }
        }
        .onChange(of: monitor.isConnected) { _, isConnected in
            if isConnected {
                proceedToQuiz()
            }
        }
        .onDisappear {
            monitor.stopMonitoring()
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func proceedToQuiz() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.navigateToQuiz = true
        }
    }
}

#Preview("Connected") {
    HeadphoneCheckView(levelId: "1")
}
