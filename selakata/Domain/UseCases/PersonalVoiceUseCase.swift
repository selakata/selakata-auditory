//
//  PersonalVoiceUseCase.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import Foundation
import SwiftData
import AVFoundation

// decode dari 11labs
private struct ElevenLabsJSONResponse: Decodable {
    let voiceId: String
    enum CodingKeys: String, CodingKey {
        case voiceId = "voice_id"
    }
}

// encode buat ke be
private struct TeamAddVoiceRequest: Encodable {
    let voiceName: String
    let voiceId: String
}

struct VoiceData: Decodable {
    let id: String
    let voiceId: String
    let voiceName: String
    let previewUrl: String
    let createdAt: String
    let updatedAt: String
}

private struct TeamAddVoiceResponse: Decodable {
    let message: String
    let data: VoiceData
}

private struct TeamGetVoicesResponse: Decodable {
    let data: [VoiceData]
}

@MainActor
class PersonalVoiceUseCase {
    private let recorder: AudioRecorderService
    let player: AudioPlayerService
    private let repository: PersonalVoiceRepository
    
    private let apiClient: APIClientProtocol
    private let voiceConfig: VoiceAPIConfiguration
    private let elevenLabsConfig: ElevenLabsAPIConfiguration

    var lastRecordingResult: RecordingResult?
    let promptText = "Hai, apa kabar? Ini suara saya yang digunakan untuk latihan mendengar. Saya akan berbicara seperti biasa, dengan nada yang tenang dan jelas. Kadang saya akan menurunkan sedikit intonasi, lalu menaikkan lagi, supaya sistem bisa mengenali warna suara saya dengan lebih baik."

    init(
        recorder: AudioRecorderService,
        player: AudioPlayerService,
        repository: PersonalVoiceRepository,
        apiClient: APIClientProtocol,
        voiceConfig: VoiceAPIConfiguration,
        elevenLabsConfig: ElevenLabsAPIConfiguration
    ) {
        self.recorder = recorder
        self.player = player
        self.repository = repository
        self.apiClient = apiClient
        self.voiceConfig = voiceConfig
        self.elevenLabsConfig = elevenLabsConfig
        
        player.setupPlayer()
        recorder.requestPermission()
    }
    
    var isRecording: Bool { recorder.isRecording }
    var isPlaying: Bool { player.isPlaying }
    var isPermissionGranted: Bool { recorder.isPermissionGranted }
    var recordingTime: TimeInterval { recorder.audioRecorder?.currentTime ?? 0 }
    var lastRecordingDuration: TimeInterval? { lastRecordingResult?.duration }

    func getAudioLevel() -> Float {
        return recorder.getAudioLevel()
    }
    
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
    
    func syncVoiceList(
        context: ModelContext,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        print("Syncing voice list")
        
        guard let url = voiceConfig.makeGetVoicesRequest() else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        // decode response
        apiClient.request(url: url, method: .get) { [weak self] (result: Result<TeamGetVoicesResponse, Error>) in
            guard self != nil else { return }
            
            switch result {
            case .failure(let error):
                print("PersonalvoiceUseCase: Failed to fetch voice list. \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
    
            case .success(let response):
                let voicesFromServer = response.data
                
                // sync with SwiftData
                Task { @MainActor in
                    do {
                        let descriptor = FetchDescriptor<LocalAudioFile>()
                        let localVoices = try context.fetch(descriptor)
                        
                        let localVoiceIDs = Set(localVoices.map { $0.voiceId })
                        
                        let newVoicesToSave = voicesFromServer.filter {
                            !localVoiceIDs.contains($0.voiceId)
                        }
                    
                        for voiceData in newVoicesToSave {
                            let newAudioFile = LocalAudioFile(
                                voiceName: voiceData.voiceName,
                                fileName: "",
                                duration: 0,
                                voiceId: voiceData.voiceId,
                                urlPreview: voiceData.previewUrl
                            )
                            context.insert(newAudioFile)
                        }
                        completion(.success(()))
                    } catch {
                        print("PersonalVoiceUseCase: Error fetching from SwiftData. \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func saveAndCloneRecording(
        name: String,
        context: ModelContext,
        completion: @escaping (Result<VoiceData, Error>) -> Void
    ) {
        
        guard let recording = lastRecordingResult else {
            completion(.failure(RecordingError.recorderError("No recording found.")))
            return
        }
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion(.failure(RecordingError.recorderError("Name is empty.")))
            return
        }
        
        guard let elevenLabsURL = elevenLabsConfig.makeElevenLabsAddVoiceURL() else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        apiClient.uploadFile(
            url: elevenLabsURL,
            fileURL: recording.fileURL,
            voiceName: name,
            apiKey: elevenLabsConfig.getAPIKey()
        ) { [weak self] (result: Result<ElevenLabsJSONResponse, Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print("11Labs upload error. \(error.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(error)) }
                
            case .success(let elevenLabsResponse):
                let voiceId = elevenLabsResponse.voiceId
                print("Got voiceId \(voiceId)")
                
                
                guard let teamApiUrl = self.voiceConfig.makeTeamAddVoiceURL() else {
                    DispatchQueue.main.async { completion(.failure(URLError(.badURL))) }
                    return
                }
                
                let body = TeamAddVoiceRequest(voiceName: name, voiceId: voiceId)
                
                self.apiClient.requestWithBody(
                    url: teamApiUrl,
                    method: .post,
                    body: body
                ) { (result: Result<TeamAddVoiceResponse, Error>) in
                    
                    DispatchQueue.main.async {
                        switch result {
                        case .failure(let error):
                            print("Team API save error. \(error.localizedDescription)")
                            completion(.failure(error))
                            
                        case .success(let response):
                            print("Team API Success: \(response.message)")
                            let voiceData = response.data
                            
                            do {
                                try self.repository.saveNewVoice(
                                    name: voiceData.voiceName,
                                    voiceId: voiceData.voiceId,
                                    urlPreview: voiceData.previewUrl,
                                    tempRecordingURL: recording.fileURL,
                                    duration: recording.duration,
                                    context: context
                                )
                                completion(.success(voiceData))
                            } catch {
                                print("SwiftData save error:  \(error.localizedDescription)")
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
        }
    }
}
