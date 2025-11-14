//
//  PersonalVoiceRepository.swift
//  selakata
//
//  Created by Anisa Amalia on 09/11/25.
//

import Foundation
import SwiftData

protocol PersonalVoiceRepository {
    func saveNewVoice(
        name: String,
        voiceId: String,
        urlPreview: String,
        tempRecordingURL: URL,
        duration: TimeInterval,
        context: ModelContext
    ) throws
}
