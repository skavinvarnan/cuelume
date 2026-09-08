//
//  UISFXRecipe.swift
//  Cuelume
//
//  Turns a (pack, cue) pair into a renderable recipe, ported from
//  https://github.com/romainsimon/uisfx/blob/main/packages/uisfx/src/recipes.ts
//
//  A cue supplies the note pattern and intent; a pack supplies the timbre and
//  rearranges those notes into its own character before they are pitched.
//

import Foundation

/// One note in a cue's pattern, before a pack has arranged it.
struct UISFXPatternNote: Sendable {
    var at: Double
    var semitone: Double
    var length: Double
    /// Pitch offset in semitones reached by the end of the note. `nil` means the
    /// cue did not ask for a glide, which some packs treat differently from zero.
    var glide: Double?
    var gain: Double = 1
}

/// A partial in a pack's tone: a frequency ratio and how loud it sits.
struct UISFXHarmonic: Sendable {
    var ratio: Double
    var amount: Double

    init(_ ratio: Double, _ amount: Double) {
        self.ratio = ratio
        self.amount = amount
    }
}

/// The cue half of a recipe: what happened, and the rhythm that says so.
struct UISFXCueDefinition: Sendable {
    var duration: Double
    var baseMidi: Double
    var notes: [UISFXPatternNote]
    var noise: Double
    var transient: Double
    var panFrom: Double
    var panTo: Double
    var loop: Bool
}

/// The pack half of a recipe: what it sounds like.
struct UISFXPackDefinition: Sendable {
    var waveform: Oscillator
    var pitch: Double
    var duration: Double
    var attack: Double
    var decay: Double
    var noise: Double
    var transient: Double
    var brightness: Double
    var echo: Double
    var bitDepth: Int
    var harmonics: [UISFXHarmonic]
    var fmRatio: Double = 1
    var fmDepth: Double = 0
    var elasticity: Double = 0
    var paper: Double = 0
    var brush: Double = 0
    var wood: Double = 0
    var chime: Double = 0
}

/// A note with its pitch resolved, ready for the renderer.
struct UISFXRenderNote: Sendable {
    var at: Double
    var length: Double
    var gain: Double
    var frequency: Double
    var endFrequency: Double
}

/// Everything the renderer needs for one (pack, cue) pair.
struct UISFXRecipe: Sendable {
    var cue: UISFXCue
    var pack: UISFXPack
    var duration: Double
    var notes: [UISFXRenderNote]
    var waveform: Oscillator
    var harmonics: [UISFXHarmonic]
    var attack: Double
    var decay: Double
    var noise: Double
    var transient: Double
    var brightness: Double
    var echo: Double
    var bitDepth: Int
    var panFrom: Double
    var panTo: Double
    var loop: Bool
    var fmRatio: Double
    var fmDepth: Double
    var elasticity: Double
    var paper: Double
    var brush: Double
    var wood: Double
    var chime: Double
}

enum UISFXRecipeBuilder {
    static func recipe(pack packName: UISFXPack, cue cueName: UISFXCue) -> UISFXRecipe {
        let cue = cueName.definition
        let pack = packName.definition
        let durationScale = cue.loop ? 1 : pack.duration
        let arranged = arrangeNotes(pack: packName, cue: cueName, source: cue.notes, loop: cue.loop)

        var notes = arranged.map { note -> UISFXRenderNote in
            let startMidi = cue.baseMidi + note.semitone + 12 * log2(pack.pitch)
            let endMidi = startMidi + (note.glide ?? 0)
            return UISFXRenderNote(
                at: note.at * durationScale,
                length: note.length * durationScale,
                gain: note.gain,
                frequency: midiToFrequency(startMidi),
                endFrequency: midiToFrequency(endMidi)
            )
        }

        var duration: Double
        if cue.loop {
            duration = cue.duration
        } else {
            duration = notes.reduce(cue.duration * durationScale) { max($0, $1.at + $1.length + 0.02) }
        }

        // One-shots are capped so a long pack tail still fits the asset budget the
        // catalog was authored against.
        let maximumOneShotBody = 1.5 - 0.024 - pack.echo * 1.6
        if !cue.loop, duration > maximumOneShotBody {
            let fit = (maximumOneShotBody - 0.02) / (duration - 0.02)
            notes = notes.map {
                var note = $0
                note.at *= fit
                note.length *= fit
                return note
            }
            duration = maximumOneShotBody
        }

        let isZen = packName == .zen
        var transient = min(
            1,
            cue.transient * (0.7 + pack.transient * 0.3) + pack.transient * 0.45
        ) * (cue.loop ? 0.58 : 1)
        if isZen {
            transient = min(0.12, transient * 0.28)
        }

        let fmDepth = pack.fmDepth * (cue.loop ? 0.58 : cueName.category == .reward ? 1.12 : 1)
        let elasticity = pack.elasticity
            * (cue.loop ? 0.18 : UISFXCueSets.rubberExpressiveCues.contains(cueName) ? 1 : 0.36)
        let materials = isZen ? zenMaterialMix(cueName) : ZenMaterials()

        // Texture is event-bound in the renderer, so a pack modulates the cue's own
        // texture rather than adding a permanent noise floor.
        let noise = isZen ? 0 : min(0.42, cue.noise * (0.55 + pack.noise) + pack.noise * 0.025)
        // Per-keystroke feedback has to finish before the next key event.
        let echo = cueName == .typing ? min(pack.echo, 0.004) : pack.echo

        return UISFXRecipe(
            cue: cueName,
            pack: packName,
            duration: duration,
            notes: notes,
            waveform: pack.waveform,
            harmonics: pack.harmonics,
            attack: pack.attack,
            decay: pack.decay,
            noise: noise,
            transient: transient,
            brightness: pack.brightness,
            echo: echo,
            bitDepth: pack.bitDepth,
            panFrom: cue.panFrom,
            panTo: cue.panTo,
            loop: cue.loop,
            fmRatio: pack.fmRatio,
            fmDepth: fmDepth,
            elasticity: elasticity,
            paper: pack.paper * materials.paper,
            brush: pack.brush * materials.brush,
            wood: pack.wood * materials.wood,
            chime: pack.chime * materials.chime
        )
    }

