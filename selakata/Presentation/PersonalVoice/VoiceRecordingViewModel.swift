//
//  VoiceRecordingViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import Foundation
import SwiftData

@MainActor
class VoiceRecordingViewModel: ObservableObject {
    
    enum RecordingState { case idle, recording, review }
    @Published var recordingState: RecordingState = .idle
    @Published var voiceName: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var recordingTimeDisplay: String = "00:00"

    private let useCase: PersonalVoiceUseCase
    private let modelContext: ModelContext
    private var recordingTimer: Timer?
    
    var promptText: String { useCase.promptText }
    var isPlaying: Bool { useCase.isPlaying }

    init(useCase: PersonalVoiceUseCase, modelContext: ModelContext) {
        self.useCase = useCase
        self.modelContext = modelContext
    }
    
    func startRecording() {
        do {
            try useCase.startRecording()
            recordingState = .recording
            
            recordingTimeDisplay = "00:00"
            recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                Task { @MainActor in
                    self?.updateRecordingTime()
                }
            }
        } catch RecordingError.permissionDenied {
            alertMessage = "Microphone permission is required."
            showAlert = true
        } catch {
            alertMessage = "Failed to start recording: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func stopRecording() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        
        let result = useCase.stopRecording()
        
        switch result {
        case .success:
            recordingState = .review
        case .failure(let error):
            alertMessage = error.localizedDescription
            showAlert = true
            recordingState = .idle
        }
    }
    
    private func updateRecordingTime() {
        let time = useCase.recordingTime
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        recordingTimeDisplay = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func retakeRecording() {
        useCase.retakeRecording()
        recordingState = .idle
    }
    
    func playRecording() {
        useCase.playRecording()
    }
    
    func saveRecording() -> Bool {
        let result = useCase.saveRecording(
            name: voiceName,
            context: modelContext
        )
        
        switch result {
        case .success:
            return true
        case .failure(let error):
            if case RecordingError.recorderError(let msg) = error, msg == "Name is empty." {
                return false
            }
            alertMessage = error.localizedDescription
            showAlert = true
            return false
        }
    }
    
    func stopAudio() {
        useCase.stopPlayback()
    }
}
