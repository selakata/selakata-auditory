import SwiftUI

struct AnswerRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Radio(isOn: isSelected)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.systemGray5))
            )
        }
    }
}

#Preview {
    VStack(spacing: 14) {
        AnswerRow(title: "Sakit", isSelected: true, action: {})
        AnswerRow(title: "Melayat", isSelected: false, action: {})
    }
    .padding()
}
