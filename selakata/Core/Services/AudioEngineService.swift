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
    
    // RMS settings - target dBFS values from Question
    private var targetMainRMS: Double = 0.0
    private var targetNoiseRMS: Double = 0.0
    
    // Calculated volumes based on RMS
    private var calculatedMainVolume: Float = 1.0
    private var calculatedNoiseVolume: Float = 1.0

    // Callbacks
    var onMainAudioWillFinish: (() -> Void)?
    var onMainAudioFinished: (() -> Void)?

    // MARK: - Loading

    func loadMainAudio(url: URL, targetRMS: Double = 0.0) {
        do {
            print("🎵 loadMainAudio called with input value: \(targetRMS)")
            
            // Configure audio session
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            // Convert input to RMS if it's in dBFS (negative value)
            let actualTargetRMS = convertToRMS(targetRMS)
            targetMainRMS = actualTargetRMS
            
            print("   Input value: \(targetRMS)")
            print("   Converted to RMS: \(actualTargetRMS)")
            
            // If targetRMS is provided, normalize audio to that RMS level
            if actualTargetRMS > 0.0 {
                print("🔄 Normalizing main audio to target RMS: \(actualTargetRMS)")
                if let normalizedURL = normalizeAudio(sourceURL: url, targetRMS: actualTargetRMS, isNoise: false) {
                    mainPlayer = try AVAudioPlayer(contentsOf: normalizedURL)
                    print("✅ Main audio normalized and loaded from: \(normalizedURL.lastPathComponent)")
                } else {
                    // Fallback to original if normalization fails
                    print("⚠️ Normalization failed, using original audio")
                    mainPlayer = try AVAudioPlayer(contentsOf: url)
                }
            } else {
                // No RMS specified, use original audio at full volume
                print("⚠️ WARNING: No valid RMS value, using original audio at full volume")
                mainPlayer = try AVAudioPlayer(contentsOf: url)
            }
            
            mainPlayer?.delegate = self
            mainPlayer?.prepareToPlay()
            mainPlayer?.volume = 1.0  // Always use full volume since audio is already normalized
            
            print("✅ Main audio loaded successfully")
            print("   Duration: \(mainPlayer?.duration ?? 0)s")
            print("   Volume: \(mainPlayer?.volume ?? 0)")
        } catch {
            print("❌ Error loading main audio: \(error.localizedDescription)")
        }
    }

    func loadNoiseAudio(url: URL, targetRMS: Double = 0.0) {
        do {
            print("🎵 loadNoiseAudio called with input value: \(targetRMS)")
            
            // Convert input to RMS if it's in dBFS (negative value)
            let actualTargetRMS = convertToRMS(targetRMS)
            targetNoiseRMS = actualTargetRMS
            
            print("   Input value: \(targetRMS)")
            print("   Converted to RMS: \(actualTargetRMS)")
            
            // If targetRMS is provided, normalize audio to that RMS level
            if actualTargetRMS > 0.0 {
                print("🔄 Normalizing noise audio to target RMS: \(actualTargetRMS)")
                if let normalizedURL = normalizeAudio(sourceURL: url, targetRMS: actualTargetRMS, isNoise: true) {
                    noisePlayer = try AVAudioPlayer(contentsOf: normalizedURL)
                    print("✅ Noise audio normalized and loaded from: \(normalizedURL.lastPathComponent)")
                } else {
                    // Fallback to original if normalization fails
                    print("⚠️ Normalization failed, using original audio")
                    noisePlayer = try AVAudioPlayer(contentsOf: url)
                }
            } else {
                // No RMS specified, use original audio at full volume
                print("⚠️ WARNING: No valid RMS value, using original audio at full volume")
                noisePlayer = try AVAudioPlayer(contentsOf: url)
            }
            
            noisePlayer?.numberOfLoops = -1   // Endless background noise
            noisePlayer?.prepareToPlay()
            calculatedNoiseVolume = 1.0  // Always use full volume since audio is already normalized
            
            print("✅ Noise audio loaded successfully")
            print("   Duration: \(noisePlayer?.duration ?? 0)s")
            print("   Volume: \(calculatedNoiseVolume)")
        } catch {
            print("❌ Error loading noise audio: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Audio Normalization
    
    /// Convert input value to RMS
    /// If input is negative (dBFS), convert to RMS
    /// If input is positive (already RMS), use as is
    private func convertToRMS(_ value: Double) -> Double {
        if value < 0 {
            // Input is in dBFS (e.g., -15 dBFS)
            // Convert to RMS: RMS = 10^(dBFS/20)
            let rms = pow(10.0, value / 20.0)
            print("   Converting dBFS to RMS: \(value) dBFS → \(rms) RMS")
            return rms
        } else if value > 0 && value <= 1.0 {
            // Input is already RMS (0.0 - 1.0)
            print("   Input is already RMS: \(value)")
            return value
        } else if value > 1.0 {
            // Invalid value, clamp to 1.0
            print("   ⚠️ Invalid RMS value (\(value) > 1.0), clamping to 1.0")
            return 1.0
        } else {
            // value == 0
            print("   ⚠️ RMS value is 0, no normalization")
            return 0.0
        }
    }
    
    /// Normalize audio to target RMS level (similar to SoundLevel.swift exportAudioWithTargetdBFS)
    /// Returns URL of normalized audio file in temp directory
    private func normalizeAudio(sourceURL: URL, targetRMS: Double, isNoise: Bool) -> URL? {
        do {
            // Read source audio file
            let audioFile = try AVAudioFile(forReading: sourceURL)
            let format = audioFile.processingFormat
            let frameCount = AVAudioFrameCount(audioFile.length)
            
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
                print("❌ Failed to create buffer")
                return nil
            }
            
            try audioFile.read(into: buffer)
            
            // Calculate current RMS of the audio
            var sumOfSquares: Double = 0.0
            var totalSamples = 0
            let channelCount = Int(format.channelCount)
            
            for channel in 0..<channelCount {
                guard let channelData = buffer.floatChannelData?[channel] else { continue }
                
                for i in 0..<Int(buffer.frameLength) {
                    let sample = Double(channelData[i])
                    sumOfSquares += sample * sample
                    totalSamples += 1
                }
            }
            
            guard totalSamples > 0 else {
                print("❌ No samples found")
                return nil
            }
            
            let currentRMS = sqrt(sumOfSquares / Double(totalSamples))
            
            // Convert RMS values to dBFS for calculation
            let currentdBFS = currentRMS > 0 ? 20 * log10(currentRMS) : -100.0
            let targetdBFS = targetRMS > 0 ? 20 * log10(targetRMS) : -100.0
            
            // Calculate gain needed
            let gainNeeded = targetdBFS - currentdBFS
            let linearGain = pow(10.0, gainNeeded / 20.0)
            
            print("📊 Audio Analysis:")
            print("   Current RMS: \(currentRMS) (\(currentdBFS) dBFS)")
            print("   Target RMS: \(targetRMS) (\(targetdBFS) dBFS)")
            print("   Gain needed: \(gainNeeded) dB")
            print("   Linear gain: \(linearGain)")
            
            // Create output file in temp directory
            let tempDir = FileManager.default.temporaryDirectory
            let outputFileName = isNoise ? "normalized_noise_\(UUID().uuidString).wav" : "normalized_main_\(UUID().uuidString).wav"
            let outputURL = tempDir.appendingPathComponent(outputFileName)
            
            // Remove existing file if it exists
            try? FileManager.default.removeItem(at: outputURL)
            
            // Create output audio file
            let outputFile = try AVAudioFile(forWriting: outputURL, settings: [
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVSampleRateKey: format.sampleRate,
                AVNumberOfChannelsKey: format.channelCount,
                AVLinearPCMBitDepthKey: 32,
                AVLinearPCMIsFloatKey: true
            ])
            
            // Apply gain to all channels
            for channel in 0..<channelCount {
                guard let channelData = buffer.floatChannelData?[channel] else { continue }
                
                for i in 0..<Int(buffer.frameLength) {
                    channelData[i] *= Float(linearGain)
                    
                    // Prevent clipping
                    channelData[i] = max(-1.0, min(1.0, channelData[i]))
                }
            }
            
            // Write normalized audio
            try outputFile.write(from: buffer)
            
            print("✅ Audio normalized successfully: \(outputURL.lastPathComponent)")
            return outputURL
            
        } catch {
            print("❌ Error normalizing audio: \(error.localizedDescription)")
            return nil
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
            
            // Fade in noise to calculated volume based on RMS
            fadeIn(player: noisePlayer, targetVolume: calculatedNoiseVolume)
            
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
        mainPlayer.volume = 1.0  // Always full volume since audio is already normalized
        let success = mainPlayer.play()
        
        print("🎵 Main audio play called")
        print("   Success: \(success)")
        print("   Volume: \(mainPlayer.volume)")
        print("   Duration: \(mainPlayer.duration)s")
        print("   Is Playing: \(mainPlayer.isPlaying)")
        print("   Current Time: \(mainPlayer.currentTime)s")
        
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
    
    private func fadeIn(player: AVAudioPlayer, targetVolume: Float = 1.0) {
        player.volume = 0.0
        let steps = 20
        let stepDuration = fadeDuration / Double(steps)
        let volumeIncrement = targetVolume / Float(steps)
        
        var currentStep = 0
        fadeTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { [weak self] timer in
            currentStep += 1
            player.volume = min(volumeIncrement * Float(currentStep), targetVolume)
            
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
