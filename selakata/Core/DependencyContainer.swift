import Foundation
import SwiftData

/// Centralized dependency injection container for the app
@MainActor
class DependencyContainer {
    static let shared = DependencyContainer()
    var modelContext: ModelContext?
    
    // MARK: - Shared Infrastructure
    private lazy var apiClient: APIClientProtocol = {
        APIClient()
    }()
    
    private lazy var appConfiguration: ConfigurationProtocol = {
        AppConfiguration()
    }()
    
    // MARK: - Shared Repositories
    private lazy var progressRepository: ProgressRepository = {
        let apiConfiguration = ProgressAPIConfiguration(configuration: appConfiguration)
        let dataSource: ProgressDataSource = RemoteProgressDataSource(
            apiClient: apiClient,
            apiConfiguration: apiConfiguration
        )
        return ProgressRepositoryImpl(dataSource: dataSource)
    }()
    
    // MARK: - Module Dependencies
    lazy var moduleUseCase: ModuleUseCase = {
        let apiConfiguration = ModuleAPIConfiguration(configuration: appConfiguration)
        let dataSource: ModuleDataSource = RemoteModuleDataSource(
            apiClient: apiClient,
            apiConfiguration: apiConfiguration
        )
        let repository = ModuleRepositoryImpl(dataSource: dataSource)
        return ModuleUseCase(repository: repository)
    }()
    
    // MARK: - Level Dependencies
    lazy var levelUseCase: LevelUseCase = {
        let apiConfiguration = LevelAPIConfiguration(configuration: appConfiguration)
        let dataSource: LevelDataSource = RemoteLevelDataSource(
            apiClient: apiClient,
            apiConfiguration: apiConfiguration
        )
        let repository = LevelRepositoryImpl(dataSource: dataSource)
        return LevelUseCase(repository: repository)
    }()
    
    // MARK: - Auth Dependencies
    lazy var authUseCase: AuthUseCase = {
        let apiConfiguration = AuthAPIConfiguration(configuration: appConfiguration)
        let dataSource: AuthDataSource = RemoteAuthDataSource(
            apiClient: apiClient,
            apiConfiguration: apiConfiguration
        )
        let repository = AuthRepositoryImpl(dataSource: dataSource)
        return AuthUseCase(repository: repository)
    }()
    
    // MARK: - Hearing Test Dependencies
    lazy var hearingTestRepository: HearingTestRepository = {
        HearingTestRepositoryImpl()
    }()
        
    lazy var submitEarlyTestUseCase: SubmitEarlyTestUseCase = {
        return SubmitEarlyTestUseCase(repository: progressRepository)
    }()
    
    lazy var reportUseCase: ReportUseCase = {
        return ReportUseCase(repository: progressRepository)
    }()
    
    
    // MARK: - Personal Voice Dependencies
    lazy var recorderService: AudioRecorderService = {
        AudioRecorderService()
    }()
    
    lazy var playerService: AudioPlayerService = {
        AudioPlayerService()
    }()
    
    lazy var personalVoiceRepository: PersonalVoiceRepository = {
        PersonalVoiceRepositoryImpl()
    }()
    
    lazy var voiceConfig: VoiceAPIConfiguration = {
        VoiceAPIConfiguration(configuration: appConfiguration)
    }()
    
    lazy var elevenLabsConfig: ElevenLabsAPIConfiguration = {
        ElevenLabsAPIConfiguration(configuration: appConfiguration)
    }()

    lazy var personalVoiceUseCase: PersonalVoiceUseCase = {
        return PersonalVoiceUseCase(
            recorder: recorderService,
            player: playerService,
            repository: personalVoiceRepository,
            apiClient: apiClient,
            voiceConfig: voiceConfig,
            elevenLabsConfig: elevenLabsConfig
        )
    }()
    
    lazy var getProfileDataUseCase: GetProfileDataUseCase = {
        GetProfileDataUseCase(
            hearingRepo: hearingTestRepository
        )
    }()
    
    // MARK: - Factory Methods for ViewModels
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(
            moduleUseCase: moduleUseCase
        )
    }
    
    func makeModulesViewModel() -> ModulesViewModel {
        return ModulesViewModel(moduleUseCase: moduleUseCase)
    }
    
    func makeModuleDetailViewModel(moduleId: String) -> ModuleDetailViewModel {
        return ModuleDetailViewModel(levelUseCase: levelUseCase, moduleId: moduleId)
    }
    
    func makeQuizViewModel(levelId: String) -> QuizViewModel {
        return QuizViewModel(levelUseCase: levelUseCase, levelId: levelId)
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(
            getProfileDataUseCase: getProfileDataUseCase,
            hearingTestRepository: hearingTestRepository
        )
    }
    
    func makePersonalVoiceViewModel() -> PersonalVoiceViewModel {
        return PersonalVoiceViewModel()
    }
    
    func makeAuthenticationService() -> AuthenticationService {
        return AuthenticationService(authUseCase: authUseCase)
    }
    
    func makeReportViewModel() -> ReportViewModel {
        return ReportViewModel(reportUseCase: reportUseCase)
    }
    
    private init() {}
}