    private static func midiToFrequency(_ midi: Double) -> Double {
        440 * pow(2, (midi - 69) / 12)
    }

    /// JavaScript's `Math.round`, which breaks ties towards positive infinity rather
    /// than away from zero. Quantising packs depend on it for negative semitones.
    private static func jsRound(_ value: Double) -> Double {
        (value + 0.5).rounded(.down)
    }

    // MARK: - Arrangement

    private static func arrangeNotes(
        pack: UISFXPack,
        cue: UISFXCue,
        source: [UISFXPatternNote],
        loop: Bool
    ) -> [UISFXPatternNote] {
        let notes = source
        switch pack {
        case .minimal:
            return notes

        case .soft:
            return notes.enumerated().map { index, note in
                var note = note
                note.at = loop ? note.at : note.at * 1.06 + Double(index) * 0.006
                note.length *= 1.13
                note.semitone *= 0.94
                return note
            }

        case .glass:
            guard !loop, let last = notes.last, UISFXCueSets.shimmerCues.contains(cue) else { return notes }
            var octave = last
            octave.at = last.at + min(0.08, last.length * 0.28)
            octave.semitone = last.semitone + 12
            octave.length = last.length * 0.68
            octave.gain = last.gain * 0.18
            return notes + [octave]

        case .arcade:
            return notes.enumerated().map { index, note in
                var note = note
                note.at = loop ? note.at : jsRound(note.at / 0.04) * 0.04
                note.length = max(0.06, jsRound(note.length / 0.04) * 0.04) * 0.82
                note.semitone = jsRound(note.semitone) + (index % 2 == 1 ? 0.25 : 0)
                return note
            }

        case .mechanical:
            var result: [UISFXPatternNote] = []
            if !loop, UISFXCueSets.mechanicalDetentCues.contains(cue) {
                result.append(UISFXPatternNote(at: 0, semitone: -12, length: 0.055, glide: -3, gain: 0.28))
            }
            result += notes.map { note in
                var note = note
                note.length *= 0.62
                note.gain *= 0.82
                return note
            }
            return result

        case .organic:
            return notes.enumerated().flatMap { index, note -> [UISFXPatternNote] in
                var body = note
                body.at = loop ? note.at : note.at + Double(index) * 0.009
                body.semitone = note.semitone + (index % 2 == 0 ? -0.16 : 0.11)
                guard !loop, index == 0, UISFXCueSets.organicBodyCues.contains(cue) else { return [body] }
                var subOctave = note
                subOctave.at = note.at + 0.018
                subOctave.semitone = note.semitone - 12.08
                subOctave.length = note.length * 0.52
                subOctave.gain = note.gain * 0.2
                return [body, subOctave]
            }

        case .dreamy:
            return notes.enumerated().flatMap { index, note -> [UISFXPatternNote] in
                var body = note
                body.at = loop ? note.at : note.at * 1.08
                body.length = note.length * 1.18
                body.gain = note.gain * 0.78
                guard !loop, UISFXCueSets.shimmerCues.contains(cue) else { return [body] }
                var shimmer = note
                shimmer.at = note.at * 1.08 + 0.07 + Double(index) * 0.012
                shimmer.semitone = note.semitone + 12.02
                shimmer.length = note.length * 0.82
                shimmer.gain = note.gain * 0.13
                return [body, shimmer]
            }

        case .scifi:
            return notes.enumerated().map { index, note in
                var arranged = note
                arranged.at = loop ? note.at : jsRound(note.at / 0.01) * 0.01
                arranged.length = note.length * 0.72
                arranged.semitone = note.semitone + (index % 2 == 0 ? -0.04 : 0.16)
                arranged.glide = (note.glide ?? 0) * 0.58
                    + (note.glide == nil ? (index % 2 == 0 ? 0.45 : -0.25) : 0)
                arranged.gain = note.gain * (index == 0 ? 1 : 0.9)
                return arranged
            }

        case .rubber:
            return notes.enumerated().map { index, note in
                var arranged = note
                arranged.at = loop ? note.at : note.at * 0.98 + Double(index) * 0.004
                arranged.length = note.length * 0.84
                arranged.semitone = note.semitone + (index % 2 == 0 ? -0.18 : 0.08)
                arranged.glide = (note.glide ?? 0) * 0.52
                arranged.gain = note.gain * (index == 0 ? 1 : 0.88)
                return arranged
            }

        case .cinematic:
            var result = notes.map { note -> UISFXPatternNote in
                var note = note
                note.length *= 1.16
                note.gain *= 0.72
                return note
            }
            if !loop, !notes.isEmpty, UISFXCueSets.cinematicWeightCues.contains(cue) {
                // Deliberately measured against the unscaled lengths, as upstream does.
                let longest = notes.map(\.length).max() ?? 0
                result.append(UISFXPatternNote(
                    at: 0,
                    semitone: -24,
                    length: min(0.38, longest),
                    glide: -2,
                    gain: 0.28
                ))
            }
            return result

        case .studio:
            let body = notes.map { note -> UISFXPatternNote in
                var note = note
                note.at = loop ? note.at : note.at * 0.92
                note.length *= 0.82
                note.gain *= loop ? 0.55 : 0.8
                return note
            }
            guard !loop, let last = body.last else { return body }
            if UISFXCueSets.studioDetentCues.contains(cue) {
                let detent = UISFXPatternNote(at: 0, semitone: -12, length: 0.045, glide: -2, gain: 0.12)
                return [detent] + body
            }
            if UISFXCueSets.studioMilestoneCues.contains(cue) {
                var lift = last
                lift.at = last.at + 0.055
                lift.semitone = last.semitone + 12
                lift.length = last.length * 0.55
                lift.gain = last.gain * 0.1
                return body + [lift]
            }
            return body

        case .zen:
            let variation = zenVariation(cue, channel: 0)
            let isFrequent = UISFXCueSets.zenFrequentCues.contains(cue)
            let lengthScale = loop ? 0.68 : isFrequent ? 0.46 : 0.68
            return notes.enumerated().map { index, note in
                var arranged = note
                arranged.at = loop
                    ? note.at
                    : note.at * (0.9 + variation * 0.025) + Double(index) * 0.002
                arranged.length = note.length * lengthScale * (0.96 + variation * 0.05)
                arranged.semitone = note.semitone
                    + (variation - 0.5) * 0.22
                    + (index % 2 == 0 ? -0.035 : 0.025)
                arranged.glide = note.glide.map { $0 * 0.28 }
                arranged.gain = note.gain * (loop ? 0.32 : isFrequent ? 0.48 : 0.52)
                return arranged
            }
        }
    }

