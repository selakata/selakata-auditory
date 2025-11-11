//
//  DependencyContainer.swift
//  selakata
//
//  Created by Kiro on 11/11/25.
//

import Foundation

/// Centralized dependency injection container for the app
@MainActor
class DependencyContainer {
    static let shared = DependencyContainer()
    
    // MARK: - Shared Infrastructure
    private lazy var apiClient: APIClientProtocol = {
        APIClient()
    }()
    
    private lazy var appConfiguration: ConfigurationProtocol = {
        AppConfiguration()
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
    
    // MARK: - Personal Voice Dependencies
    lazy var personalVoiceUseCase: PersonalVoiceUseCase = {
        let repository = PersonalVoiceRepositoryImpl()
        return PersonalVoiceUseCase(repository: repository)
    }()
    
    // MARK: - Profile Dependencies
    lazy var authenticationService: AuthenticationService = {
        AuthenticationService()
    }()
    
    lazy var getProfileDataUseCase: GetProfileDataUseCase = {
        GetProfileDataUseCase(
            hearingRepo: hearingTestRepository,
            profileRepo: authenticationService
        )
    }()
    
    // MARK: - Factory Methods for ViewModels
    func makeModulesViewModel() -> ModulesViewModel {
        return ModulesViewModel(moduleUseCase: moduleUseCase)
    }
    
    func makeModuleDetailViewModel(moduleId: String) -> ModuleDetailViewModel {
        return ModuleDetailViewModel(levelUseCase: levelUseCase, moduleId: moduleId)
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authUseCase: authUseCase)
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(
            getProfileDataUseCase: getProfileDataUseCase,
            hearingTestRepository: hearingTestRepository
        )
    }
    
    func makePersonalVoiceViewModel() -> PersonalVoiceViewModel {
        return PersonalVoiceViewModel(useCase: personalVoiceUseCase)
    }
    
    private init() {}
}
