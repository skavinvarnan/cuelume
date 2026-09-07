//
//  SoundSynthesizer.swift
//  Cuelume
//
//  Offline renderer matching CueLume's Web Audio graph:
//  oscillators + filtered noise + exponential envelopes + delay shimmer.
//  https://github.com/Danilaa1/cuelume/blob/main/src/audio/engine.ts
//

import Foundation

enum SoundSynthesizer {
    static let outputGain: Float = 4
    static let sourceStopPadding = 0.05
    static let cleanupMargin = 0.05
    static let inaudibleGain = 0.001
    private static let envelopeFloor = 0.0001

    static func duration(of recipe: SoundRecipe) -> Double {
        sourceEnd(recipe) + shimmerTail(recipe.shimmer) + cleanupMargin
    }

    static func render(_ recipe: SoundRecipe, sampleRate: Double) -> [Float] {
        let frames = max(1, Int((duration(of: recipe) * sampleRate).rounded(.up)))
        var mix = [Float](repeating: 0, count: frames)

        for layer in recipe.layers {
            switch layer {
            case .tone(let tone):
                renderTone(tone, into: &mix, sampleRate: sampleRate)
            case .noise(let noise):
                renderNoise(noise, into: &mix, sampleRate: sampleRate)
            }
        }

        let master = Float(recipe.masterGain)
        for i in mix.indices {
            mix[i] *= master
        }

        var output = mix
        if let shimmer = recipe.shimmer {
            applyShimmer(shimmer, dry: mix, into: &output, sampleRate: sampleRate)
        }

        var compressor = PeakCompressor(sampleRate: sampleRate)
        for i in output.indices {
            let boosted = compressor.process(output[i] * outputGain)
            output[i] = max(-1, min(1, boosted))
        }
        return output
    }

    private static func sourceEnd(_ recipe: SoundRecipe) -> Double {
        recipe.layers.map { $0.offset + $0.attack + $0.decay + sourceStopPadding }.max() ?? sourceStopPadding
    }

    private static func shimmerTail(_ shimmer: Shimmer?) -> Double {
        guard let shimmer, shimmer.feedback > 0 else { return 0 }
        if shimmer.feedback >= 1 { return shimmer.delay }
        let repeats = 1 + ceil(log(inaudibleGain) / log(shimmer.feedback))
        return shimmer.delay * repeats
    }

    private static func renderTone(_ layer: ToneLayer, into mix: inout [Float], sampleRate: Double) {
        let start = Int((layer.offset * sampleRate).rounded(.down))
        let length = max(1, Int(((layer.attack + layer.decay) * sampleRate).rounded(.up)))
        let detuneFactor = pow(2.0, layer.detune / 1200.0)
        let glideTime = layer.glideTime ?? (layer.attack + layer.decay)
        var phase = 0.0

        for i in 0..<length {
            let index = start + i
            guard index < mix.count else { break }
            let time = Double(i) / sampleRate
            var frequency = layer.frequency
            if let glideTo = layer.glideTo {
                frequency = exponential(from: layer.frequency, to: glideTo, time: time, duration: glideTime)
            }
            frequency *= detuneFactor
            let sample = waveform(layer.waveform, phase: phase)
            mix[index] += sample * envelope(time: time, attack: layer.attack, decay: layer.decay, peak: layer.peak)
            phase += frequency / sampleRate
            if phase >= 1 {
                phase -= floor(phase)
            }
        }
    }

    private static func renderNoise(_ layer: NoiseLayer, into mix: inout [Float], sampleRate: Double) {
        let start = Int((layer.offset * sampleRate).rounded(.down))
        let length = max(1, Int(((layer.attack + layer.decay + sourceStopPadding) * sampleRate).rounded(.up)))
        let cutoff = min(max(layer.filterFrequency, 10), sampleRate * 0.49)
        var filter = Biquad.filter(layer.filterType, frequency: cutoff, q: max(layer.filterQ, 0.0001), sampleRate: sampleRate)

        for i in 0..<length {
            let index = start + i
            guard index < mix.count else { break }
            let time = Double(i) / sampleRate
            let noise = Float.random(in: -1...1)
            let filtered = filter.process(noise)
            let env = time <= layer.attack + layer.decay
                ? envelope(time: time, attack: layer.attack, decay: layer.decay, peak: layer.peak)
                : Float(envelopeFloor)
            mix[index] += filtered * env
        }
    }

