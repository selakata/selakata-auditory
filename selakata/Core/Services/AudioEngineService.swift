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

    // Callbacks
    var onMainAudioWillFinish: (() -> Void)?
    var onMainAudioFinished: (() -> Void)?

    // MARK: - Loading

    func loadMainAudio(url: URL) {
        mainPlayer = try? AVAudioPlayer(contentsOf: url)
        mainPlayer?.delegate = self
        mainPlayer?.prepareToPlay()
    }

    func loadNoiseAudio(url: URL) {
        noisePlayer = try? AVAudioPlayer(contentsOf: url)
        noisePlayer?.numberOfLoops = -1   // Endless background noise
        noisePlayer?.prepareToPlay()
    }

    // MARK: - Play Sequence

    func playSequence() {
        stopAll()

        // 1. Play noise first (if exists)
        if let noisePlayer = noisePlayer {
            noisePlayer.currentTime = 0
            noisePlayer.play()
            isNoisePlaying = true
            
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
        guard let mainPlayer = mainPlayer else { return }

        mainPlayer.currentTime = 0
        mainPlayer.play()
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

            // Stop noise after delay (only if noise exists)
            if noisePlayer != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + noiseDelayAfterMain) {
                    self.noisePlayer?.stop()
                    self.isNoisePlaying = false
                }
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
        mainPlayer?.stop()
        noisePlayer?.stop()
        isMainPlaying = false
        isNoisePlaying = false
    }
}
