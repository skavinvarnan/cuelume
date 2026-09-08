//
//  SeslenVoice.swift
//  Cuelume
//
//  seslen's presets are small Web Audio graphs: an oscillator or noise burst,
//  optionally through a biquad, into a gain with a scheduled envelope. This is
//  that graph as data, so each preset can be transcribed line for line from
//  https://github.com/productdevbook/seslen/tree/main/src/presets
//

import Foundation

/// A biquad in a preset's chain, with a cutoff that may sweep.
struct SeslenFilter: Sendable {
    var kind: WebAudioFilterKind
    var q: Double
    var frequency: AudioParam
}

/// One source-to-gain chain. A preset is one or more of these mixed together.
struct SeslenVoice: Sendable {
    enum Source: Sendable {
        case oscillator(Oscillator)
        /// A white-noise buffer of this length. Past its end the source is silent,
        /// matching an AudioBufferSourceNode that has run out of buffer.
        case noise(bufferDuration: Double)
    }

    var source: Source
    /// When the source starts, in seconds from the beginning of the sound.
    var start: Double
    /// When the source is stopped.
    var stop: Double
    var frequency: AudioParam
    var gain: AudioParam
    var filter: SeslenFilter?

    init(
        _ source: Source,
        start: Double,
        stop: Double,
        frequency: AudioParam = AudioParam(constant: 440),
        gain: AudioParam,
        filter: SeslenFilter? = nil
    ) {
        self.source = source
        self.start = start
        self.stop = stop
        self.frequency = frequency
        self.gain = gain
        self.filter = filter
    }
}

/// A preset: the voices to mix, and how long the whole thing runs.
struct SeslenRecipe: Sendable {
    var sound: SeslenSound
    var voices: [SeslenVoice]

    /// The last moment any voice is still running.
    var duration: Double {
        voices.reduce(0) { max($0, $1.stop) }
    }
}

// MARK: - Recipe shorthand

extension AudioParam {
    /// The envelope every seslen preset uses: step to a near-silent floor, ramp up
    /// linearly, optionally hold, then ramp exponentially back down. Times are
    /// offsets from `start`, exactly as the upstream recipes write them.
    static func envelope(
        start: Double,
        peak: Double,
        attack: Double,
        release: Double,
        hold: Double? = nil,
        floor: Double = 0.0001
    ) -> AudioParam {
        var events: [AudioParamEvent] = [
            .setValue(floor, at: start),
            .linearRamp(to: peak, at: start + attack),
        ]
        if let hold {
            events.append(.setValue(peak, at: start + hold))
        }
        events.append(.exponentialRamp(to: floor, at: start + release))
        return AudioParam(default: floor, events: events)
    }

    /// A pitch that does not move.
    static func pitch(_ hertz: Double, at time: Double = 0) -> AudioParam {
        AudioParam(default: hertz, events: [.setValue(hertz, at: time)])
    }

    /// A pitch that glides exponentially, the shape most seslen presets use.
    static func glide(
        from: Double,
        to target: Double,
        start: Double = 0,
        over duration: Double
    ) -> AudioParam {
        AudioParam(default: from, events: [
            .setValue(from, at: start),
            .exponentialRamp(to: target, at: start + duration),
        ])
    }

    /// A pitch that slides linearly.
    static func slide(
        from: Double,
        to target: Double,
        start: Double = 0,
        over duration: Double
    ) -> AudioParam {
        AudioParam(default: from, events: [
            .setValue(from, at: start),
            .linearRamp(to: target, at: start + duration),
        ])
    }
}
