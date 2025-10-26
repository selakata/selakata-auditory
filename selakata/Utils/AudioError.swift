//
//  AudioError.swift
//  selakata
//
//  Created by ais on 21/10/25.
//
import Foundation

enum AudioError: LocalizedError {
    case fileNotFound(fileName: String)
    case loadFailed(reason: String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "Audio file '\(fileName).mp3' not found in main bundle."
        case .loadFailed(let reason):
            return "Failed to load audio: \(reason)"
        }
    }
}
