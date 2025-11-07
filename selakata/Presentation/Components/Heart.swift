import SwiftUI

struct Heart: View {
    let isFilled: Bool

    var body: some View {
        Image(systemName: isFilled ? "heart.fill" : "heart")
            .font(.title3)
            .foregroundStyle(isFilled ? .primary : .secondary)
    }
}

#Preview {
    HStack(spacing: 12) {
        Heart(isFilled: false)
        Heart(isFilled: true)
        Heart(isFilled: true)
    }
}
