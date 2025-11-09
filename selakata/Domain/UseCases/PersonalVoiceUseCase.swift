//
//  PersonalVoiceUseCase.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import Foundation
import SwiftData
import AVFoundation

@MainActor
class PersonalVoiceUseCase {
    private let recorder: AudioRecorderService
    private let player: AudioPlayerService
    private let repository: PersonalVoiceRepository
    
    private var lastRecordingResult: RecordingResult?
    let promptText = "I like morning walks. The birds always sound happy"

    init(repository: PersonalVoiceRepository) {
        self.repository = repository
        self.recorder = AudioRecorderService()
        self.player = AudioPlayerService()
        player.setupPlayer()
        recorder.requestPermission()
    }
    
    var isRecording: Bool { recorder.isRecording }
    var isPlaying: Bool { player.isPlaying }
    var isPermissionGranted: Bool { recorder.isPermissionGranted }
    var recordingTime: TimeInterval { recorder.audioRecorder?.currentTime ?? 0 }
    
    func startRecording() throws {
        try recorder.startRecording()
    }
    
    func stopRecording() -> Result<Void, Error> {
        let result = recorder.stopRecording()
        switch result {
        case .success(let recording):
            guard (10...30).contains(recording.duration) else {
                return .failure(RecordingError.recorderError("Recording must be between 10 and 30 seconds."))
            }
            self.lastRecordingResult = recording
            player.loadAudioFromURL(recording.fileURL)
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func retakeRecording() {
        player.stop()
        lastRecordingResult = nil
    }
    
    func playRecording() {
        if player.isPlaying {
            player.pause()
        } else {
            if player.currentTime > 0 && player.currentTime >= player.duration {
                player.seek(to: 0)
            }
            player.play()
        }
    }
    
    func stopPlayback() {
        player.stop()
    }
    
    func saveRecording(name: String, context: ModelContext) -> Result<Void, Error> {
        guard let recording = lastRecordingResult else {
            return .failure(RecordingError.recorderError("No recording found."))
        }
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .failure(RecordingError.recorderError("Voice Name is empty."))
        }
        
        do {
            try repository.saveNewVoice(
                name: name,
                tempRecordingURL: recording.fileURL,
                duration: recording.duration,
                context: context
            )
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
