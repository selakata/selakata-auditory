import SwiftUI

struct PrimaryButton: View {
    let title: String
    var leftIcon: Image? = nil
    var rightIcon: Image? = nil
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: {
            if !isDisabled {
                action()
            }
        }) {
            HStack(spacing: 8) {
                if let leftIcon = leftIcon {
                    leftIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }

                Text(title)
                    .fontWeight(.semibold)

                if let rightIcon = rightIcon {
                    rightIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(isDisabled ? Color.Primary._400 : Color.Primary._500)
            .cornerRadius(10)
            .animation(.easeInOut(duration: 0.2), value: isDisabled)
        }
        .disabled(isDisabled)
    }
}

#Preview {
    PrimaryButton(title: "Primary Button") {
        
    }
}
