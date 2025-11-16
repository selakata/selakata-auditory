//
//  ProgressStatCard.swift
//  selakata
//
//  Created by Anisa Amalia on 16/11/25.
//

import SwiftUI

struct ProgressStatCard: View {
    let title: String
    let percentage: Int?
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            if isLoading {
                SkeletonView(height: 28)
                    .frame(width: 80)
            } else {
                Text(percentage != nil ? "\(percentage!)%" : "--%")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
            }
        }
        .padding(16)
        .frame(width: 135, height: 90, alignment: .leading)
        .background(.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(hex: 0xE7E7E7), lineWidth: 1)
        )
    }
}

#Preview {
    ProgressStatCard(title: "Word comprehension", percentage: nil, isLoading: true)
        .padding()
    
    ProgressStatCard(title: "Sentence comprehension", percentage: 50, isLoading: false)
        .padding()
    
    ProgressStatCard(title: "Speech-in-Noise (Environment)", percentage: nil, isLoading: false)
        .padding()
}
