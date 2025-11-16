import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = DependencyContainer.shared.makeHomeViewModel()
    
    @AppStorage("selectedVoiceID") private var selectedVoiceID: String?
    @Query private var allLocalVoices: [LocalAudioFile]
    
    @EnvironmentObject var authService: AuthenticationService
    
    init() {
        _viewModel = StateObject(wrappedValue: DependencyContainer.shared.makeHomeViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    greeting
                    
                    personalizedVoiceCard
                    
                    yourJourneyCard
                    
                    yourProgressCard
                    
                }
                .padding(.bottom, 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .background(Color.clear)
            .onAppear {
                viewModel.loadData(
                    localVoices: allLocalVoices,
                    selectedVoiceID: selectedVoiceID
                )
            }
            .onChange(of: allLocalVoices) {
                viewModel.updateVoiceState(localVoices: allLocalVoices, selectedVoiceID: selectedVoiceID)
            }
            .onChange(of: selectedVoiceID) {
                viewModel.updateVoiceState(localVoices: allLocalVoices, selectedVoiceID: selectedVoiceID)
            }
        }
    }
    
    private var greeting: some View {
        (
            Text("Good to see you,\n")
                .font(.body)
            
            + Text("\(authService.userFullName ?? "Learner")!")
                .font(.headline)
                .fontWeight(.semibold)
        )
        .lineSpacing(4)
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    private var personalizedVoiceCard: some View {
        NavigationLink(destination: PersonalVoiceListView()) {
            PersonalizedVoiceCard(state: viewModel.voiceState)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 24)
    }
    
    private var yourJourneyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your journey")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            YourJourneyCard(
                state: viewModel.journeyState,
                onRetry: {
                    viewModel.fetchModules()
                }
            )
        }
        .padding(.horizontal, 24)
    }
    
    private var yourProgressCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your progress")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                NavigationLink(destination: { Text("Report") }, label: {
                    Text("View all")
                        .font(.footnote)
                        .foregroundStyle(.accent)
                })
            }
            
            ProgressCardView(stats: viewModel.progressStats, isLoading: {
                if case .loading = viewModel.journeyState { return true }
                return false
            }())
        }
        .padding(.horizontal, 24)
    }
}


#Preview {
    HomeView()
}
