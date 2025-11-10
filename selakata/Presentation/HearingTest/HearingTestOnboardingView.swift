//
//  HearingTestView.swift
//  selakata
//
//  Created by Anisa Amalia on 23/10/25.
//

import SwiftUI

struct HearingTestOnboardingView: View {
    @Binding var isStartingTest: Bool
    
    @State private var audioService = AudioService()
    @State private var repository = HearingTestRepositoryImpl()
    
    @ScaledMetric var mainLogoSize: CGFloat = 96
    @ScaledMetric var horizontalPadding: CGFloat = 32
    @ScaledMetric var benefitSpacing: CGFloat = 24
    


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    Image(systemName: "ear.and.waveform")
                        .font(.system(size: mainLogoSize))
                        .foregroundStyle(.secondary)
                        .padding(.top, 40)
                    
                    Text("Hearing Test")
                        .font(.largeTitle.weight(.bold))
                    
                    VStack(alignment: .leading, spacing: benefitSpacing) {
                        GuideRowView(
                            iconName: "airpods.gen3",
                            description: "For accurate results, we recommend using AirPods during this test."
                        )
                        GuideRowView(
                            iconName: "timer",
                            description: "To make your training effective, we'll begin with a quick hearing test."
                        )
                        GuideRowView(
                            iconName: "audio.jack.mono",
                            description: "The results will help us adjust audio levels and exercises that best fit your hearing ability."
                        )
                        GuideRowView(
                            iconName: "checkmark",
                            description: "This test won't replace a clinical hearing exam, but it helps us give you the most accurate experience."
                        )
                    }
                    .padding(.horizontal, horizontalPadding)
                    
                    Spacer()
                }
            }
            
            NavigationLink(destination: HearingTestGuideView(
                isStartingTest: $isStartingTest,
                audioService: audioService,
                repository: repository
            )) {
                Text("Get Started")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

struct GuideRowView: View {
    let iconName: String
    let description: String
    
    @ScaledMetric var iconSize: CGFloat = 24

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: iconSize))
                .frame(width: iconSize)
            
            Text(description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    HearingTestOnboardingView(isStartingTest: .constant(true))
}
