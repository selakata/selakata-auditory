//
//  AudioService.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//

import Foundation
import AVFoundation

@MainActor
class AudioService: ObservableObject {
    private var engine: AVAudioEngine!
    private var sourceNode: AVAudioSourceNode!
    private var mixer: AVAudioMixerNode!

    private var sampleRate: Double = 44100.0
    private var time: Double = 0.0
    private var frequency: Double = 500.0
    private var amplitude: Float = 0.0
    private var pan: Float = 0.0

    private var currentPulseTask: Task<Void, Never>?

    private let minDBFS: Float = -80
    private let maxDBFS: Float = -6

    init() {
        setupAudioEngine()
    }

    private func setupAudioEngine() {
        engine = AVAudioEngine()
        mixer = engine.mainMixerNode
        sampleRate = mixer.outputFormat(forBus: 0).sampleRate

        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                   sampleRate: sampleRate,
                                   channels: 2,
                                   interleaved: false)!

        sourceNode = AVAudioSourceNode(format: format) { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }
            let abl = UnsafeMutableAudioBufferListPointer(audioBufferList)
            guard abl.count >= 2 else { return noErr }

            // compute equal-power panning gains
            let clampedPan = min(max(self.pan, -1.0), 1.0)
            let angle = (Double(clampedPan) + 1.0) * (.pi / 4.0)
            let leftGain = Float(cos(angle))
            let rightGain = Float(sin(angle))

            // generate the beep sound
            let angularFrequency = 2.0 * .pi * self.frequency
            let leftPtr = abl[0].mData?.assumingMemoryBound(to: Float.self)
            let rightPtr = abl[1].mData?.assumingMemoryBound(to: Float.self)
            guard let leftBuffer = leftPtr, let rightBuffer = rightPtr else { return noErr }

            let sr = Float(self.sampleRate)
            var t = Float(self.time)

            for frame in 0..<Int(frameCount) {
                let wave = sin(Float(angularFrequency) * t)
                let value = wave * self.amplitude
                leftBuffer[frame] = value * leftGain
                rightBuffer[frame] = value * rightGain
                t += 1.0 / sr
            }
            self.time = Double(t)
            return noErr
        }

        engine.attach(sourceNode)
        engine.connect(sourceNode, to: mixer, format: format)

        do {
            try engine.start()
        } catch {
            print("AudioService: Failed to start engine: \(error)")
        }
    }

    func playPulsedTone(frequency: Double, dbfs: Float, pan: Float) {
            stopTone()

            self.time = 0.0
            self.frequency = frequency
            self.pan = pan

            let clampedDbfs = min(max(dbfs, minDBFS), maxDBFS)
            let targetAmplitude = pow(10.0, clampedDbfs / 20.0)

            currentPulseTask = Task {
                let pulseDuration: TimeInterval = 0.5
                let pauseDuration: TimeInterval = 0.5

                do {
                    // Pulse 1
                    try Task.checkCancellation()
                    await MainActor.run { [weak self] in self?.amplitude = targetAmplitude }
                    try await Task.sleep(nanoseconds: UInt64(pulseDuration * 1_000_000_000))
                    
                    // Pause 1
                    try Task.checkCancellation()
                    await MainActor.run { [weak self] in self?.amplitude = 0.0 }
                    try await Task.sleep(nanoseconds: UInt64(pauseDuration * 1_000_000_000))
                    
                    // Pulse 2
                    try Task.checkCancellation()
                    await MainActor.run { [weak self] in self?.amplitude = targetAmplitude }
                    try await Task.sleep(nanoseconds: UInt64(pulseDuration * 1_000_000_000))
                    
                    // Pause 2
                    try Task.checkCancellation()
                    await MainActor.run { [weak self] in self?.amplitude = 0.0 }
                    try await Task.sleep(nanoseconds: UInt64(pauseDuration * 1_000_000_000))
                    
                    // Pulse 3
                    try Task.checkCancellation()
                    await MainActor.run { [weak self] in self?.amplitude = targetAmplitude }
                    try await Task.sleep(nanoseconds: UInt64(pulseDuration * 1_000_000_000))
                    
                    await MainActor.run { [weak self] in self?.amplitude = 0.0 }
                    
                } catch {
                    await MainActor.run { [weak self] in self?.amplitude = 0.0 }
                }
            }
        }

    func stopTone() {
        currentPulseTask?.cancel()
        currentPulseTask = nil
        amplitude = 0.0
    }

    func stopEngine() {
        stopTone()
        engine.stop()
    }
}
