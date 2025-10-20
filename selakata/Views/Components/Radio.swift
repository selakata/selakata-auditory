import SwiftUI

struct Radio: View {
    let isOn: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray3), lineWidth: 2)
                .frame(width: 26, height: 26)
            if isOn {
                Circle()
                    .fill(Color(.systemIndigo))
                    .frame(width: 14, height: 14)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isOn)
    }
}

#Preview {
    HStack(spacing: 20) {
        Radio(isOn: false)
        Radio(isOn: true)
    }
}
