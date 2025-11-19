//
//  PersonalizedVoiceCard.swift
//  selakata
//
//  Created by Anisa Amalia on 16/11/25.
//

import SwiftUI

struct PersonalizedVoiceCard: View {
    let state: HomeViewModel.VoiceCardState
    let offBackground = "voice-card-background"
    let activeBackground = "active-voice-card-background"
    
    var body: some View {
        ZStack {
            switch state {
            case .loading:
                Image(offBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .noVoice:
                Image(offBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .voiceSelected(let name):
                Image(activeBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .voiceOff:
                Image(activeBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }

            VStack(alignment: .leading) {
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
                        SkeletonView(height: 45)
                            .frame(width: 150)
                    }
                    .padding(.top, 18)
                
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
                            .frame(width: 150, height: 45)
                            .background(Color(hex: 0xF9F8FE))
                            .cornerRadius(10)
                    }
                    .padding(.top, 8)
                    
                case .voiceSelected(let name):
                    HStack {
                        Text(name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .underline()
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color.accentColor)
                        }
                    }

                case .voiceOff:
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            Text("--")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color.accentColor)
                            }
                        }
                    }
                }
            }
            .foregroundStyle(.white.opacity(0.9))
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 345, height: (state == .noVoice || state == .loading) ? 197 : 93)
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
