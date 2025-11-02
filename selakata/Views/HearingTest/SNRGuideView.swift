//
//  SNRGuideView.swift
//  selakata
//
//  Created by Anisa Amalia on 02/11/25.
//

import SwiftUI

struct SNRGuideView: View {
    let repository: HearingTestRepository
    @State private var audioPlayerService = AudioPlayerService()
    
    @ScaledMetric var horizontalPadding: CGFloat = 32
    @ScaledMetric var iconSize: CGFloat = 200
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "waveform.path")
                .font(.system(size: iconSize))
                .foregroundStyle(.secondary)
                .padding(.bottom, 24)
            
            Text("SNR Test Required")
                .font(.title.weight(.bold))
            
            Text("Before starting your training, please complete a quick SNR (Signal-to-Noise Ratio) test.\n\nThis helps us track your progress.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            NavigationLink(destination: SNRTestView(repository: repository, audioPlayerService: audioPlayerService)) {
                Text("Get Started")
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
        .padding(.bottom)
        .navigationTitle("SNR Test")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SNRGuideView(repository: HearingTestRepository())
    }
}
