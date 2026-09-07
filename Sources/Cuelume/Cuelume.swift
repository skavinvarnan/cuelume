//
//  Cuelume.swift
//  Cuelume
//
//  Public API matching the original JS package: play(), setVolume(), setEnabled().
//

import Foundation
import Observation

/// Curated interaction sounds, synthesized live. No audio files.
///
/// ```swift
/// import Cuelume
///
/// Cuelume.play(.success)
/// Cuelume.setVolume(0.7)
/// Cuelume.setEnabled(false)
/// ```
@MainActor
public enum Cuelume {
    /// Plays a sound immediately. Defaults to `chime`.
    /// `volume` is a 0...1 multiplier for this play only, on top of the global volume.
    public static func play(_ sound: SoundName = .chime, volume: Double? = nil) {
        CuelumePlayer.shared.play(sound, volume: volume)
    }

    /// Global loudness for future playback, clamped to 0...1.
    public static func setVolume(_ volume: Double) {
        CuelumePlayer.shared.volume = volume
    }

    /// When `false`, later `play` calls become no-ops. Does not persist.
    public static func setEnabled(_ enabled: Bool) {
        CuelumePlayer.shared.isEnabled = enabled
    }

    /// Current global volume, 0...1.
    public static var volume: Double {
        get { CuelumePlayer.shared.volume }
        set { CuelumePlayer.shared.volume = newValue }
    }

    /// Whether future playback is allowed.
    public static var isEnabled: Bool {
        get { CuelumePlayer.shared.isEnabled }
        set { CuelumePlayer.shared.isEnabled = newValue }
    }

    /// All seventeen sound names, in palette order.
    public static var sounds: [SoundName] { SoundName.allCases }
}

/// Observable player for SwiftUI. Prefer `Cuelume.play` when you don't need bindings.
@Observable
@MainActor
public final class CuelumePlayer {
    public static let shared = CuelumePlayer()

    /// Global loudness, clamped to 0...1. Starts at 1, like the JS package.
    public var volume: Double = 1 {
        didSet {
            if volume != clamped(volume) {
                volume = clamped(volume)
            }
        }
    }

    /// When `false`, `play` is a no-op.
    public var isEnabled = true

    /// The sound most recently triggered, or `nil` once it has finished.
    public private(set) var playing: SoundName?

    private let engine: AudioEngine
    private var playClearTask: Task<Void, Never>?

    public init() {
        engine = AudioEngine()
    }

    public func play(_ sound: SoundName, volume: Double? = nil) {
        guard isEnabled else { return }
        let playVolume = clamped(self.volume) * clamped(volume ?? 1)
        guard playVolume > 0 else { return }
        guard let duration = engine.play(sound, volume: playVolume) else { return }

        playing = sound
        playClearTask?.cancel()
        playClearTask = Task { @MainActor [weak self] in
            let nanos = UInt64(max(duration, 0.05) * 1_000_000_000)
            try? await Task.sleep(nanoseconds: nanos)
            guard !Task.isCancelled else { return }
            if self?.playing == sound {
                self?.playing = nil
            }
        }
    }

    private func clamped(_ value: Double) -> Double {
        guard value.isFinite else { return 0 }
        return min(1, max(0, value))
    }
}
