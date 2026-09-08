//
//  Cuelume.swift
//  Cuelume
//
//  Public API. `play()`, `setVolume()` and `setEnabled()` match the original JS
//  package; the `seslen:` and `uisfx:pack:` overloads reach the two libraries
//  added alongside it.
//

import Foundation
import Observation

/// Curated interaction sounds, synthesized live. No audio files.
///
/// Three palettes share one engine:
///
/// ```swift
/// import Cuelume
///
/// Cuelume.play(.success)                        // CueLume, 17 cues
/// Cuelume.play(seslen: .pop)                    // seslen, 36 presets
/// Cuelume.play(uisfx: .press, pack: .glass)     // uisfx, 78 cues x 12 packs
///
/// Cuelume.setVolume(0.7)
/// Cuelume.setEnabled(false)
/// ```
@MainActor
public enum Cuelume {
    /// The package version, matching the released tag.
    public static let version = "0.1.1"

    /// Plays a CueLume cue. Defaults to `chime`.
    /// `volume` is a 0...1 multiplier for this play only, on top of the global volume.
    @discardableResult
    public static func play(_ sound: SoundName = .chime, volume: Double? = nil) -> CuelumePlayer.Playback? {
        CuelumePlayer.shared.play(.cuelume(sound), volume: volume)
    }

    /// Plays a seslen preset.
    ///
    /// seslen's recipes are authored quieter than the CueLume palette — that is
    /// their design, and it is preserved here. Pass `volume:` to even them out.
    @discardableResult
    public static func play(seslen sound: SeslenSound, volume: Double? = nil) -> CuelumePlayer.Playback? {
        CuelumePlayer.shared.play(.seslen(sound), volume: volume)
    }

    /// Plays a uisfx cue in the given pack.
    ///
    /// Without an explicit `volume`, the cue's own `suggestedVolume` is used, which
    /// is what keeps `hover` quieter than `success` in the upstream catalog.
    @discardableResult
    public static func play(
        uisfx cue: UISFXCue,
        pack: UISFXPack,
        volume: Double? = nil
    ) -> CuelumePlayer.Playback? {
        CuelumePlayer.shared.play(.uisfx(cue, pack: pack), volume: volume ?? cue.suggestedVolume)
    }

    /// Plays any sound in the package.
    @discardableResult
    public static func play(_ sound: CuelumeSound, volume: Double? = nil) -> CuelumePlayer.Playback? {
        CuelumePlayer.shared.play(sound, volume: volume)
    }

    /// Stops one sound. Loop cues keep going until stopped this way.
    public static func stop(_ playback: CuelumePlayer.Playback) {
        CuelumePlayer.shared.stop(playback)
    }

    /// Stops everything currently sounding.
    public static func stopAll() {
        CuelumePlayer.shared.stopAll()
    }

    /// Renders these sounds now so their first play does not pay for it.
    /// Rendering is fast, but a long uisfx cue is still a millisecond or two.
    public static func prewarm(_ sounds: [CuelumeSound]) {
        CuelumePlayer.shared.prewarm(sounds)
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

    /// All seventeen CueLume sound names, in palette order.
    public static var sounds: [SoundName] { SoundName.allCases }

    /// All thirty-six seslen presets.
    public static var seslenSounds: [SeslenSound] { SeslenSound.allCases }

    /// All seventy-eight uisfx cues.
    public static var uisfxCues: [UISFXCue] { UISFXCue.allCases }

    /// All twelve uisfx packs.
    public static var uisfxPacks: [UISFXPack] { UISFXPack.allCases }
}

/// Observable player for SwiftUI. Prefer `Cuelume.play` when you don't need bindings.
@Observable
@MainActor
public final class CuelumePlayer {
    /// A sound that has started. Hold on to it to stop a loop.
    public struct Playback: Hashable, Sendable {
        let id: Int
    }

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
    public private(set) var nowPlaying: CuelumeSound?

    /// The CueLume cue currently playing, if the most recent sound came from that
    /// palette. `nowPlaying` covers all three libraries.
    public var playing: SoundName? {
        if case .cuelume(let sound) = nowPlaying { return sound }
        return nil
    }

    private let engine: AudioEngine
    private var playClearTask: Task<Void, Never>?

    public init() {
        engine = AudioEngine()
    }

    /// Plays a CueLume cue.
    @discardableResult
    public func play(_ sound: SoundName, volume: Double? = nil) -> Playback? {
        play(.cuelume(sound), volume: volume)
    }

    /// Plays any sound in the package.
    @discardableResult
    public func play(_ sound: CuelumeSound, volume: Double? = nil) -> Playback? {
        guard isEnabled else { return nil }
        let playVolume = clamped(self.volume) * clamped(volume ?? 1)
        guard playVolume > 0 else { return nil }
        guard let started = engine.play(sound, volume: playVolume) else { return nil }

        nowPlaying = sound
        playClearTask?.cancel()
        playClearTask = nil
        // Loop cues sound until they are stopped, so there is nothing to time out.
        guard !sound.isLoop else { return started.playback }

        playClearTask = Task { @MainActor [weak self] in
            let nanos = UInt64(max(started.duration, 0.05) * 1_000_000_000)
            try? await Task.sleep(nanoseconds: nanos)
            guard !Task.isCancelled else { return }
            if self?.nowPlaying == sound {
                self?.nowPlaying = nil
            }
        }
        return started.playback
    }

    /// Stops one sound.
    public func stop(_ playback: Playback) {
        engine.stop(playback)
        if !engine.isSounding {
            clearIfIdle()
        }
    }

    /// Stops everything currently sounding.
    public func stopAll() {
        engine.stopAll()
        playClearTask?.cancel()
        playClearTask = nil
        nowPlaying = nil
    }

    /// Renders these sounds now, so their first play is immediate.
    public func prewarm(_ sounds: [CuelumeSound]) {
        for sound in sounds {
            engine.prewarm(sound)
        }
    }

    /// Drops every cached buffer. The next play of a sound re-renders it.
    public func clearCache() {
        engine.clearCache()
    }

    private func clearIfIdle() {
        playClearTask?.cancel()
        playClearTask = nil
        nowPlaying = nil
    }

    private func clamped(_ value: Double) -> Double {
        guard value.isFinite else { return 0 }
        return min(1, max(0, value))
    }
}
