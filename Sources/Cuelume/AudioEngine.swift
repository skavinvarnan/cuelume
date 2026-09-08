//
//  AudioEngine.swift
//  Cuelume
//
//  Plays synthesized buffers through a shared AVAudioEngine. Buffers are stereo
//  (uisfx cues pan) and are rendered on first use rather than up front, because
//  the catalog is now close to a thousand sounds.
//

import AVFoundation

@MainActor
final class AudioEngine {
    typealias Playback = CuelumePlayer.Playback

    /// How many player nodes may be sounding at once. Beyond this the oldest is
    /// stolen, which keeps a burst of taps from attaching nodes without limit.
    private static let voiceLimit = 16

    private let engine = AVAudioEngine()
    private let format: AVAudioFormat
    private var cache = SoundCache()

    private var idlePlayers: [AVAudioPlayerNode] = []
    /// Sounding players, oldest first.
    private var active: [(playback: Playback, player: AVAudioPlayerNode)] = []
    private var attachedPlayerCount = 0
    private var nextPlaybackID = 1
    #if os(iOS) || os(tvOS) || os(visionOS)
    private var hasConfiguredSession = false
    #endif

    init() {
        // Force-unwrapped because these arguments are always a valid format.
        format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 2)!
        // Do not prepare() here. It initializes the I/O graph against the hardware
        // format and throws an NSException if the audio session is not active yet —
        // which it isn't when CuelumePlayer.shared is first touched from a SwiftUI
        // view during the first layout pass.
    }

    /// Renders a sound now so the first play does not pay for it.
    func prewarm(_ sound: CuelumeSound) {
        _ = cache.sound(for: sound, sampleRate: format.sampleRate)
    }

    func clearCache() {
        cache.removeAll()
    }

    /// Starts a sound. Returns a handle and the buffer's duration, or `nil` if the
    /// engine could not be started.
    func play(_ sound: CuelumeSound, volume: Double) -> (playback: Playback, duration: Double)? {
        let rendered = cache.sound(for: sound, sampleRate: format.sampleRate)
        guard rendered.frameCount > 0, let buffer = makeBuffer(rendered) else { return nil }

        do {
            try ensureRunning()
        } catch {
            return nil
        }

        let playback = Playback(id: nextPlaybackID)
        nextPlaybackID += 1
        let player = checkoutPlayer()
        player.volume = Float(volume)
        active.append((playback, player))

        if sound.isLoop {
            // Loop cues are authored to meet end to end, so they need no crossfade.
            player.scheduleBuffer(buffer, at: nil, options: .loops, completionCallbackType: .dataPlayedBack) { _ in }
        } else {
            player.scheduleBuffer(buffer, at: nil, options: [], completionCallbackType: .dataPlayedBack) { [weak self] _ in
                Task { @MainActor in
                    self?.finish(playback)
                }
            }
        }
        player.play()
        return (playback, rendered.duration)
    }

    /// Stops one sound. Safe to call for a playback that already finished.
    func stop(_ playback: Playback) {
        finish(playback)
    }

    func stopAll() {
        for entry in active {
            recycle(entry.player)
        }
        active.removeAll()
    }

    /// Whether anything at all is still sounding.
    var isSounding: Bool { !active.isEmpty }

    // MARK: - Players

    private func finish(_ playback: Playback) {
        guard let index = active.firstIndex(where: { $0.playback == playback }) else { return }
        let entry = active.remove(at: index)
        recycle(entry.player)
    }

    private func checkoutPlayer() -> AVAudioPlayerNode {
        if let player = idlePlayers.popLast() {
            return player
        }
        if attachedPlayerCount >= Self.voiceLimit, !active.isEmpty {
            // Steal the oldest voice rather than growing the graph without bound.
            let oldest = active.removeFirst()
            oldest.player.stop()
            oldest.player.reset()
            return oldest.player
        }
        return makePlayer()
    }

    private func recycle(_ player: AVAudioPlayerNode) {
        player.stop()
        player.reset()
        if !idlePlayers.contains(where: { $0 === player }) {
            idlePlayers.append(player)
        }
    }

    private func makePlayer() -> AVAudioPlayerNode {
        let player = AVAudioPlayerNode()
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        attachedPlayerCount += 1
        return player
    }

    // MARK: - Session and buffers

    /// Session first, then a node, then start. Starting an empty graph, or
    /// preparing before the session is active, throws an NSException that Swift
    /// `try` cannot catch.
    private func ensureRunning() throws {
        try configureSessionIfNeeded()
        if attachedPlayerCount == 0 {
            idlePlayers.append(makePlayer())
        }
        if !engine.isRunning {
            try engine.start()
        }
    }

    /// Configured once rather than on every play, which used to reassert the
    /// category and reactivate the session for each tap.
    private func configureSessionIfNeeded() throws {
        #if os(iOS) || os(tvOS) || os(visionOS)
        guard !hasConfiguredSession else { return }
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try session.setActive(true)
        hasConfiguredSession = true
        #endif
    }

    private func makeBuffer(_ rendered: RenderedSound) -> AVAudioPCMBuffer? {
        let frames = AVAudioFrameCount(rendered.frameCount)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: max(frames, 1)),
              let channels = buffer.floatChannelData
        else { return nil }
        buffer.frameLength = frames
        rendered.left.withUnsafeBufferPointer { source in
            guard let base = source.baseAddress else { return }
            channels[0].update(from: base, count: rendered.left.count)
        }
        rendered.right.withUnsafeBufferPointer { source in
            guard let base = source.baseAddress else { return }
            channels[1].update(from: base, count: rendered.right.count)
        }
        return buffer
    }
}
