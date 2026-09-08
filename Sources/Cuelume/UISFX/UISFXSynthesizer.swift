//
//  UISFXSynthesizer.swift
//  Cuelume
//
//  Offline renderer ported from
//  https://github.com/romainsimon/uisfx/blob/main/packages/uisfx/src/synth.ts
//
//  Layers a harmonic tone, event-bound noise texture, a transient, and — for the
//  zen pack — struck material models, then pans, echoes and normalises the result.
//  The noise is seeded per (pack, cue), so a given sound renders identically every
//  time, exactly as it does in the JavaScript original.
//

import Foundation

enum UISFXSynthesizer {
    static func render(_ recipe: UISFXRecipe, sampleRate: Double = 44_100) -> RenderedSound {
        let finalNoteEnd = recipe.notes.reduce(0.0) { max($0, $1.at + $1.length) }
        // Very short per-keystroke cues need extra digital silence so the transient
        // is not smeared into the end of the buffer.
        let cleanHold = recipe.cue == .typing ? 0.048 : 0.024
        let bodyDuration = recipe.loop
            ? recipe.duration
            : min(recipe.duration, finalNoteEnd + (recipe.pack == .zen ? 0.12 : 0.06))
        let tail = recipe.loop ? 0 : cleanHold + recipe.echo * 1.6
        let frameCount = max(1, Int(((bodyDuration + tail) * sampleRate).rounded()))

        var left = [Float](repeating: 0, count: frameCount)
        var right = [Float](repeating: 0, count: frameCount)

        var random = SeededRandom(seed: "\(recipe.pack.rawValue):\(recipe.cue.rawValue)")
        var materialRandom = SeededRandom(seed: "\(recipe.pack.rawValue):\(recipe.cue.rawValue):materials")
        var phases = [Double](repeating: 0, count: recipe.notes.count)

        var lowNoise = 0.0
        var paperNoise = 0.0
        var brushNoise = 0.0
        var brushBody = 0.0

        let effectiveAttack = recipe.loop ? max(0.0018, recipe.attack) : recipe.attack
        let hasMaterials = recipe.paper > 0 || recipe.brush > 0 || recipe.wood > 0 || recipe.chime > 0
        let isZen = recipe.pack == .zen

        let cutoff = 520 + recipe.brightness * 4_800
        let smoothing = 1 - exp(-2 * Double.pi * cutoff / sampleRate)
        let transientDecayRate = 105 + recipe.brightness * 170

        for frame in 0..<frameCount {
            let time = Double(frame) / sampleRate
            var tonal = 0.0
            var textureEnvelope = 0.0
            var transientEnvelope = 0.0
            var material = 0.0

            for (index, note) in recipe.notes.enumerated() {
                let localTime = time - note.at
                // A note's phase only advances while it sounds.
                guard localTime >= 0, localTime <= note.length else { continue }

                let progress = localTime / note.length
                let glideFrequency = note.frequency * pow(note.endFrequency / note.frequency, progress)
                let elasticSemitones = recipe.elasticity
                    * exp(-localTime * 19)
                    * cos(2 * Double.pi * 12.5 * localTime)
                let frequency = glideFrequency * pow(2, elasticSemitones / 12)
                phases[index] += 2 * Double.pi * frequency / sampleRate
                let phase = phases[index]

                let phaseModulation = recipe.fmDepth > 0
                    ? sin(phase * recipe.fmRatio) * recipe.fmDepth * exp(-localTime * 7.5)
                    : 0

                var voice = 0.0
                for harmonic in recipe.harmonics {
                    voice += recipe.waveform.sample(
                        phase: phase * harmonic.ratio + phaseModulation,
                        phaseDelta: min(0.49, frequency * harmonic.ratio / sampleRate)
                    ) * harmonic.amount
                }

                tonal += voice * envelope(
                    time: localTime,
                    length: note.length,
                    attack: effectiveAttack,
                    decay: recipe.decay
                ) * note.gain

                textureEnvelope += envelope(
                    time: localTime,
                    length: note.length,
                    attack: min(0.004, effectiveAttack),
                    decay: max(2.35, recipe.decay * 1.25)
                ) * note.gain

                let transientAttack = 1 - exp(-localTime * 800)
                transientEnvelope += transientAttack * exp(-localTime * transientDecayRate) * note.gain
            }

            // Both generators advance every frame whether or not their output is used,
            // which is what keeps the seeded noise aligned with the original.
            let rawNoise = random.nextBipolar()
            let materialRaw = materialRandom.nextBipolar()
            paperNoise += (materialRaw - paperNoise) * 0.08
            brushNoise += (materialRaw - brushNoise) * 0.018
            brushBody += (materialRaw - brushBody) * 0.004
            let paperGrain = paperNoise - brushNoise
            let brushGrain = brushNoise - brushBody

            if hasMaterials {
                for note in recipe.notes {
                    let localTime = time - note.at
                    if localTime < 0 { continue }
                    material += materialSample(
                        recipe: recipe,
                        note: note,
                        localTime: localTime,
                        paperGrain: paperGrain,
                        brushGrain: brushGrain
                    )
                }
            }

            lowNoise += (rawNoise - lowNoise) * smoothing
            let highNoise = rawNoise - lowNoise
            let textureNoise = highNoise * (0.52 + recipe.brightness * 0.28)
                + lowNoise * (0.18 - recipe.brightness * 0.08)
            let texture = textureNoise * recipe.noise * min(1.4, textureEnvelope)
            let transient = highNoise * recipe.transient * min(1.35, transientEnvelope)

            var sample = tonal * (isZen ? 0.58 : 0.62)
                + texture * (isZen ? 0.1 : 0.32)
                + transient * (isZen ? 0.08 : 0.3)
                + material * (isZen ? 0.34 : 0)

            if recipe.bitDepth < 16 {
                let levels = pow(2, Double(recipe.bitDepth))
                sample = (sample * levels).rounded() / levels
            }

            let panProgress = min(1, time / max(recipe.duration, 0.001))
            let pan = recipe.loop
                ? (recipe.panFrom + recipe.panTo) / 2
                    - (recipe.panTo - recipe.panFrom) / 2 * cos(2 * Double.pi * panProgress)
                : recipe.panFrom + (recipe.panTo - recipe.panFrom) * panProgress
            let angle = (pan + 1) * Double.pi / 4
            let limited = isZen ? sample : softLimit(sample)
            left[frame] = Float(limited * cos(angle))
            right[frame] = Float(limited * sin(angle))
        }

        if recipe.echo > 0, !recipe.loop {
            // Written in place, so each tap feeds the next — a comb, not a single slap.
            let delayFrames = Int((0.035 + recipe.echo * 0.38) * sampleRate)
            let amount = Float(min(0.22, recipe.echo * 1.65))
            if delayFrames > 0, delayFrames < frameCount {
                for frame in delayFrames..<frameCount {
                    left[frame] += left[frame - delayFrames] * amount
                    right[frame] += right[frame - delayFrames] * amount
                }
            }
        }

        if !recipe.loop {
            let fadeFrames = min(frameCount, Int((0.028 * sampleRate).rounded()))
            let fadeStart = frameCount - fadeFrames
            for frame in fadeStart..<frameCount {
                let remaining = Double(frameCount - 1 - frame) / Double(max(1, fadeFrames - 1))
                let gain = Float(pow(sin(remaining * Double.pi / 2), 2))
                left[frame] *= gain
                right[frame] *= gain
            }
        }

        // Generous headroom: short bright transients overshoot easily, and every
        // library in this package aims at the same peak range.
        var peak: Float = 0
        for frame in 0..<frameCount {
            peak = max(peak, abs(left[frame]), abs(right[frame]))
        }
        let scale = peak > 0 ? min(2.2, Float(targetPeak(for: recipe)) / peak) : 1
        if scale != 1 {
            for frame in 0..<frameCount {
                left[frame] *= scale
                right[frame] *= scale
            }
        }

        return RenderedSound(left: left, right: right, sampleRate: sampleRate)
    }

