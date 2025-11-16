//
//  PersonalVoiceRepositoryImpl.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import Foundation
import SwiftData

class PersonalVoiceRepositoryImpl: PersonalVoiceRepository {
    
    func saveNewVoice(
        name: String,
        voiceId: String,
        urlPreview: String,
        tempRecordingURL: URL,
        duration: TimeInterval,
        context: ModelContext
    ) throws {
        
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw RecordingError.fileCreationError
        }
        
        let permanentFileName = "voice_\(UUID().uuidString).m4a"
        let permanentURL = documentsDirectory.appendingPathComponent(permanentFileName)
        
        do {
            try fileManager.moveItem(at: tempRecordingURL, to: permanentURL)
        } catch {
            throw error
        }
        let newAudioFile = LocalAudioFile(
            voiceName: name,
            fileName: permanentFileName,
            duration: Int(duration.rounded()),
            voiceId: voiceId,
            urlPreview: urlPreview
        )
        
        context.insert(newAudioFile)
        print("Successfully saved new voice: \(permanentFileName)")
    }
}
