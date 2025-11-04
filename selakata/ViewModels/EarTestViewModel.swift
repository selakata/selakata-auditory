//
//  EarTestViewModel.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//

import Foundation
import Combine

@MainActor
class EarTestViewModel: ObservableObject {
    
    @Published var currentEar: Ear
    @Published var state: TestState = .idle
    @Published var currentFrequency: Double = 0
    @Published var currentDBFS: Float = 0
    @Published var progress: Double = 0
    @Published var isTestComplete: Bool = false

    private let audioService: AudioService
    private let repository: HearingTestRepository
    
    private let frequenciesToTest: [Double] = [500, 1000, 2000, 4000]
    private var currentFrequencyIndex: Int = 0
    
    private var currentThresholds: [Double: Float] = [:]
    private var lastHeardDBFS: Float?
    private var lastNotHeardDBFS: Float?

    private var noResponseTimer: Timer?
    
    // standar dbfs before audio starts clipping (kekencengan) sama pas soundsnya barely heard (kekecilan)
    private let minDBFS: Float = -80
    private let maxDBFS: Float = -6
    
    enum TestState {
        case idle, playing, waitingForResponse, findingThreshold, finished
    }

    init(initialEar: Ear, audioService: AudioService, repository: HearingTestRepository) {
        self.currentEar = initialEar
        self.audioService = audioService
        self.repository = repository
    }
    
    func startTest() {
        currentThresholds = [:]
        currentFrequencyIndex = 0
        progress = 0.0
        isTestComplete = false
        startNextFrequency()
    }
    
    func userHeardSound() {
        guard state == .waitingForResponse else { return }
        
        noResponseTimer?.invalidate()
        audioService.stopTone()
        
        let heardDBFS = currentDBFS
        lastHeardDBFS = heardDBFS
        
        if let lastNotHeard = lastNotHeardDBFS {
            foundThreshold(heardDBFS)
        } else {
            let nextDBFS = heardDBFS - 5
            playPulsedTone(dbfs: nextDBFS)
        }
    }
    
    private func startNextFrequency() {
        guard currentFrequencyIndex < frequenciesToTest.count else {
            finishEarTest();
            return
        }
        
        currentFrequency = frequenciesToTest[currentFrequencyIndex]
        lastHeardDBFS = nil
        lastNotHeardDBFS = nil
        
        progress = Double(currentFrequencyIndex) / Double(frequenciesToTest.count)
        
        playPulsedTone(dbfs: -30)
    }
    
    private func playPulsedTone(dbfs: Float) {
        let clamped = min(max(dbfs, minDBFS), maxDBFS) // buat make sure kalo yg di play ga ngelewatin standardnya
        currentDBFS = clamped
        state = .playing

        let pan: Float = (currentEar == .left) ? -1.0 : 1.0
        audioService.playPulsedTone(frequency: currentFrequency, dbfs: clamped, pan: pan)

        state = .waitingForResponse
        noResponseTimer?.invalidate()
        noResponseTimer = Timer.scheduledTimer(
            timeInterval: 4.0,
            target: self,
            selector: #selector(userDidNotHearSound),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc private func userDidNotHearSound() {
        guard state == .waitingForResponse else { return }
        
        audioService.stopTone()
        
        let notHeardDBFS = currentDBFS
        lastNotHeardDBFS = notHeardDBFS
        
        if notHeardDBFS >= maxDBFS {
            print("User didnt hear the max: (\(maxDBFS)). Threshold set as max n moving to next frequency.")
            foundThreshold(maxDBFS)
        } else {
            let nextDBFS = notHeardDBFS + 5
            playPulsedTone(dbfs: nextDBFS)
        }
    }
    
    private func foundThreshold(_ threshold: Float) {
        state = .findingThreshold
        currentThresholds[currentFrequency] = threshold
        currentFrequencyIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.startNextFrequency()
        }
    }
    
    private func finishEarTest() {
        state = .finished
        progress = 1.0
        
        noResponseTimer?.invalidate()
        noResponseTimer = nil
        audioService.stopTone()
        
        print("Ear Test Finished: \(currentEar.title)")
        print("Thresholds found: \(currentThresholds)")
        repository.saveThresholds(for: currentEar, thresholds: currentThresholds)
        
        isTestComplete = true
    }
    
    deinit {
        // Invalidate timer
        print("EarTestViewModel is being destroyed. Shutting down audio.")
        noResponseTimer?.invalidate()

        let service = self.audioService
        
        Task { @MainActor in
            print("Deinit: Telling AudioService to stop engine.")
            service.stopEngine()
        }
    }
}
