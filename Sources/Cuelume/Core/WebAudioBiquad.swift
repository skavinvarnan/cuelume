//
//  WebAudioBiquad.swift
//  Cuelume
//
//  A biquad matching BiquadFilterNode's coefficients, including its quirk that
//  `Q` is read in decibels for lowpass and highpass but as a plain quality
//  factor for bandpass.
//  https://webaudio.github.io/web-audio-api/#filters-characteristics
//
//  The CueLume renderer keeps its own private biquad; this one exists for the
//  uisfx and seslen ports, whose recipes assume Web Audio's exact response.
//

import Foundation

enum WebAudioFilterKind: Sendable {
    case lowpass
    case highpass
    case bandpass
}

/// Transposed Direct Form II biquad whose coefficients can be retuned per sample,
/// which is what a filter with an automated cutoff needs.
struct WebAudioBiquad: Sendable {
    private var b0: Double = 1
    private var b1: Double = 0
    private var b2: Double = 0
    private var a1: Double = 0
    private var a2: Double = 0
    private var z1: Double = 0
    private var z2: Double = 0

    private let kind: WebAudioFilterKind

    init(kind: WebAudioFilterKind, frequency: Double, q: Double, sampleRate: Double) {
        self.kind = kind
        tune(frequency: frequency, q: q, sampleRate: sampleRate)
    }

    /// Recomputes the coefficients for a new cutoff. Filter state is deliberately
    /// preserved so a sweeping cutoff stays continuous.
    mutating func tune(frequency: Double, q: Double, sampleRate: Double) {
        let nyquist = sampleRate / 2
        let cutoff = min(max(frequency, 10), nyquist * 0.98)
        let w0 = 2 * Double.pi * cutoff / sampleRate
        let cosw = cos(w0)
        let sinw = sin(w0)

        // Web Audio reads Q in dB for lowpass/highpass and linearly for bandpass.
        let alpha: Double
        switch kind {
        case .lowpass, .highpass:
            alpha = sinw / (2 * pow(10, q / 20))
        case .bandpass:
            alpha = sinw / (2 * max(q, 0.0001))
        }

        let a0 = 1 + alpha
        switch kind {
        case .lowpass:
            let oneMinusCos = 1 - cosw
            b0 = (oneMinusCos / 2) / a0
            b1 = oneMinusCos / a0
            b2 = (oneMinusCos / 2) / a0
        case .highpass:
            let onePlusCos = 1 + cosw
            b0 = (onePlusCos / 2) / a0
            b1 = -onePlusCos / a0
            b2 = (onePlusCos / 2) / a0
        case .bandpass:
            b0 = alpha / a0
            b1 = 0
            b2 = -alpha / a0
        }
        a1 = (-2 * cosw) / a0
        a2 = (1 - alpha) / a0
    }

    mutating func process(_ input: Float) -> Float {
        let x = Double(input)
        let y = b0 * x + z1
        z1 = b1 * x - a1 * y + z2
        z2 = b2 * x - a2 * y
        return Float(y)
    }
}
