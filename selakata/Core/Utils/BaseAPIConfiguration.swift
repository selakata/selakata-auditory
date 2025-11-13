//  Created by ais on 07/11/25.

import Foundation

public class BaseAPIConfiguration {
    let configuration: ConfigurationProtocol
    
    init(configuration: ConfigurationProtocol) {
        self.configuration = configuration
    }
    
    func makeURL(path: String) -> URL? {
        return URL(string: configuration.baseURL + path)
    }
}
