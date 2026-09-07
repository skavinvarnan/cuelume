import Foundation
import Testing
@testable import Cuelume

// MARK: - Palette shape

@Test func cuelumePaletteHasSeventeenSounds() {
    #expect(SoundName.allCases.count == 17)
}

@Test func seslenPaletteHasThirtySixPresets() {
    #expect(SeslenSound.allCases.count == 36)
}

@Test func uisfxCatalogIsTwelvePacksBySeventyEightCues() {
    #expect(UISFXPack.allCases.count == 12)
    #expect(UISFXCue.allCases.count == 78)
}

@Test @MainActor func publicListsMatchTheCatalogs() {
    #expect(Cuelume.sounds == Array(SoundName.allCases))
    #expect(Cuelume.seslenSounds == Array(SeslenSound.allCases))
    #expect(Cuelume.uisfxCues == Array(UISFXCue.allCases))
    #expect(Cuelume.uisfxPacks == Array(UISFXPack.allCases))
}

@Test func groupsCoverTheWholeCuelumePalette() {
    let grouped = Set(SoundGroup.allCases.flatMap(\.sounds))
    #expect(grouped == Set(SoundName.allCases))
}

@Test func uisfxCategoriesCoverEveryCue() {
    let grouped = Set(UISFXCategory.allCases.flatMap(\.cues))
    #expect(grouped == Set(UISFXCue.allCases))
}

@Test func onlyTheLoopCategoryLoops() {
    let looping = Set(UISFXCue.allCases.filter(\.isLoop))
    #expect(looping == Set(UISFXCategory.loops.cues))
    #expect(looping.count == 6)
}

@Test func everyCueHasAUsableSuggestedVolume() {
    for cue in UISFXCue.allCases {
        #expect(cue.suggestedVolume > 0 && cue.suggestedVolume <= 1, "\(cue.rawValue)")
    }
}

// MARK: - Rendering

/// Renders are checked at a reduced rate where the count is large, to keep the
/// suite quick in a debug build; the synthesizers are rate-independent.
private let surveyRate = 22_050.0

private func check(_ sound: RenderedSound, _ label: String, minimumPeak: Float = 0.01) {
    #expect(sound.frameCount > 32, "\(label) produced \(sound.frameCount) frames")
    #expect(sound.left.count == sound.right.count, "\(label) channels differ in length")
    #expect(sound.peak > minimumPeak, "\(label) was silent (peak \(sound.peak))")
    #expect(sound.peak <= 1.0, "\(label) clipped (peak \(sound.peak))")
    #expect(sound.left.allSatisfy(\.isFinite), "\(label) produced a non-finite sample")
    #expect(sound.right.allSatisfy(\.isFinite), "\(label) produced a non-finite sample")
}

@Test func everyCuelumeSoundRendersAudibleSamples() {
    for name in SoundName.allCases {
        let samples = SoundSynthesizer.render(name.recipe, sampleRate: 44_100)
        check(RenderedSound(mono: samples, sampleRate: 44_100), name.rawValue)
    }
}

@Test func everySeslenPresetRendersAudibleSamples() {
    for sound in SeslenSound.allCases {
        // seslen recipes are deliberately quiet; `hover` peaks around 0.018.
        check(SeslenSynthesizer.render(sound.recipe), sound.rawValue, minimumPeak: 0.005)
    }
}

@Test func everyUISFXCueRendersAudibleSamples() {
    for cue in UISFXCue.allCases {
        let recipe = UISFXRecipeBuilder.recipe(pack: .minimal, cue: cue)
        check(UISFXSynthesizer.render(recipe, sampleRate: surveyRate), "minimal/\(cue.rawValue)")
    }
}

@Test func everyUISFXPackRendersAudibleSamples() {
    for pack in UISFXPack.allCases {
        for cue in [UISFXCue.press, .success, .swipe, .loading] {
            let recipe = UISFXRecipeBuilder.recipe(pack: pack, cue: cue)
            check(UISFXSynthesizer.render(recipe, sampleRate: surveyRate), "\(pack.rawValue)/\(cue.rawValue)")
        }
    }
}

