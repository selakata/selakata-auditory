//
//  VoiceRowView.swift
//  selakata
//
//  Created by Anisa Amalia on 06/11/25.
//

import SwiftUI

struct VoiceRowView: View {
    let voice: AudioFile
    @ObservedObject var audioPlayerService: AudioPlayerService
    @Binding var selectedVoiceID: String?
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            // Collapsed Row
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(voice.voiceName)
                        .font(.headline)
                    Text("Duration: \(voice.duration)s")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if selectedVoiceID == voice.id.uuidString {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.accent)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    selectedVoiceID = voice.id.uuidString
                    isExpanded.toggle()
                }
            }
            
            // Expanded Player
            if isExpanded {
                VStack(spacing: 12) {
                    Slider(value: $audioPlayerService.currentTime, in: 0...audioPlayerService.duration) { editing in
                        if !editing {
                            audioPlayerService.seek(to: audioPlayerService.currentTime)
                        }
                    }
                    
                    // Player Controls
                    HStack {
                        Text(String(format: "%.2f", audioPlayerService.currentTime))
                            .font(.footnote.monospaced())
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        // play/pause btn
                        Button(action: {
                            if audioPlayerService.isPlaying {
                                audioPlayerService.pause()
                            } else {
                                audioPlayerService.loadAudioFromPath(
                                    fileName: voice.fileName,
                                    subdirectory: "Resource/Audio"
                                )
                                audioPlayerService.play()
                            }
                        }) {
                            Image(systemName: audioPlayerService.isPlaying ? "pause.fill" : "play.fill")
                                .font(.title)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }) {
                            Image(systemName: "trash")
                                .font(.body)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    VoiceRowView(voice: AudioFile(voiceName: "Flavia", fileName: "WAWAWA", duration: 20), audioPlayerService: AudioPlayerService(),
        selectedVoiceID: .constant("")
    )
}
