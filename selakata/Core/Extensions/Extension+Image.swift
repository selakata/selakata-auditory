import SwiftUI

extension Image {
    init(safe name: String, default defaultName: String) {
        if UIImage(named: name) != nil {
            self.init(name)
        } else {
            self.init(defaultName)
        }
    }
}
