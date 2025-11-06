//
//  SNRTestViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 02/11/25.
//

import Foundation
import Combine

@MainActor
class SNRTestViewModel: ObservableObject {
    @Published var audioPlayerService: AudioPlayerService
    let repository: HearingTestRepository
    
    @Published var isTestFinished = false
    @Published var currentQuestionText = "Were you able to understand the conversation?"
    
    private let snrLevels = [10, 15, 20, 25]
    private var currentLevelIndex = 0
    private var audioRange = ""

    init(repository: HearingTestRepository, audioPlayerService: AudioPlayerService) {
        self.repository = repository
        self.audioPlayerService = audioPlayerService
    }
    
    func startTest() {
        self.audioRange = getAudioRange()
        currentLevelIndex = 0
        playCurrentAudio()
    }
    
    func userTapped(answer: Bool) {
        audioPlayerService.stop()
        
        let snr = snrLevels[currentLevelIndex]
        
        if answer == true {
            print("SNR Test complete. User heard \(snr) dB.")
            repository.saveSNR(snr)
            isTestFinished = true
        } else {
            if currentLevelIndex >= snrLevels.count - 1 {
                print("SNR Test complete. User failed all levels. SNR set to 25 dB.")
                repository.saveSNR(snrLevels.last!)
                isTestFinished = true
            } else {
                currentLevelIndex += 1
                currentQuestionText = "What about this conversation?"
                playCurrentAudio()
            }
        }
    }
    
    private func playCurrentAudio() {
        let snr = snrLevels[currentLevelIndex]
        let fileName = "snr-\(snr)-\(audioRange)"
        
        print("Playing audio: \(fileName)")

        audioPlayerService.loadAudioFromPath(
            fileName: fileName,
            subdirectory: nil
        )
        audioPlayerService.play()
    }
    
    private func getAudioRange() -> String {
        let leftThresholds = repository.loadLeftThresholds()
        let rightThresholds = repository.loadRightThresholds()
        
        let leftPTA = calculatePTA(from: leftThresholds) ?? -20
        let rightPTA = calculatePTA(from: rightThresholds) ?? -20
        
        let avgPTA = (leftPTA + rightPTA) / 2.0
        
        switch avgPTA {
        case -20 ... -6:
            return "range-1"
        case -35 ... -21:
            return "range-2"
        case -50 ... -36:
            return "range-3"
        case -80 ... -51:
            return "range-4"
//        case -80 ... -66:
//            return "range_5"
        default:
            print("PTA \(avgPTA) out of range. Defaulting to range 2.")
            return "range-2"
        }
    }
    
    private func calculatePTA(from thresholds: [Double: Float]?) -> Float? {
        return HearingTestCalculator.calculatePTA(from: thresholds)
    }
    
    func stopAudio() {
        audioPlayerService.stop()
    }
}
