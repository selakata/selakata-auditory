//
//  VoiceRowView.swift
//  selakata
//
//  Created by Anisa Amalia on 06/11/25.
//

import SwiftUI

struct VoiceRowView: View {
    let voice: LocalAudioFile
    @ObservedObject var audioPlayerService: AudioPlayerService

    let isSelected: Bool
    let isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(voice.voiceName)
                    .font(.headline)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.accent)
                }
            }
            .padding(.vertical, 16)
            
            if isExpanded {
                PlayerControlsView(
                    voice: voice,
                    audioPlayerService: audioPlayerService
                )
                .padding(.bottom, 16)
            }
        }
    }
}

private struct PlayerControlsView: View {
    let voice: LocalAudioFile
    @ObservedObject var audioPlayerService: AudioPlayerService
    @Environment(\.modelContext) private var modelContext

    
    private var isPlaying: Bool {
        audioPlayerService.isPlaying
    }
    
    private var safeDuration: Double {
        let duration = audioPlayerService.duration
        return duration > 0 ? duration : 1.0
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Slider(
                value: $audioPlayerService.currentTime,
                in: 0...safeDuration,
                onEditingChanged: { isEditing in
                    if !isEditing {
                        audioPlayerService.seek(to: audioPlayerService.currentTime)
                    }
                }
            )
            .tint(.accentColor)
            .disabled(audioPlayerService.duration == 0)

            
            HStack {                    Image(systemName: "waveform")
                    .font(.title2)
                    .foregroundStyle(.accent)
                    .opacity(0)
                
                Spacer()
                
                Button(action: {
                    playPreview()
                }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Image(systemName: "trash")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func playPreview() {
        guard let urlString = voice.urlPreview, let url = URL(string: urlString) else {
            return
        }
        
        if audioPlayerService.isPlaying {
            audioPlayerService.stop()
        } else {
            audioPlayerService.loadAudioFromURL(url)
            audioPlayerService.play()
        }
    }
}


#Preview {
    VoiceRowView(
        voice: LocalAudioFile(
            voiceName: "Flavia",
            fileName: "WAWAWA",
            duration: 20,
            voiceId: "asdasd",
            urlPreview: "xxxx"
        ),
        audioPlayerService: AudioPlayerService(),
        isSelected: true,
        isExpanded: true
    )
}
