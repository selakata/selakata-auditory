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

    @FocusState private var isNameFieldFocused: Bool

    init(isPresented: Binding<Bool>, useCase: PersonalVoiceUseCase, modelContext: ModelContext) {
        self._isPresented = isPresented
        _viewModel = StateObject(wrappedValue: VoiceRecordingViewModel(
            useCase: useCase,
            modelContext: modelContext
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 4) {
                    TextField("Voice Name", text: $viewModel.voiceName)
                        .font(.title2.weight(.bold))
                        .multilineTextAlignment(.center)
                        .focused($isNameFieldFocused)
                        .fixedSize()
                    
                    Image(systemName: "pencil")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .padding(.top)
                .modifier(WiggleEffect(wiggleCount: $wiggleCount))
                .onChange(of: viewModel.voiceName) { _, _ in
                    if viewModel.validationError != nil {
                        viewModel.validationError = nil
                    }
                }
            
                switch viewModel.recordingState {
                case .idle:
                    IdleView(viewModel: viewModel)
                case .recording:
                    RecordingView(viewModel: viewModel, timeDisplay: $viewModel.recordingTimeDisplay, audioLevels: $viewModel.audioLevels)
                case .review:
                    ReviewView(
                        viewModel: viewModel,
                        playerService: viewModel.playerService,
                        audioLevels: viewModel.audioLevels,
                        onDone: handleDone
                    )
                case .saving:
                    Spacer()
                    ProgressView("Saving and cloning voice...")
                    Spacer()
                }
            }
            .onAppear {
                if viewModel.validationError != nil && viewModel.recordingState == .review {
                    isNameFieldFocused = true
                }
            }
        }
        .disabled(viewModel.recordingState == .saving)
        .navigationBarHidden(true)
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            isNameFieldFocused = false
        }
        .onDisappear {
            viewModel.stopAudio()
        }
    }
    
    private func handleDone() {
        viewModel.stopAudio()
        isNameFieldFocused = false
        
        viewModel.handleDoneButtonTap { success in
            if success {
                isPresented = false
            } else {
                if viewModel.validationError != nil {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                        wiggleCount += 1
                    }
                    if viewModel.validationError == "Please enter a name for your voice." {
                        isNameFieldFocused = true
                    }
                }
            }
        }
    }
}

// baru mau record
private struct IdleView: View {
    @ObservedObject var viewModel: VoiceRecordingViewModel
    
    var body: some View {
        VStack {
            Spacer(minLength: 40)
            
            Text(viewModel.promptText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 100)
                .padding(.horizontal)
                .opacity(0)
            
            Spacer(minLength: 20)
            
            Text("Tap the button to record and read the sentence loud")
                .font(.headline)

            Spacer(minLength: 40)
            
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
}

private struct WaveformView: View {
    let audioLevels: [Float]
    let isRecording: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollViewProxy in
                HStack(spacing: 2) {
                    ForEach(audioLevels.indices, id: \.self) { index in
                        let level = audioLevels[index]
                        Capsule()
                            .frame(width: 3, height: max(3, CGFloat(level) * 60))
                            .foregroundStyle(.secondary)
                    }
                    Color.clear.id("END")
                }
                .onChange(of: audioLevels.count) {
                    if isRecording {
                        withAnimation(.linear(duration: 0.05)) {
                            scrollViewProxy.scrollTo("END", anchor: .trailing)
                        }
                    }
                }
            }
        }
        .frame(height: 100)
        .padding(.horizontal, 10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}


// recording
private struct RecordingView: View {
    @ObservedObject var viewModel: VoiceRecordingViewModel
    @Binding var timeDisplay: String
    @Binding var audioLevels: [Float]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text(viewModel.promptText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)

            Spacer(minLength: 20)

            WaveformView(audioLevels: audioLevels, isRecording: true)
            
            Text(timeDisplay)
                .font(.footnote.monospaced())
            
            Spacer(minLength: 40)
            
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
}

// after record
private struct ReviewView: View {
    @ObservedObject var viewModel: VoiceRecordingViewModel
    @ObservedObject var playerService: AudioPlayerService
    let audioLevels: [Float]
    
    var onDone: () -> Void
    
    private var isPlaying: Bool {
        playerService.isPlaying
    }
    
    private var hasError: Bool {
        viewModel.validationError != nil
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(viewModel.promptText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)

            
            Spacer(minLength: 20)

            WaveformView(audioLevels: audioLevels, isRecording: false)

            if hasError {
                ErrorCardView(message: viewModel.validationError ?? "An error occurred.")
                    .padding(.top, 8)
            } else {
                Text(viewModel.formattedDuration)
                    .font(.footnote.monospaced())
                    .padding(.top, 8)
            }
            
            Spacer(minLength: 40)
            
            Button(action: {
                viewModel.playRecording()
            }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(hasError ? .gray.opacity(0.5) : .red)
            }
            .disabled(hasError)
            .padding(.bottom, 20)

            
            HStack(spacing: 16) {
                Button("Retake") {
                    viewModel.retakeRecording()
                }
                .font(.headline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                
                Button("Done", action: onDone)
                    .font(.headline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(hasError ? .secondary : Color.accentColor)
                    .overlay(
                        Capsule()
                            .stroke(hasError ? Color.secondary : Color.accentColor, lineWidth: 2)
                    )
                    .disabled(hasError)
            }
            .padding()
        }
    }
}

private struct ErrorCardView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(message)
                .font(.footnote.weight(.medium))
        }
        .padding(12)
        .background(Color.red.opacity(0.1))
        .foregroundStyle(.red)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
//#Preview {
//    let container = try! ModelContainer(
//        for: LocalAudioFile.self,
//        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
//    )
//    NavigationStack {
//        VoiceRecordingView(isPresented: .constant(true), useCase: PersonalVoiceUseCase(repository: PersonalVoiceRepositoryImpl()), modelContext: container.mainContext)
//    }
//}
