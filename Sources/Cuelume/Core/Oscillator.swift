//
//  Oscillator.swift
//  Cuelume
//
//  Waveforms shared by the uisfx and seslen renderers. Square and saw are
//  band-limited with polyBLEP; triangle is generated directly, whose harmonics
//  fall off fast enough (1/n^2) that aliasing stays inaudible at cue pitches.
//

import Foundation

enum Oscillator: Sendable {
    case sine
    case triangle
    case square
    case saw

    /// - Parameters:
    ///   - phase: Phase in radians.
    ///   - phaseDelta: Normalised phase advance per sample (frequency / sampleRate),
    ///     used to size the polyBLEP correction around discontinuities.
    func sample(phase: Double, phaseDelta: Double) -> Double {
        let normalized = phase / (2 * Double.pi)
        let cycle = normalized - floor(normalized)
        switch self {
        case .sine:
            return sin(phase)
        case .triangle:
            return 2 * abs(2 * (normalized - floor(normalized + 0.5))) - 1
        case .square:
            let raw: Double = cycle < 0.5 ? 1 : -1
            return raw + Self.polyBlep(cycle, phaseDelta)
                - Self.polyBlep((cycle + 0.5).truncatingRemainder(dividingBy: 1), phaseDelta)
        case .saw:
            return 2 * cycle - 1 - Self.polyBlep(cycle, phaseDelta)
        }
    }

    /// Two-point polynomial band-limited step, smoothing the jump at a waveform edge.
    private static func polyBlep(_ time: Double, _ delta: Double) -> Double {
        guard delta > 0, delta < 0.5 else { return 0 }
        if time < delta {
            let progress = time / delta
            return progress + progress - progress * progress - 1
        }
        if time > 1 - delta {
            let progress = (time - 1) / delta
            return progress * progress + progress + progress + 1
        }
        return 0
    }
}
