//
//  HearingTestGuideView.swift
//  selakata
//
//  Created by Anisa Amalia on 23/10/25.
//

import SwiftUI

struct HearingTestGuideView: View {
    @ScaledMetric var iconSize: CGFloat = 200
    @ScaledMetric var horizontalPadding: CGFloat = 32
    
    let audioService: AudioService
    let repository: HearingTestRepository

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "airpods.gen3")
                .font(.system(size: iconSize))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 20) {
                Text("Wear your earphones comfortably")
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                
                Text("Placing your earphones in the correct ear helps to get the most accurate results.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            NavigationLink(destination: QuietPlaceGuideView(
                audioService: audioService,
                repository: repository
            )) {
                Text("Next")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())

            }
        }
        .padding(horizontalPadding)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HearingTestGuideView(
            audioService: AudioService(),
            repository: HearingTestRepository()
        )
    }
}
