//
//  SeslenSynthesizer.swift
//  Cuelume
//
//  Renders a seslen recipe offline by walking each voice's automation timeline
//  the way Web Audio would: source -> optional biquad -> gain -> mix.
//

import Foundation

enum SeslenSynthesizer {
    static func render(_ recipe: SeslenRecipe, sampleRate: Double = 44_100) -> RenderedSound {
        let duration = recipe.duration
        let frameCount = max(1, Int((duration * sampleRate).rounded(.up)))
        var mix = [Float](repeating: 0, count: frameCount)

        for (index, voice) in recipe.voices.enumerated() {
            render(voice, index: index, of: recipe, into: &mix, sampleRate: sampleRate)
        }

        return RenderedSound(mono: mix, sampleRate: sampleRate)
    }

    private static func render(
        _ voice: SeslenVoice,
        index: Int,
        of recipe: SeslenRecipe,
        into mix: inout [Float],
        sampleRate: Double
    ) {
        let firstFrame = max(0, Int((voice.start * sampleRate).rounded(.down)))
        let lastFrame = min(mix.count, Int((voice.stop * sampleRate).rounded(.up)))
        guard firstFrame < lastFrame else { return }

        var filter = voice.filter.map {
            WebAudioBiquad(
                kind: $0.kind,
                frequency: $0.frequency.value(at: voice.start),
                q: $0.q,
                sampleRate: sampleRate
            )
        }
        // Seeded so a preset renders identically every time and the buffer can be cached.
        var noise = SeededRandom(seed: "seslen:\(recipe.sound.rawValue):\(index)")
        var phase = 0.0

        for frame in firstFrame..<lastFrame {
            let time = Double(frame) / sampleRate

            var sample: Double
            switch voice.source {
            case .oscillator(let waveform):
                let frequency = voice.frequency.value(at: time)
                sample = waveform.sample(phase: phase, phaseDelta: frequency / sampleRate)
                phase = (phase + 2 * Double.pi * frequency / sampleRate)
                    .truncatingRemainder(dividingBy: 2 * Double.pi)
            case .noise(let bufferDuration):
                // An AudioBufferSourceNode goes silent once its buffer runs out, even
                // though the node itself is stopped later.
                let elapsed = time - voice.start
                sample = elapsed < bufferDuration ? noise.nextBipolar() : 0
            }

            if let spec = voice.filter {
                filter?.tune(frequency: spec.frequency.value(at: time), q: spec.q, sampleRate: sampleRate)
                if let filtered = filter?.process(Float(sample)) {
                    sample = Double(filtered)
                }
            }

            mix[frame] += Float(sample * voice.gain.value(at: time))
        }
    }
}
