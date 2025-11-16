import SwiftUI

struct Chip: View {
    var text: String
    var leftIcon: Image? = nil
    var rightIcon: Image? = nil
    var variant: Variant = .primary
    
    enum Variant {
        case primary
        case secondary
        case danger
        
        var textColor: Color {
            switch self {
            case .primary: return Color(hex: 0x5E43E8)
            case .secondary: return Color.gray
            case .danger: return Color.red
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .primary: return Color.Primary._100
            case .secondary: return Color(hex: 0xF0F0F0)
            case .danger: return Color.red.opacity(0.1)
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            if let leftIcon = leftIcon {
                leftIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
            }
            
            Text(text)
                .font(.footnote.weight(.semibold))
            
            if let rightIcon = rightIcon {
                rightIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
            }
        }
        .foregroundColor(variant.textColor)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(variant.backgroundColor)
        .cornerRadius(20)
    }
}

#Preview {
    VStack(spacing: 12) {
        Chip(text: "Non-clinical based", leftIcon: Image("icon-warning"))
        Chip(text: "Secondary Chip", variant: .secondary)
        Chip(text: "With right icon", rightIcon: Image(systemName: "chevron.right"))
        Chip(text: "Danger Chip", variant: .danger)
    }
    .padding()
}
