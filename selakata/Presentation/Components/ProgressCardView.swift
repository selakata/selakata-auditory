//
//  ProgressCardView.swift
//  selakata
//
//  Created by Anisa Amalia on 16/11/25.
//

import SwiftUI

struct ProgressCardView: View {
    let stats: HomeViewModel.ProgressStats
    let isLoading: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ProgressStatCard(
                    title: "Word Comprehension",
                    percentage: stats.wordComp,
                    isLoading: isLoading
                )
                ProgressStatCard(
                    title: "Sentence Comprehension",
                    percentage: stats.sentenceComp,
                    isLoading: isLoading
                )
                ProgressStatCard(
                    title: "Speech-in-Noise (Environment)",
                    percentage: stats.speechInNoise,
                    isLoading: isLoading
                )
                ProgressStatCard(
                    title: "Speech-in-Noise (Conversation)",
                    percentage: stats.speechInNoise,
                    isLoading: isLoading
                )
            }
        }
    }
}

#Preview {
    ProgressCardView(stats: HomeViewModel.ProgressStats(), isLoading: true)
        .padding()
    
    ProgressCardView(stats: HomeViewModel.ProgressStats(wordComp: 50, sentenceComp: 43, speechInNoise: 80), isLoading: false)
        .padding()
    
    ProgressCardView(stats: HomeViewModel.ProgressStats(), isLoading: false)
        .padding()
}