    // MARK: - Zen materials

    private struct ZenMaterials {
        var paper: Double = 0
        var brush: Double = 0
        var wood: Double = 0
        var chime: Double = 0
    }

    /// A stable per-cue variation in 0...1, so zen's handmade detail differs between
    /// cues without ever differing between runs.
    private static func zenVariation(_ cue: UISFXCue, channel: UInt32) -> Double {
        var hash: UInt32 = 2_166_136_261 ^ channel
        for unit in cue.rawValue.utf16 {
            hash ^= UInt32(unit)
            hash = hash &* 16_777_619
        }
        return Double(hash) / 4_294_967_295
    }

    private static func zenMaterialMix(_ cue: UISFXCue) -> ZenMaterials {
        ZenMaterials(
            paper: UISFXCueSets.zenPaperCues.contains(cue) ? 0.72 + zenVariation(cue, channel: 1) * 0.28 : 0,
            brush: UISFXCueSets.zenBrushCues.contains(cue) ? 0.68 + zenVariation(cue, channel: 2) * 0.32 : 0,
            wood: UISFXCueSets.zenWoodCues.contains(cue) ? 0.7 + zenVariation(cue, channel: 3) * 0.3 : 0,
            chime: UISFXCueSets.zenChimeCues.contains(cue) ? 0.64 + zenVariation(cue, channel: 4) * 0.36 : 0
        )
    }
}
