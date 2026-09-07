import Testing
@testable import Cuelume

@Test func paletteHasSeventeenSounds() {
    #expect(SoundName.allCases.count == 17)
}

@Test @MainActor func publicSoundsListMatchesPalette() {
    #expect(Cuelume.sounds == Array(SoundName.allCases))
}

@Test func everySoundRendersAudibleSamples() {
    for name in SoundName.allCases {
        let samples = SoundSynthesizer.render(name.recipe, sampleRate: 44_100)
        let peak = samples.map { abs($0) }.max() ?? 0
        #expect(samples.count > 100, "\(name.rawValue) produced too few samples")
        #expect(peak > 0.01, "\(name.rawValue) was silent (peak \(peak))")
        #expect(peak <= 1.0, "\(name.rawValue) clipped (peak \(peak))")
    }
}

@Test func groupsCoverTheWholePalette() {
    let grouped = Set(SoundGroup.allCases.flatMap(\.sounds))
    #expect(grouped == Set(SoundName.allCases))
}
