//
//  VoiceRecordingViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class VoiceRecordingViewModel: ObservableObject {
    
    enum RecordingState { case idle, recording, review }
    @Published var recordingState: RecordingState = .idle
    @Published var voiceName: String = ""
    @Published var validationError: String? = nil
    @Published var recordingTimeDisplay: String = "00:00"

    private let useCase: PersonalVoiceUseCase
    private let modelContext: ModelContext
    private var recordingTimer: Timer?
    
    var promptText: String { useCase.promptText }
    var isPlaying: Bool { useCase.isPlaying }

    var formattedDuration: String {
        guard let duration = useCase.lastRecordingResult?.duration else {
            return "00:00"
        }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    init(useCase: PersonalVoiceUseCase, modelContext: ModelContext) {
        self.useCase = useCase
        self.modelContext = modelContext
    }
    
    func startRecording() {
        validationError = nil
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
            self.validationError = "Microphone permission is required. Please enable it in Settings."
        } catch {
            self.validationError = "Failed to start recording: \(error.localizedDescription)"
        }
    }
    
    func stopRecording() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        
        let result = useCase.stopRecording()
        
        switch result {
        case .success:
            validationError = nil
            recordingState = .review
        case .failure(let error):
            if let recError = error as? RecordingError, case .recorderError(let msg) = recError {
                validationError = msg
            } else {
                validationError = error.localizedDescription
            }
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
        validationError = nil
        recordingState = .idle
    }
    
    func playRecording() {
        useCase.playRecording()
    }
    
    func saveRecording() -> Bool {
        validationError = nil
        
        let result = useCase.saveRecording(
            name: voiceName,
            context: modelContext
        )
        
        switch result {
        case .success:
            return true
        case .failure(let error):
            if case RecordingError.recorderError(let msg) = error, msg == "Name is empty." {
                validationError = "Please enter a name for your voice."
                return false
            }
            validationError = error.localizedDescription
            return false
        }
    }
    
    func stopAudio() {
        useCase.stopPlayback()
    }
}
