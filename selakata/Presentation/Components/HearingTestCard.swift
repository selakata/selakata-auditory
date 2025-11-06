//
//  HearingTestCard.swift
//  selakata
//
//  Created by Anisa Amalia on 26/10/25.
//

import SwiftUI

struct HearingTestCard: View {
    
    @ScaledMetric var padding: CGFloat = 20
    @ScaledMetric var iconSize: CGFloat = 70
    @ScaledMetric var buttonVPadding: CGFloat = 12
    @ScaledMetric var buttonHPadding: CGFloat = 24
    @ScaledMetric var buttonCornerRadius: CGFloat = 20
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Begin your auditory journey!")
                    .font(.title2.weight(.bold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color(.label))

                Text("Start")
                    .fontWeight(.semibold)
                    .padding(.vertical, buttonVPadding)
                    .padding(.horizontal, buttonHPadding)
                    .frame(minWidth: 150)
                    .background(Color.gray)
                    .foregroundStyle(.white)
                    .cornerRadius(buttonCornerRadius)
            }
            
            Spacer()

            Image(systemName: "photo.fill")
                .font(.system(size: iconSize))
                .foregroundStyle(.gray)
        }
        .padding(padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .cornerRadius(16)
    }
}

#Preview {
    HearingTestCard()
        .padding()
}