@Test func uisfxRendersToItsNormalisationTarget() {
    // The renderer normalises to a fixed peak, so a one-shot lands on 0.42
    // unless the scale was clamped at 2.2x.
    let recipe = UISFXRecipeBuilder.recipe(pack: .glass, cue: .success)
    let rendered = UISFXSynthesizer.render(recipe)
    #expect(abs(rendered.peak - 0.42) < 0.01, "peak was \(rendered.peak)")
}

@Test func seededRenderersAreReproducible() {
    // Both ported libraries seed their noise, which is what lets the engine cache
    // a buffer and reuse it.
    let first = UISFXSynthesizer.render(UISFXRecipeBuilder.recipe(pack: .zen, cue: .press), sampleRate: surveyRate)
    let second = UISFXSynthesizer.render(UISFXRecipeBuilder.recipe(pack: .zen, cue: .press), sampleRate: surveyRate)
    #expect(first.left == second.left)
    #expect(first.right == second.right)

    let swoosh = SeslenSynthesizer.render(SeslenSound.swoosh.recipe)
    let swooshAgain = SeslenSynthesizer.render(SeslenSound.swoosh.recipe)
    #expect(swoosh.left == swooshAgain.left)
}

@Test func panningCuesDifferBetweenChannels() {
    // `swipe` sweeps hard left to hard right, so the channels must not match.
    let rendered = UISFXSynthesizer.render(UISFXRecipeBuilder.recipe(pack: .minimal, cue: .swipe))
    #expect(rendered.left != rendered.right)

    // A cue with no pan is centred, so both channels are identical.
    let centred = UISFXSynthesizer.render(UISFXRecipeBuilder.recipe(pack: .minimal, cue: .press))
    #expect(centred.left == centred.right)
}

@Test func seslenRendersFitTheirDeclaredDuration() {
    // Upstream's `durationMs` is a rounded-up hint for UIs, so a render should
    // land inside it without being wildly shorter.
    for sound in SeslenSound.allCases {
        let rendered = SeslenSynthesizer.render(sound.recipe)
        #expect(
            rendered.duration <= sound.duration + 0.005,
            "\(sound.rawValue): rendered \(rendered.duration)s exceeds the declared \(sound.duration)s"
        )
        #expect(
            rendered.duration >= sound.duration * 0.75,
            "\(sound.rawValue): rendered \(rendered.duration)s is far short of \(sound.duration)s"
        )
    }
}

// MARK: - Recipe details

@Test func uisfxPacksRetuneTheSameCue() {
    // A pack shifts pitch, so the same cue lands on different frequencies.
    let minimal = UISFXRecipeBuilder.recipe(pack: .minimal, cue: .drop)
    let cinematic = UISFXRecipeBuilder.recipe(pack: .cinematic, cue: .drop)
    #expect(minimal.notes[0].frequency > cinematic.notes[0].frequency)
    // Cinematic adds a weighted sub-octave under the body.
    #expect(cinematic.notes.count > minimal.notes.count)
}

@Test func zenIsTheOnlyPackWithMaterials() {
    for pack in UISFXPack.allCases {
        let recipe = UISFXRecipeBuilder.recipe(pack: pack, cue: .press)
        let hasMaterials = recipe.paper > 0 || recipe.brush > 0 || recipe.wood > 0 || recipe.chime > 0
        #expect(hasMaterials == (pack == .zen), "\(pack.rawValue)")
    }
}

@Test func seslenSweepsCarryTheFilterTheyDescribe() throws {
    let recipe = SeslenSound.shoot.recipe
    #expect(recipe.voices.count == 1)
    let filter = try #require(recipe.voices.first?.filter)
    #expect(filter.kind == .bandpass)
    #expect(filter.q == 12)
    #expect(filter.frequency.value(at: 0) == 5000)
    #expect(abs(filter.frequency.value(at: 0.12) - 500) < 1e-9)
}

@Test func seslenArpeggiosAreEvenlySpaced() {
    let victory = SeslenSound.victory.recipe
    #expect(victory.voices.count == 4)
    for (index, voice) in victory.voices.enumerated() {
        #expect(abs(voice.start - Double(index) * 0.09) < 1e-12)
    }
}

// MARK: - Automation