    private static func applyShimmer(_ shimmer: Shimmer, dry: [Float], into output: inout [Float], sampleRate: Double) {
        let delaySamples = max(1, Int((shimmer.delay * sampleRate).rounded()))
        var delay = [Float](repeating: 0, count: delaySamples)
        var write = 0
        let cutoff = min(max(shimmer.lowpass, 10), sampleRate * 0.49)
        var lowpass = Biquad.filter(.lowpass, frequency: cutoff, q: 1, sampleRate: sampleRate)
        let feedback = Float(shimmer.feedback)
        let wet = Float(shimmer.wet)

        for i in dry.indices {
            let delayed = delay[write]
            let filtered = lowpass.process(delayed)
            delay[write] = dry[i] + filtered * feedback
            write += 1
            if write == delaySamples { write = 0 }
            output[i] += filtered * wet
        }
    }

    private static func waveform(_ kind: Waveform, phase: Double) -> Float {
        let p = phase - floor(phase)
        switch kind {
        case .sine:
            return Float(sin(2 * Double.pi * p))
        case .triangle:
            if p < 0.25 { return Float(4 * p) }
            if p < 0.75 { return Float(2 - 4 * p) }
            return Float(4 * p - 4)
        }
    }

    private static func envelope(time: Double, attack: Double, decay: Double, peak: Double) -> Float {
        if time < attack {
            return Float(exponential(from: envelopeFloor, to: peak, time: time, duration: attack))
        }
        return Float(exponential(from: peak, to: envelopeFloor, time: time - attack, duration: decay))
    }

    private static func exponential(from: Double, to: Double, time: Double, duration: Double) -> Double {
        if duration <= 0 { return to }
        if time <= 0 { return from }
        if time >= duration { return to }
        guard from > 0, to > 0 else {
            return from + (to - from) * (time / duration)
        }
        return from * pow(to / from, time / duration)
    }
}

/// Transposed Direct Form II, coefficients from the Web Audio biquad cookbook.
private struct Biquad {
    var b0, b1, b2, a1, a2: Double
    var z1: Double = 0
    var z2: Double = 0

    mutating func process(_ input: Float) -> Float {
        let x = Double(input)
        let y = b0 * x + z1
        z1 = b1 * x - a1 * y + z2
        z2 = b2 * x - a2 * y
        return Float(y)
    }

    static func filter(_ kind: FilterKind, frequency: Double, q: Double, sampleRate: Double) -> Biquad {
        let w0 = 2 * Double.pi * frequency / sampleRate
        let cosw = cos(w0)
        let alpha = sin(w0) / (2 * q)
        let a0 = 1 + alpha
        switch kind {
        case .lowpass:
            let oneMinusCos = 1 - cosw
            return Biquad(
                b0: (oneMinusCos / 2) / a0,
                b1: oneMinusCos / a0,
                b2: (oneMinusCos / 2) / a0,
                a1: (-2 * cosw) / a0,
                a2: (1 - alpha) / a0
            )
        case .bandpass:
            return Biquad(
                b0: alpha / a0,
                b1: 0,
                b2: -alpha / a0,
                a1: (-2 * cosw) / a0,
                a2: (1 - alpha) / a0
            )
        }
    }
}

/// Peak compressor approximating CueLume's shared DynamicsCompressorNode.
private struct PeakCompressor {
    let threshold: Float = pow(10, -8 / 20)
    let ratio: Float = 12
    let attackCoeff: Float
    let releaseCoeff: Float
    var envelope: Float = 0

    init(sampleRate: Double) {
        attackCoeff = exp(-1 / Float(0.002 * sampleRate))
        releaseCoeff = exp(-1 / Float(0.08 * sampleRate))
    }

    mutating func process(_ input: Float) -> Float {
        let level = abs(input)
        let coeff = level > envelope ? attackCoeff : releaseCoeff
        envelope = coeff * envelope + (1 - coeff) * level
        guard envelope > threshold else { return input }
        let overDb = 20 * log10(envelope / threshold)
        let reductionDb = overDb - overDb / ratio
        return input * pow(10, -reductionDb / 20)
    }
}
