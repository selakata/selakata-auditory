//
//  VoiceRecordingGuideView.swift
//  selakata
//
//  Created by Anisa Amalia on 05/11/25.
//

import SwiftUI

struct VoiceRecordingGuideView: View {
    @Binding var isPresented: Bool
    let useCase: PersonalVoiceUseCase
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @ScaledMetric var iconSize: CGFloat = 120
    @ScaledMetric var horizontalPadding: CGFloat = 32

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.system(size: iconSize))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 12) {
                Text("You'll be asked to say a sentence.")
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                
                Text("Make sure you're in a **quiet place** for the best result.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            NavigationLink(destination: RecordingDurationGuideView(
                isPresented: $isPresented,
                useCase: useCase
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
        .padding(.bottom)
        .navigationTitle("Personalized Voice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        VoiceRecordingGuideView(isPresented: .constant(true), useCase: PersonalVoiceUseCase(repository: PersonalVoiceRepositoryImpl()))
            .modelContainer(for: AudioFile.self, inMemory: true)
    }
}
