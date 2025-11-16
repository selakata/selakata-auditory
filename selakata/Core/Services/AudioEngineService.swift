//
//  AudioEngineService.swift
//  selakata
//
//  Created by ais on 15/11/25.
//


import Foundation
import AVFoundation

class AudioEngineService: NSObject, ObservableObject, AVAudioPlayerDelegate {

    @Published var isMainPlaying = false
    @Published var isNoisePlaying = false

    private var mainPlayer: AVAudioPlayer?
    private var noisePlayer: AVAudioPlayer?

    private var noiseDelayBeforeMain: TimeInterval = 1.0
    private var noiseDelayAfterMain: TimeInterval = 1.0
    
    // Fade settings
    private let fadeDuration: TimeInterval = 1.0
    private var fadeTimer: Timer?

    // Callbacks
    var onMainAudioWillFinish: (() -> Void)?
    var onMainAudioFinished: (() -> Void)?

    // MARK: - Loading

    func loadMainAudio(url: URL) {
        do {
            // Configure audio session
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            mainPlayer = try AVAudioPlayer(contentsOf: url)
            mainPlayer?.delegate = self
            mainPlayer?.prepareToPlay()
            print("✅ Main audio loaded successfully")
        } catch {
            print("❌ Error loading main audio: \(error.localizedDescription)")
        }
    }

    func loadNoiseAudio(url: URL) {
        do {
            noisePlayer = try AVAudioPlayer(contentsOf: url)
            noisePlayer?.numberOfLoops = -1   // Endless background noise
            noisePlayer?.prepareToPlay()
            print("✅ Noise audio loaded successfully")
        } catch {
            print("❌ Error loading noise audio: \(error.localizedDescription)")
        }
    }

    // MARK: - Play Sequence

    func playSequence() {
        stopAll()

        // 1. Play noise first (if exists) with fade in
        if let noisePlayer = noisePlayer {
            noisePlayer.currentTime = 0
            noisePlayer.volume = 0.0
            noisePlayer.play()
            isNoisePlaying = true
            
            // Fade in noise
            fadeIn(player: noisePlayer)
            
            // 2. After delay, play main audio (only if noise exists)
            DispatchQueue.main.asyncAfter(deadline: .now() + noiseDelayBeforeMain) {
                self.startMainAudio()
            }
        } else {
            // No noise, play main audio immediately
            startMainAudio()
        }
    }

    func startMainAudio() {
        guard let mainPlayer = mainPlayer else {
            print("❌ Main player is nil")
            return
        }

        mainPlayer.currentTime = 0
        let success = mainPlayer.play()
        print("🎵 Main audio play called - success: \(success), volume: \(mainPlayer.volume)")
        isMainPlaying = true

        // NOTIF 1: 1 detik sebelum selesai
        let timeRemaining = max(0, mainPlayer.duration - mainPlayer.currentTime - 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeRemaining) {
            if mainPlayer.isPlaying {
                self.onMainAudioWillFinish?()
            }
        }
    }

    // MARK: - AVAudioPlayer Delegate

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == mainPlayer {
            isMainPlaying = false

            // NOTIF 2: main audio selesai
            onMainAudioFinished?()

            // Fade out and stop noise (only if noise exists)
            if let noisePlayer = noisePlayer {
                fadeOut(player: noisePlayer) {
                    self.noisePlayer?.stop()
                    self.isNoisePlaying = false
                }
            }
        }
    }
    
    // MARK: - Fade Effects
    
    private func fadeIn(player: AVAudioPlayer) {
        player.volume = 0.0
        let steps = 20
        let stepDuration = fadeDuration / Double(steps)
        let volumeIncrement = 1.0 / Float(steps)
        
        var currentStep = 0
        fadeTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { [weak self] timer in
            currentStep += 1
            player.volume = min(volumeIncrement * Float(currentStep), 1.0)
            
            if currentStep >= steps {
                timer.invalidate()
                self?.fadeTimer = nil
            }
        }
    }
    
    private func fadeOut(player: AVAudioPlayer, completion: @escaping () -> Void) {
        let steps = 20
        let stepDuration = fadeDuration / Double(steps)
        let volumeDecrement = player.volume / Float(steps)
        
        var currentStep = 0
        fadeTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { [weak self] timer in
            currentStep += 1
            player.volume = max(player.volume - volumeDecrement, 0.0)
            
            if currentStep >= steps || player.volume <= 0.0 {
                timer.invalidate()
                self?.fadeTimer = nil
                completion()
            }
        }
    }

    // MARK: - Control

    func pause() {
        mainPlayer?.pause()
        noisePlayer?.pause()
        isMainPlaying = false
        isNoisePlaying = false
    }

    func stopAll() {
        fadeTimer?.invalidate()
        fadeTimer = nil
        mainPlayer?.stop()
        noisePlayer?.stop()
        isMainPlaying = false
        isNoisePlaying = false
    }
}
