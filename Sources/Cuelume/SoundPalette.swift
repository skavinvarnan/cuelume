//
//  SoundPalette.swift
//  Cuelume
//
//  The seventeen CueLume recipes, ported from
//  https://github.com/Danilaa1/cuelume/blob/main/src/sounds/recipes.ts
//

import Foundation

enum Waveform: Sendable {
    case sine
    case triangle
}

enum FilterKind: Sendable {
    case lowpass
    case bandpass
}

struct ToneLayer: Sendable {
    var waveform: Waveform
    var frequency: Double
    var attack: Double
    var decay: Double
    var peak: Double
    var offset: Double = 0
    var detune: Double = 0
    var glideTo: Double? = nil
    var glideTime: Double? = nil
}

struct NoiseLayer: Sendable {
    var filterType: FilterKind
    var filterFrequency: Double
    var attack: Double
    var decay: Double
    var peak: Double
    var offset: Double = 0
    var filterQ: Double = 1
}

enum SoundLayer: Sendable {
    case tone(ToneLayer)
    case noise(NoiseLayer)

    var offset: Double {
        switch self {
        case .tone(let layer): layer.offset
        case .noise(let layer): layer.offset
        }
    }

    var attack: Double {
        switch self {
        case .tone(let layer): layer.attack
        case .noise(let layer): layer.attack
        }
    }

    var decay: Double {
        switch self {
        case .tone(let layer): layer.decay
        case .noise(let layer): layer.decay
        }
    }
}

struct Shimmer: Sendable {
    var delay: Double
    var feedback: Double
    var wet: Double
    var lowpass: Double
}

struct SoundRecipe: Sendable {
    var masterGain: Double
    var layers: [SoundLayer]
    var shimmer: Shimmer? = nil
}

public enum SoundName: String, CaseIterable, Identifiable, Sendable {
    case chime
    case sparkle
    case droplet
    case bloom
    case whisper
    case tick
    case press
    case release
    case toggle
    case success
    case error
    case page
    case loading
    case ready
    case pulse
    case scan
    case arrival

    public var id: String { rawValue }

    public var detail: String {
        switch self {
        case .chime: "Soft two-note ascending bell"
        case .sparkle: "Quick four-note twinkle"
        case .droplet: "Single note gliding down"
        case .bloom: "Warm slow swell"
        case .whisper: "Soft hush with a falling tone"
        case .tick: "Crisp instant tick"
        case .press: "Dull muted knock"
        case .release: "Brighter springy tick"
        case .toggle: "Mechanical click-clack"
        case .success: "Warm three-note confirmation"
        case .error: "Soft knock and descending refusal"
        case .page: "Papery flick with a glass tick"
        case .loading: "Brief unresolved rising shimmer"
        case .ready: "Rising lock-on with a clear resolve"
        case .pulse: "Compact synthetic chirp"
        case .scan: "Fast three-step locator signal"
        case .arrival: "Rising harmonic portal"
        }
    }

