//
//  RecordingDurationGuideView.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import SwiftUI

struct RecordingDurationGuideView: View {
    @Binding var isPresented: Bool
    let useCase: PersonalVoiceUseCase
    
    @Environment(\.modelContext) private var modelContext
    @ScaledMetric var iconSize: CGFloat = 120
    @ScaledMetric var horizontalPadding: CGFloat = 32

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "person.wave.2")
                .font(.system(size: iconSize))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 12) {
                Text("Please say the given sentence")
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                
                Text("for at least **10 seconds**, but no more than **30 seconds**.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            NavigationLink(destination: VoiceRecordingView(
                isPresented: $isPresented,
                useCase: useCase,
                modelContext: modelContext
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
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { isPresented = false }
            }
        }
    }
}
