//
//  PersonalizedVoiceCard.swift
//  selakata
//
//  Created by Anisa Amalia on 16/11/25.
//

import SwiftUI

struct PersonalizedVoiceCard: View {
    let state: HomeViewModel.VoiceCardState
    let backgroundAssetName = "voice-card-background"
    
    var body: some View {
        ZStack {
            Image(backgroundAssetName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .background(Color.purple)

            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 4) {
                    Image(systemName: "mic.fill")
                    Text("Personalized Voice")
                }
                .font(.footnote)
                
                switch state {
                case .loading:
                    VStack(alignment: .leading, spacing: 18) {
                        SkeletonView(height: 22)
                            .frame(maxWidth: 200)
                        SkeletonView(height: 34)
                            .frame(width: 120)
                    }
                
                case .noVoice:
                    VStack(alignment: .leading, spacing: 18) {
                        (
                            Text("Use your loved one's ")
                            +
                            Text("voice")
                                .foregroundColor(Color(hex: 0xFFE7A6))
                                .fontWeight(.heavy)
                            +
                            Text(" to make your training feel more real.")
                        )
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 224, alignment: .leading)
                        
                        Text("Try now")
                            .font(.body)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 16)
                            .foregroundColor(.accent)
                            .background(Color(hex: 0xF9F8FE))
                            .cornerRadius(8)
                    }
                    
                case .voiceSelected(let name):
                    VStack(alignment: .leading, spacing: 18) {
                        Text("You're currently using this voice")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(width: 224, alignment: .leading)
                        
                        HStack {
                            Text(name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .underline()
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 27, weight: .semibold))
                        }
                    }

                case .voiceOff:
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Personalized voice is off\nTap to choose voice")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(width: 224, alignment: .leading)
                        
                        HStack {
                            Text("--")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 27, weight: .semibold))
                        }
                    }
                }
            }
            .foregroundStyle(.white.opacity(0.9))
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 345, height: 197)
        .cornerRadius(12)
    }
}


#Preview {
    PersonalizedVoiceCard(state: .loading)
        .padding()
    PersonalizedVoiceCard(state: .noVoice)
        .padding()
    PersonalizedVoiceCard(state: .voiceSelected(name: "Anisa"))
        .padding()
    PersonalizedVoiceCard(state: .voiceOff)
        .padding()
}