    var recipe: SoundRecipe {
        switch self {
        case .chime:
            SoundRecipe(
                masterGain: 0.5,
                layers: [
                    .tone(ToneLayer(waveform: .sine, frequency: 1046.5, attack: 0.006, decay: 0.22, peak: 0.09)),
                    .tone(ToneLayer(waveform: .sine, frequency: 1568, attack: 0.006, decay: 0.26, peak: 0.08, offset: 0.09)),
                ],
                shimmer: Shimmer(delay: 0.12, feedback: 0.25, wet: 0.18, lowpass: 4000)
            )
        case .sparkle:
            SoundRecipe(
                masterGain: 0.5,
                layers: [
                    .tone(ToneLayer(waveform: .sine, frequency: 1760, attack: 0.003, decay: 0.09, peak: 0.045)),
                    .tone(ToneLayer(waveform: .sine, frequency: 2217, attack: 0.003, decay: 0.09, peak: 0.04, offset: 0.045)),
                    .tone(ToneLayer(waveform: .sine, frequency: 2637, attack: 0.003, decay: 0.1, peak: 0.038, offset: 0.09)),
                    .tone(ToneLayer(waveform: .sine, frequency: 3520, attack: 0.003, decay: 0.12, peak: 0.032, offset: 0.135)),
                ],
                shimmer: Shimmer(delay: 0.07, feedback: 0.35, wet: 0.22, lowpass: 6000)
            )
        case .droplet:
            SoundRecipe(
                masterGain: 0.55,
                layers: [
                    .tone(ToneLayer(waveform: .sine, frequency: 1200, attack: 0.004, decay: 0.2, peak: 0.075, glideTo: 550, glideTime: 0.14)),
                ],
                shimmer: Shimmer(delay: 0.09, feedback: 0.2, wet: 0.15, lowpass: 3000)
            )
        case .bloom:
            SoundRecipe(
                masterGain: 0.5,
                layers: [
                    .tone(ToneLayer(waveform: .sine, frequency: 528, attack: 0.06, decay: 0.32, peak: 0.06)),
                    .tone(ToneLayer(waveform: .sine, frequency: 528, attack: 0.06, decay: 0.34, peak: 0.05, detune: 12)),
                ],
                shimmer: Shimmer(delay: 0.15, feedback: 0.2, wet: 0.12, lowpass: 2500)
            )
        case .whisper:
            SoundRecipe(
                masterGain: 0.48,
                layers: [
                    .noise(NoiseLayer(filterType: .lowpass, filterFrequency: 1600, attack: 0.025, decay: 0.13, peak: 0.04, filterQ: 0.7)),
                    .tone(ToneLayer(waveform: .sine, frequency: 880, attack: 0.012, decay: 0.14, peak: 0.025, offset: 0.01, glideTo: 660, glideTime: 0.14)),
                ]
            )
        case .tick:
            SoundRecipe(
                masterGain: 0.4,
                layers: [
                    .noise(NoiseLayer(filterType: .bandpass, filterFrequency: 5400, attack: 0.001, decay: 0.018, peak: 0.14, filterQ: 1.8)),
                    .tone(ToneLayer(waveform: .sine, frequency: 2600, attack: 0.001, decay: 0.012, peak: 0.018)),
                ]
            )
        case .press:
            SoundRecipe(
                masterGain: 0.4,
                layers: [
                    .noise(NoiseLayer(filterType: .bandpass, filterFrequency: 1700, attack: 0.001, decay: 0.02, peak: 0.13, filterQ: 1.4)),
                ]
            )
        case .release:
            SoundRecipe(
                masterGain: 0.4,
                layers: [
                    .noise(NoiseLayer(filterType: .bandpass, filterFrequency: 4600, attack: 0.001, decay: 0.016, peak: 0.12, filterQ: 1.8)),
                    .tone(ToneLayer(waveform: .sine, frequency: 3200, attack: 0.001, decay: 0.05, peak: 0.02, offset: 0.006)),
                ]
            )
        case .toggle:
            SoundRecipe(
                masterGain: 0.4,
                layers: [
                    .noise(NoiseLayer(filterType: .bandpass, filterFrequency: 2200, attack: 0.001, decay: 0.016, peak: 0.12, filterQ: 1.6)),
                    .noise(NoiseLayer(filterType: .bandpass, filterFrequency: 3800, attack: 0.001, decay: 0.02, peak: 0.1, offset: 0.024, filterQ: 1.6)),
                ]
            )
        case .success:
            SoundRecipe(
                masterGain: 0.5,
                layers: [
                    .tone(ToneLayer(waveform: .sine, frequency: 880, attack: 0.004, decay: 0.09, peak: 0.06)),
                    .tone(ToneLayer(waveform: .sine, frequency: 1108.73, attack: 0.004, decay: 0.1, peak: 0.06, offset: 0.06)),
                    .tone(ToneLayer(waveform: .sine, frequency: 1318.51, attack: 0.004, decay: 0.18, peak: 0.07, offset: 0.12)),
                ],
                shimmer: Shimmer(delay: 0.1, feedback: 0.22, wet: 0.16, lowpass: 4500)
            )
        case .error:
            SoundRecipe(
                masterGain: 0.42,
                layers: [
                    .noise(NoiseLayer(filterType: .bandpass, filterFrequency: 850, attack: 0.001, decay: 0.035, peak: 0.13, filterQ: 1.1)),
                    .tone(ToneLayer(waveform: .triangle, frequency: 440, attack: 0.004, decay: 0.09, peak: 0.045, offset: 0.025)),
                    .tone(ToneLayer(waveform: .triangle, frequency: 349.23, attack: 0.004, decay: 0.14, peak: 0.04, offset: 0.1)),
                ]
            )
        case .page:
            SoundRecipe(
                masterGain: 0.38,
                layers: [
                    .noise(NoiseLayer(filterType: .lowpass, filterFrequency: 1800, attack: 0.006, decay: 0.08, peak: 0.11, filterQ: 0.7)),
                    .noise(NoiseLayer(filterType: .bandpass, filterFrequency: 4200, attack: 0.004, decay: 0.065, peak: 0.08, offset: 0.04, filterQ: 1.2)),
                    .tone(ToneLayer(waveform: .sine, frequency: 2400, attack: 0.002, decay: 0.045, peak: 0.02, offset: 0.075)),
                ]
            )
        case .loading:
            SoundRecipe(
                masterGain: 0.42,
                layers: [
                    .noise(NoiseLayer(filterType: .lowpass, filterFrequency: 1400, attack: 0.035, decay: 0.14, peak: 0.035, filterQ: 0.6)),
                    .tone(ToneLayer(waveform: .sine, frequency: 420, attack: 0.025, decay: 0.18, peak: 0.05, glideTo: 630, glideTime: 0.18)),
                ],
                shimmer: Shimmer(delay: 0.11, feedback: 0.18, wet: 0.12, lowpass: 2800)
            )
        case .ready:
            SoundRecipe(
                masterGain: 0.48,
                layers: [
                    .noise(NoiseLayer(filterType: .bandpass, filterFrequency: 3600, attack: 0.001, decay: 0.02, peak: 0.11, filterQ: 1.8)),
                    .tone(ToneLayer(waveform: .triangle, frequency: 330, attack: 0.004, decay: 0.16, peak: 0.055, offset: 0.012, glideTo: 660, glideTime: 0.12)),
                    .tone(ToneLayer(waveform: .sine, frequency: 990, attack: 0.004, decay: 0.22, peak: 0.06, offset: 0.13)),
                ],
                shimmer: Shimmer(delay: 0.1, feedback: 0.16, wet: 0.1, lowpass: 4200)
            )
        case .pulse:
            SoundRecipe(
                masterGain: 0.42,
                layers: [
                    .noise(NoiseLayer(filterType: .bandpass, filterFrequency: 2600, attack: 0.001, decay: 0.022, peak: 0.08, filterQ: 2.4)),
                    .tone(ToneLayer(waveform: .triangle, frequency: 620, attack: 0.002, decay: 0.085, peak: 0.055, glideTo: 1240, glideTime: 0.07)),
                ]
            )
        case .scan:
            SoundRecipe(
                masterGain: 0.4,
                layers: [
                    .tone(ToneLayer(waveform: .sine, frequency: 740, attack: 0.002, decay: 0.055, peak: 0.05)),
                    .tone(ToneLayer(waveform: .sine, frequency: 1110, attack: 0.002, decay: 0.055, peak: 0.045, offset: 0.045)),
                    .tone(ToneLayer(waveform: .sine, frequency: 1665, attack: 0.002, decay: 0.07, peak: 0.04, offset: 0.09)),
                ],
                shimmer: Shimmer(delay: 0.065, feedback: 0.16, wet: 0.1, lowpass: 4200)
            )
        case .arrival:
            SoundRecipe(
                masterGain: 0.44,
                layers: [
                    .noise(NoiseLayer(filterType: .lowpass, filterFrequency: 900, attack: 0.05, decay: 0.24, peak: 0.035, filterQ: 0.8)),
                    .tone(ToneLayer(waveform: .sine, frequency: 220, attack: 0.04, decay: 0.34, peak: 0.055, glideTo: 440, glideTime: 0.32)),
                    .tone(ToneLayer(waveform: .sine, frequency: 659.25, attack: 0.045, decay: 0.32, peak: 0.04, offset: 0.12)),
                    .tone(ToneLayer(waveform: .sine, frequency: 987.77, attack: 0.045, decay: 0.34, peak: 0.032, offset: 0.19)),
                ],
                shimmer: Shimmer(delay: 0.16, feedback: 0.28, wet: 0.18, lowpass: 3200)
            )
        }
    }
}

public enum SoundGroup: String, CaseIterable, Identifiable, Sendable {
    case melodic = "Melodic"
    case clicks = "Clicks"
    case status = "Status"
    case navigation = "Navigation"

    public var id: String { rawValue }

    public var sounds: [SoundName] {
        switch self {
        case .melodic: [.chime, .sparkle, .droplet, .bloom, .whisper]
        case .clicks: [.tick, .press, .release, .toggle]
        case .status: [.success, .error, .loading, .ready]
        case .navigation: [.page, .pulse, .scan, .arrival]
        }
    }
}
