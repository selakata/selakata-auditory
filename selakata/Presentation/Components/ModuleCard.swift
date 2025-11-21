//  Created by Anisa Amalia on 18/10/25.

import SwiftUI

struct ModuleCard: View {
    let module: Module
    let showProgressBar: Bool
    
    @ScaledMetric var cornerRadius: CGFloat = 20
    @ScaledMetric var padding: CGFloat = 16
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(safe: module.isUnlocked ? "mascot-\(module.label.slugified)" : "icon-padlocks", default: "mascot")
                .resizable()
                .scaledToFit()
                .frame(width: 135, height: 135)
                .alignmentGuide(.bottom) { d in d[.bottom] }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        if !module.isUnlocked {
                            Image("icon-lock")
                        }
                        Text(module.label)
                            .font(.app(.headline).weight(.semibold))
                            .foregroundColor(Color.Default._700)
                    }
                    
                    Text(module.description)
                        .font(.app(.callout))
                        .foregroundColor(Color.Default._700)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                Color.clear
                    .frame(width: 100)
                
            }
            .padding(padding)
        }
        .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150, alignment: .leading)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.Default._200, lineWidth: 1)
        )
        .overlay(
            Group {
                if !module.isUnlocked {
                    Color.white.opacity(0.6)
                        .cornerRadius(cornerRadius)
                }
            }
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        ModuleCard(
            module: Module(
                id: "1",
                label: "Comprehension",
                value: 42,
                description: "Listen to short sentences and answer the questions",
                isActive: true,
                createdAt: "",
                updatedAt: "",
                updatedBy: "",
                isUnlocked: true,
                percentage: 80.0
            ),
            showProgressBar: false
        )
        
        ModuleCard(
            module: Module(
                id: "1",
                label: "Comprehension",
                value: 42,
                description: "Listen to short sentences and answer the questions",
                isActive: true,
                createdAt: "",
                updatedAt: "",
                updatedBy: "",
                isUnlocked: false,
                percentage: 80.0
            ),
            showProgressBar: false
        )
    }
    .padding()
}
