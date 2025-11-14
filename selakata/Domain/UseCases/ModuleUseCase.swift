//  Created by ais on 30/10/25.

public class ModuleUseCase {
    private let repository: ModuleRepository
    
    public init(repository: ModuleRepository) {
        self.repository = repository
    }
    
    public func fetchModule(completion: @escaping (Result<APIResponse<[Module]>, Error>) -> Void) {
        repository.fetchModule(completion: completion)
    }
}
