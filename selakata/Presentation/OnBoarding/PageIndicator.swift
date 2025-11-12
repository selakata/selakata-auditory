import SwiftUI

struct PageIndicator: View {
    var total: Int
    var current: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color.Primary._500 : Color.gray.opacity(0.2))
                    .frame(width: index == current ? 60 : 25, height: 8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: current)
            }
        }
    }
}

#Preview {
    PageIndicator(total: 3, current: 0)
}
