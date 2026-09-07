//
//  AudioEngine.swift
//  Cuelume
//
//  Plays synthesized buffers through a shared AVAudioEngine.
//

import AVFoundation

@MainActor
final class AudioEngine {
    private let engine = AVAudioEngine()
    private let format: AVAudioFormat
    private var buffers: [SoundName: AVAudioPCMBuffer] = [:]
    private var idlePlayers: [AVAudioPlayerNode] = []

    init() {
        format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        buffers = Self.renderAll(format: format)
        for _ in 0..<4 {
            idlePlayers.append(makePlayer())
        }
        engine.prepare()
    }

    /// Returns the buffer duration in seconds if playback started.
    func play(_ name: SoundName, volume: Double) -> Double? {
        guard let buffer = buffers[name] else { return nil }
        do {
            try activateSession()
            if !engine.isRunning {
                try engine.start()
            }
        } catch {
            return nil
        }

        let player = checkoutPlayer()
        player.volume = Float(volume)
        player.scheduleBuffer(buffer)
        player.play()

        let duration = Double(buffer.frameLength) / buffer.format.sampleRate
        Task { @MainActor [weak self] in
            let nanos = UInt64((duration + 0.05) * 1_000_000_000)
            try? await Task.sleep(nanoseconds: nanos)
            self?.recycle(player)
        }
        return duration
    }

    private func activateSession() throws {
        #if os(iOS) || os(tvOS) || os(visionOS)
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try session.setActive(true)
        #endif
    }

    private func checkoutPlayer() -> AVAudioPlayerNode {
        if let player = idlePlayers.popLast() {
            return player
        }
        return makePlayer()
    }

    private func recycle(_ player: AVAudioPlayerNode) {
        player.stop()
        if !idlePlayers.contains(where: { $0 === player }) {
            idlePlayers.append(player)
        }
    }

    private func makePlayer() -> AVAudioPlayerNode {
        let player = AVAudioPlayerNode()
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        return player
    }

    private static func renderAll(format: AVAudioFormat) -> [SoundName: AVAudioPCMBuffer] {
        var result: [SoundName: AVAudioPCMBuffer] = [:]
        result.reserveCapacity(SoundName.allCases.count)
        for name in SoundName.allCases {
            let samples = SoundSynthesizer.render(name.recipe, sampleRate: format.sampleRate)
            result[name] = makeBuffer(samples: samples, format: format)
        }
        return result
    }

    private static func makeBuffer(samples: [Float], format: AVAudioFormat) -> AVAudioPCMBuffer {
        let frames = AVAudioFrameCount(samples.count)
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: max(frames, 1))!
        buffer.frameLength = frames
        samples.withUnsafeBufferPointer { source in
            guard let baseAddress = source.baseAddress, let channel = buffer.floatChannelData?[0] else { return }
            channel.update(from: baseAddress, count: samples.count)
        }
        return buffer
    }
}
