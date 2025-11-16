import Foundation
import SwiftUI
import Combine
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    enum VoiceCardState: Equatable {
        case loading
        case noVoice
        case voiceSelected(name: String)
        case voiceOff
    }
    
    enum JourneyCardState: Equatable {
        static func == (lhs: HomeViewModel.JourneyCardState, rhs: HomeViewModel.JourneyCardState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.newUser(let a), .newUser(let b)):
                return a.id == b.id
            case (.inProgress(let a), .inProgress(let b)):
                return a.id == b.id
            case (.error(let a), .error(let b)):
                return a == b
            case (.noModules, .noModules):
                return true
            default:
                return false
            }
        }
        
        case loading
        case newUser(firstModule: Module)
        case inProgress(module: Module)
        case error(message: String)
        case noModules
    }
    
    struct ProgressStats: Equatable {
        var wordComp: Int? = nil
        var sentenceComp: Int? = nil
        var speechInNoise: Int? = nil
        var environment: Int? = nil
    }
    
    @Published var userName: String = "User"
    @Published var voiceState: VoiceCardState = .loading
    @Published var journeyState: JourneyCardState = .loading
    @Published var progressStats: ProgressStats = .init()

    private let authService: AuthenticationService
    private let moduleUseCase: ModuleUseCase
    
    private var cancellables = Set<AnyCancellable>()

    
    init(authService: AuthenticationService, moduleUseCase: ModuleUseCase) {
        self.authService = authService
        self.moduleUseCase = moduleUseCase
        
        updateUserName()
    }
    
    func loadData(localVoices: [LocalAudioFile], selectedVoiceID: String?) {
        updateUserName()
        updateVoiceState(localVoices: localVoices, selectedVoiceID: selectedVoiceID)
        fetchModules()
        loadProgressData()
    }
    
    func updateVoiceState(localVoices: [LocalAudioFile], selectedVoiceID: String?) {
        let hasVoices = !localVoices.isEmpty
        
        if let selectedID = selectedVoiceID, hasVoices {
            let voiceName = localVoices.first(where: { $0.voiceId == selectedID })?.voiceName ?? "Selected Voice"
            self.voiceState = .voiceSelected(name: voiceName)
        } else if hasVoices {
            self.voiceState = .voiceOff
        } else {
            self.voiceState = .noVoice
        }
    }
    
    private func updateUserName() {
        self.userName = authService.getUserFullName()
    }

    func fetchModules() {
        self.journeyState = .loading
        
        moduleUseCase.fetchModule { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    self.processJourneyState(from: response.data)
                case .failure(let error):
                    self.journeyState = .error(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func processJourneyState(from modules: [Module]) {
        let sortedModules = modules.sorted(by: { $0.value < $1.value })
        let inProgressModule = sortedModules.first { $0.isUnlocked && $0.percentage < 1.0 }
        
        if let module = inProgressModule {
            self.journeyState = .inProgress(module: module)
        } else if let firstModule = sortedModules.first {
            let allCompleted = sortedModules.allSatisfy { $0.percentage >= 1.0 }
            if allCompleted {
                self.journeyState = .inProgress(module: sortedModules.last!)
            } else {
                self.journeyState = .newUser(firstModule: firstModule)
            }
        } else {
            self.journeyState = .noModules
        }
    }
    
    private func loadProgressData() {
        self.progressStats = .init()
    }
}
