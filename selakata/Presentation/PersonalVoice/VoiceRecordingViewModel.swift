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
    
    enum RecordingState { case idle, recording, review, saving }
    @Published var recordingState: RecordingState = .idle
    @Published var voiceName: String = ""
    @Published var validationError: String? = nil
    @Published var recordingTimeDisplay: String = "00:00"
    @Published var audioLevels: [Float] = []

    private let useCase: PersonalVoiceUseCase
    private let modelContext: ModelContext
    private var recordingTimer: Timer?

    @ObservedObject var playerService: AudioPlayerService

    var promptText: String { useCase.promptText }

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
        self.playerService = useCase.player
    }
    
    func startRecording() {
        validationError = nil
        audioLevels = []
        
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
            useCase.retakeRecording()
            
            if let recError = error as? RecordingError, case .recorderError(let msg) = recError {
                validationError = msg
            } else {
                validationError = error.localizedDescription
            }
            recordingState = .review
        }
    }
    
    private func updateRecordingTime() {
        let time = useCase.recordingTime
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        recordingTimeDisplay = String(format: "%02d:%02d", minutes, seconds)
        self.audioLevels.append(useCase.getAudioLevel())
    }
    
    func retakeRecording() {
        useCase.retakeRecording()
        validationError = nil
        audioLevels = []
        recordingState = .idle
    }
    
    func playRecording() {
        useCase.playRecording()
    }
    
    func handleDoneButtonTap(completion: @escaping (Bool) -> Void) {
        validationError = nil
        
        guard !voiceName.trimmingCharacters(in: .whitespaces).isEmpty else {
            validationError = "Please enter a name for your voice."
            completion(false)
            return
        }
    
        guard useCase.lastRecordingResult != nil else {
            validationError = "Recording is invalid. Please retake."
            completion(false)
            return
        }
        
        recordingState = .saving
        
        useCase.saveAndCloneRecording(name: voiceName, context: modelContext) { result in
            switch result {
            case .success:
                self.recordingState = .idle
                completion(true)
            case .failure(let error):
                self.validationError = "Save failed: \(error.localizedDescription)"
                self.recordingState = .review
                completion(false)
            }
        }
    }
    
    func stopAudio() {
        useCase.stopPlayback()
    }
}
