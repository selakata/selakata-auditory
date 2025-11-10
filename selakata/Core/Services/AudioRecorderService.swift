//
//  AudioRecorderServiceImpl.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import Foundation
import AVFoundation

enum RecordingError: Error {
    case permissionDenied
    case fileCreationError
    case recorderError(String)
}

struct RecordingResult {
    let fileURL: URL
    let duration: TimeInterval
}

@MainActor
class AudioRecorderService: NSObject, ObservableObject, AVAudioRecorderDelegate {
    
    @Published var isRecording = false
    @Published var isPermissionGranted = false
    
    var audioRecorder: AVAudioRecorder?
    private var recordingURL: URL?

    override init() {
        super.init()
    }
    
    func requestPermission() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default)
        try? session.setActive(true)

        AVAudioApplication.requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                self?.isPermissionGranted = granted
                if !granted {
                    print("Microphone permission denied.")
                }
            }
        }
    }
    
    func startRecording() throws {
        if !isPermissionGranted {
            print("Cannot record. Permission not granted.")
            throw RecordingError.permissionDenied
        }
        
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default)
        try session.setActive(true)

        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let filePath = tempDir.appendingPathComponent("temp_recording_\(UUID().uuidString).m4a")
        self.recordingURL = filePath

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            isRecording = true
        } catch {
            throw RecordingError.recorderError(error.localizedDescription)
        }
    }
    
    func stopRecording() -> Result<RecordingResult, Error> {
        guard let recorder = audioRecorder, isRecording else {
            return .failure(RecordingError.recorderError("Recorder not started."))
        }
        
        let duration = recorder.currentTime
        
        recorder.stop()
        self.isRecording = false
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(false)
        
        guard let url = recordingURL else {
            return .failure(RecordingError.fileCreationError)
        }
        
        return .success(RecordingResult(fileURL: url, duration: duration))
    }
    
    nonisolated func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            Task { @MainActor in
                isRecording = false
                try? AVAudioSession.sharedInstance().setActive(false)
                print("Recording finished unsuccessfully (e.g., interruption).")
            }
        }
    }
}
