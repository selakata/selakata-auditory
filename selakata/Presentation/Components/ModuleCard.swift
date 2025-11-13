//  Created by Anisa Amalia on 18/10/25.

import SwiftUI

struct ModuleCard: View {
    let module: Module
    let showProgressBar: Bool
    
    @ScaledMetric var cornerRadius: CGFloat = 20
    @ScaledMetric var padding: CGFloat = 16
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(safe: "mascot-\(module.label.slugified)", default: "mascot")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .alignmentGuide(.bottom) { d in d[.bottom] }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(module.label)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.Default._700)
                    
                    Text(module.description)
                        .font(.subheadline)
                        .foregroundColor(Color.Default._700)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                Color.clear
                    .frame(width: 100)
                
            }
        }
        .padding(padding)
        .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150, alignment: .leading)
        .background(Color.Default._50)
        .cornerRadius(cornerRadius)
    }
}

#Preview {
    ModuleCard(
        module: Module(
            id: "1",
            label: "Discrimination",
            value: 42,
            description: "Tell the difference between similar sounds",
            isActive: true,
            createdAt: "",
            updatedAt: "",
            updatedBy: ""
        ),
        showProgressBar: false
    )
    .padding()
}
