//  Created by ais on 07/11/25.

public protocol AuthRepository {
    func auth(username: String, appleId: String, email: String, name: String, completion: @escaping (Result<APIResponse<AuthData>, Error>) -> Void)
    
    func getMe(
         completion: @escaping (Result<APIResponse<User>, Error>) -> Void
     )
}
