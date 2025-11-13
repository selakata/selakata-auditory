import SwiftUI

struct UtilsButton: View {
    enum Variant {
        case primary
        case secondary
        case danger

        var backgroundColor: Color {
            switch self {
            case .primary: return Color.Primary._500
            case .secondary: return Color(hex: 0xE0E0E0)
            case .danger: return Color.red
            }
        }

        var foregroundColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return .black
            case .danger: return .white
            }
        }

        var disabledColor: Color {
            switch self {
            case .primary: return Color.Primary._400
            case .secondary: return Color(hex: 0xC8C8C8)
            case .danger: return Color.red.opacity(0.5)
            }
        }
    }

    let title: String
    var leftIcon: Image? = nil
    var rightIcon: Image? = nil
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var variant: Variant = .primary
    let action: () -> Void

    var body: some View {
        Button(action: {
            if !isDisabled && !isLoading {
                action()
            }
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: variant.foregroundColor))
                        .scaleEffect(1)
                }
                else if let leftIcon = leftIcon {
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
            .foregroundColor(variant.foregroundColor)
            .background(isDisabled ? variant.disabledColor : variant.backgroundColor)
            .cornerRadius(10)
            .animation(.easeInOut(duration: 0.2), value: isDisabled)
        }
        .disabled(isDisabled || isLoading)
    }
}

#Preview {
    VStack(spacing: 16) {
        UtilsButton(title: "Primary", variant: .primary) {}
        UtilsButton(title: "Secondary", variant: .secondary) {}
        UtilsButton(title: "Danger", variant: .danger) {}
        UtilsButton(title: "Loading", isLoading: true) {}
        UtilsButton(title: "Disabled", isDisabled: true) {}
    }
    .padding()
}
