//
//  VoiceRecordingView.swift
//  selakata
//
//  Created by Anisa Amalia on 05/11/25.
//

import SwiftUI
import SwiftData

struct VoiceRecordingView: View {
    @Binding var isPresented: Bool
    
    @StateObject private var viewModel: VoiceRecordingViewModel
    @State private var wiggleCount = 0

    init(isPresented: Binding<Bool>, useCase: PersonalVoiceUseCase, modelContext: ModelContext) {
        self._isPresented = isPresented
        _viewModel = StateObject(wrappedValue: VoiceRecordingViewModel(
            useCase: useCase,
            modelContext: modelContext
        ))
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Voice Name", text: $viewModel.voiceName)
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)
                Image(systemName: "pencil")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .modifier(WiggleEffect(wiggleCount: $wiggleCount))

            switch viewModel.recordingState {
            case .idle:
                IdleView(viewModel: viewModel)
            case .recording:
                RecordingView(viewModel: viewModel, timeDisplay: $viewModel.recordingTimeDisplay)
            case .review:
                ReviewView(
                    viewModel: viewModel,
                    onDone: handleDone
                )
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func handleDone() {
        viewModel.stopAudio()
        
        if viewModel.saveRecording() {
            isPresented = false
        } else {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                wiggleCount += 1
            }
        }
    }
}

// baru mau record
private struct IdleView: View {
    @ObservedObject var viewModel: VoiceRecordingViewModel
    
    var body: some View {
        Spacer()
        Text("Say the sentence below out loud")
            .font(.headline)
        
        Text(viewModel.promptText)
            .font(.title2)
            .multilineTextAlignment(.center)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)
        
        Spacer()
        
        Button(action: {
            viewModel.startRecording()
        }) {
            Image(systemName: "mic.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.red)
        }
        .padding(.bottom, 40)
    }
}

// recording
private struct RecordingView: View {
    @ObservedObject var viewModel: VoiceRecordingViewModel
    
    @Binding var timeDisplay: String
    
    var body: some View {
        Spacer()
        Image(systemName: "waveform") // placeholder dulu
            .font(.system(size: 60))
            .foregroundStyle(.secondary)
            .frame(height: 100)
        
        Text(timeDisplay)
            .font(.footnote.monospaced())
        
        Text(viewModel.promptText)
            .font(.title2)
            .multilineTextAlignment(.center)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)
        
        Spacer()
        
        Button(action: {
            viewModel.stopRecording()
        }) {
            Image(systemName: "stop.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.red)
        }
        .padding(.bottom, 40)
    }
}

// after record
private struct ReviewView: View {
    @ObservedObject var viewModel: VoiceRecordingViewModel
    
    var onDone: () -> Void
    
    var body: some View {
        Spacer()
        Image(systemName: "waveform") // placeholder dulu
            .font(.system(size: 60))
            .foregroundStyle(.secondary)
            .frame(height: 100)
        
        Text("Recording is done")
            .font(.footnote)
        
        Text(viewModel.promptText)
            .font(.title2)
            .multilineTextAlignment(.center)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)
        
        Spacer()
        
        Button(action: {
            viewModel.playRecording()
        }) {
            Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.red)
        }
        .padding(.bottom, 40)
        
        HStack {
            Button("Retake") {
                viewModel.retakeRecording()
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            
            Spacer()
            
            Button("Done", action: onDone)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
        .padding()
    }
}


#Preview {
    let container = try! ModelContainer(
        for: AudioFile.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    NavigationStack {
        VoiceRecordingView(isPresented: .constant(true), useCase: PersonalVoiceUseCase(repository: PersonalVoiceRepositoryImpl()), modelContext: container.mainContext)
    }
}
