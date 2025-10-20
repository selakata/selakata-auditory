//
//  ModuleCard.swift
//  selakata
//
//  Created by Anisa Amalia on 18/10/25.
//

import SwiftUI

struct ModuleCard: View {
    let module: Module
    let showProgressBar: Bool

    @ScaledMetric var cornerRadius: CGFloat = 20
    @ScaledMetric var padding: CGFloat = 16

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(module.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(module.details)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Spacer(minLength: 12)
                                
                VStack(alignment: .leading) {
                    ProgressView(value: module.progress)
                        .tint(.accentColor)
                    
                    HStack {
                        Text("Progress")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(module.progress * 100))%")
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                }
                .opacity(showProgressBar ? 1.0 : 0.0)
            }
            
            Spacer()

            Image(systemName: module.image)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .frame(width: 60, height: 60)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(padding)
        .background(.thinMaterial)
        .cornerRadius(cornerRadius)
    }
}