@Test func audioParamHoldsStepsAndInterpolatesRamps() {
    let param = AudioParam(default: 0.0001, events: [
        .setValue(0.0001, at: 0),
        .linearRamp(to: 0.13, at: 0.005),
        .exponentialRamp(to: 0.0001, at: 0.14),
    ])
    #expect(param.value(at: -1) == 0.0001)
    #expect(param.value(at: 0) == 0.0001)
    #expect(abs(param.value(at: 0.0025) - 0.06505) < 1e-9)
    #expect(abs(param.value(at: 0.005) - 0.13) < 1e-12)
    // Halfway through an exponential ramp is the geometric mean of its ends.
    #expect(abs(param.value(at: 0.0725) - (0.13 * (0.0001 / 0.13).squareRoot())) < 1e-9)
    // Past the last event the value is held.
    #expect(param.value(at: 5) == 0.0001)
}

@Test func audioParamHoldsUntilTheNextStep() {
    let param = AudioParam(default: 880, events: [
        .setValue(880, at: 0),
        .setValue(660, at: 0.16),
    ])
    #expect(param.value(at: 0.15) == 880)
    #expect(param.value(at: 0.16) == 660)
}

@Test func lowpassQIsReadInDecibels() {
    // Web Audio takes lowpass/highpass Q in dB, so gain at the cutoff is
    // 10^(Q/20) — 12 dB means about 4x, not 12x.
    func gainAtCutoff(q: Double) -> Double {
        let sampleRate = 44_100.0
        let cutoff = 1_000.0
        var filter = WebAudioBiquad(kind: .lowpass, frequency: cutoff, q: q, sampleRate: sampleRate)
        var peak: Float = 0
        for frame in 0..<20_000 {
            let phase = 2 * Double.pi * cutoff * Double(frame) / sampleRate
            let output = filter.process(Float(sin(phase)))
            if frame > 15_000 { peak = max(peak, abs(output)) }
        }
        return Double(peak)
    }
    #expect(abs(gainAtCutoff(q: 0) - 1) < 0.05)
    #expect(abs(gainAtCutoff(q: 12) - 3.98) < 0.2)
}

@Test func lowpassPassesDirectCurrent() {
    var filter = WebAudioBiquad(kind: .lowpass, frequency: 2_000, q: 1, sampleRate: 44_100)
    var last: Float = 0
    for _ in 0..<4_000 { last = filter.process(1) }
    #expect(abs(last - 1) < 0.001)
}

// MARK: - Cache

@Test func cacheReusesRendersAndEvictsTheOldest() {
    var cache = SoundCache(budget: 1)
    let first = cache.sound(for: .seslen(.tick), sampleRate: 44_100)
    #expect(cache.count == 1)

    // A one-byte budget keeps only the most recent sound.
    _ = cache.sound(for: .seslen(.pop), sampleRate: 44_100)
    #expect(cache.count == 1)

    // Seeded renders mean an evicted sound comes back identical.
    let again = cache.sound(for: .seslen(.tick), sampleRate: 44_100)
    #expect(again.left == first.left)
}

@Test func cacheKeepsSoundsWithinBudget() {
    var cache = SoundCache(budget: 8 * 1024 * 1024)
    for sound in SeslenSound.allCases {
        _ = cache.sound(for: .seslen(sound), sampleRate: 44_100)
    }
    #expect(cache.count == SeslenSound.allCases.count)
    #expect(cache.byteCount <= 8 * 1024 * 1024)
}

// MARK: - Identity

@Test func soundIdentifiersAreUniqueAcrossLibraries() {
    var ids = Set<String>()
    for sound in SoundName.allCases { ids.insert(CuelumeSound.cuelume(sound).id) }
    for sound in SeslenSound.allCases { ids.insert(CuelumeSound.seslen(sound).id) }
    for pack in UISFXPack.allCases {
        for cue in UISFXCue.allCases { ids.insert(CuelumeSound.uisfx(cue, pack: pack).id) }
    }
    let expected = 17 + 36 + 78 * 12
    #expect(ids.count == expected)
}

@Test func onlyUISFXLoopCuesReportLooping() {
    #expect(CuelumeSound.cuelume(.chime).isLoop == false)
    #expect(CuelumeSound.seslen(.alarm).isLoop == false)
    #expect(CuelumeSound.uisfx(.loading, pack: .glass).isLoop)
    #expect(CuelumeSound.uisfx(.press, pack: .glass).isLoop == false)
}