    private static func targetPeak(for recipe: UISFXRecipe) -> Double {
        let isZen = recipe.pack == .zen
        if recipe.cue == .typing { return isZen ? 0.15 : 0.28 }
        if isZen {
            if recipe.loop { return 0.18 }
            return recipe.cue == .hover ? 0.15 : 0.28
        }
        if recipe.loop { return 0.32 }
        return recipe.cue == .hover ? 0.3 : 0.42
    }

    /// Struck-material detail used only by the zen pack: folded paper, a brush
    /// stroke, a wooden block, and a small chime.
    private static func materialSample(
        recipe: UISFXRecipe,
        note: UISFXRenderNote,
        localTime: Double,
        paperGrain: Double,
        brushGrain: Double
    ) -> Double {
        var material = 0.0

        if recipe.paper > 0 {
            let length = min(note.length, 0.075, max(0.028, note.length * 0.62))
            if localTime <= length {
                let progress = localTime / length
                let fold = pow(sin(Double.pi * progress), 1.1) * (1 - progress * 0.48)
                let firstCrease = exp(-pow((localTime - length * 0.24) / 0.003, 2))
                let secondCrease = exp(-pow((localTime - length * 0.64) / 0.005, 2))
                material += paperGrain * recipe.paper * fold
                    * (0.16 + firstCrease * 0.52 + secondCrease * 0.24)
            }
        }

        if recipe.brush > 0 {
            let length = min(note.length, 0.11, max(0.045, note.length * 0.95))
            if localTime <= length {
                let progress = localTime / length
                let stroke = pow(sin(Double.pi * progress), 1.3)
                material += brushGrain * recipe.brush * stroke * (0.42 + progress * 0.08)
            }
        }

        if recipe.wood > 0 {
            let length = min(note.length, 0.22, max(0.09, note.length * 0.8))
            if localTime <= length {
                let onset = 1 - exp(-localTime * 480)
                let decay = exp(-localTime * 18)
                let fundamental = sin(2 * Double.pi * note.frequency * 0.31 * localTime)
                let grain = sin(2 * Double.pi * note.frequency * 0.47 * localTime + 0.3) * 0.34
                material += (fundamental + grain) * recipe.wood * onset * decay
            }
        }

        if recipe.chime > 0 {
            let length = min(note.length, 0.42, max(0.16, note.length * 1.25))
            if localTime <= length {
                let onset = 1 - exp(-localTime * 520)
                let decay = exp(-localTime * 7.4)
                let shimmer = sin(2 * Double.pi * note.frequency * 2.01 * localTime)
                    + sin(2 * Double.pi * note.frequency * 3.87 * localTime + 0.4) * 0.28
                material += shimmer * recipe.chime * onset * decay
            }
        }

        return material
    }

    private static func envelope(time: Double, length: Double, attack: Double, decay: Double) -> Double {
        if time < 0 || time > length { return 0 }
        if time < attack { return time / max(attack, 0.0001) }
        let progress = (time - attack) / max(length - attack, 0.0001)
        return pow(max(0, 1 - progress), decay)
    }

    private static func softLimit(_ value: Double) -> Double {
        tanh(value * 1.2) / tanh(1.2)
    }
}
