//
//  RenderedSound.swift
//  Cuelume
//
//  The stereo PCM result every synthesizer hands back to the engine.
//

import Foundation

/// A rendered cue: deinterleaved stereo float samples plus the rate they were written at.
struct RenderedSound: Sendable {
    var left: [Float]
    var right: [Float]
    var sampleRate: Double

    var frameCount: Int { left.count }
    var duration: Double { sampleRate > 0 ? Double(left.count) / sampleRate : 0 }

    /// Bytes held by both channels, used by the engine's cache budget.
    var byteCount: Int { (left.count + right.count) * MemoryLayout<Float>.size }

    init(left: [Float], right: [Float], sampleRate: Double) {
        self.left = left
        self.right = right
        self.sampleRate = sampleRate
    }

    /// Sends one mono signal to both channels. Used by the CueLume and seslen renderers,
    /// which are mono by construction.
    init(mono samples: [Float], sampleRate: Double) {
        self.init(left: samples, right: samples, sampleRate: sampleRate)
    }

    var peak: Float {
        var peak: Float = 0
        for sample in left { peak = max(peak, abs(sample)) }
        for sample in right { peak = max(peak, abs(sample)) }
        return peak
    }
}
