//
//  CuelumeSound.swift
//  Cuelume
//
//  One address for every sound in the package, whichever library it came from.
//

import Foundation

/// Any sound Cuelume can play.
///
/// You rarely need to build one by hand — `Cuelume.play(_:)`,
/// `Cuelume.play(seslen:)` and `Cuelume.play(uisfx:pack:)` take the library's own
/// type. Use `CuelumeSound` when you want to store a choice, or accept any cue.
///
/// ```swift
/// let cue: CuelumeSound = .uisfx(.success, pack: .glass)
/// Cuelume.play(cue)
/// ```
public enum CuelumeSound: Hashable, Sendable {
    /// One of the seventeen original CueLume cues.
    case cuelume(SoundName)
    /// One of seslen's presets.
    case seslen(SeslenSound)
    /// A uisfx cue rendered in one of its packs.
    case uisfx(UISFXCue, pack: UISFXPack)

    /// A stable identifier, unique across libraries.
    public var id: String {
        switch self {
        case .cuelume(let sound): "cuelume/\(sound.rawValue)"
        case .seslen(let sound): "seslen/\(sound.rawValue)"
        case .uisfx(let cue, let pack): "uisfx/\(pack.rawValue)/\(cue.rawValue)"
        }
    }

    /// A short human description of the sound.
    public var detail: String {
        switch self {
        case .cuelume(let sound): sound.detail
        case .seslen(let sound): sound.detail
        case .uisfx(let cue, _): cue.detail
        }
    }

    /// Whether the sound repeats until stopped. Only some uisfx cues do.
    public var isLoop: Bool {
        switch self {
        case .cuelume, .seslen: false
        case .uisfx(let cue, _): cue.isLoop
        }
    }

    /// Renders the sound. Pure and deterministic apart from the CueLume palette,
    /// whose noise layers are drawn fresh each time, as they were originally.
    func render(sampleRate: Double) -> RenderedSound {
        switch self {
        case .cuelume(let sound):
            RenderedSound(
                mono: SoundSynthesizer.render(sound.recipe, sampleRate: sampleRate),
                sampleRate: sampleRate
            )
        case .seslen(let sound):
            SeslenSynthesizer.render(sound.recipe, sampleRate: sampleRate)
        case .uisfx(let cue, let pack):
            UISFXSynthesizer.render(
                UISFXRecipeBuilder.recipe(pack: pack, cue: cue),
                sampleRate: sampleRate
            )
        }
    }
}
