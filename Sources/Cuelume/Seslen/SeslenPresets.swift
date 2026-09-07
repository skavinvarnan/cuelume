//
//  SeslenPresets.swift
//  Cuelume
//
//  The 36 seslen presets, transcribed from their upstream factories:
//  https://github.com/productdevbook/seslen/tree/main/src/presets
//
//  Per-call `rate`, `detune` and `gain` are all 1/0 here, because Cuelume applies
//  loudness at the engine instead. Levels are otherwise exactly as authored — the
//  seslen recipes are deliberately quieter than the CueLume and uisfx palettes.
//

import Foundation

extension SeslenSound {
    var recipe: SeslenRecipe {
        SeslenRecipe(sound: self, voices: voices)
    }

    private var voices: [SeslenVoice] {
        switch self {
        case .add:
            [SeslenVoice(
                .oscillator(.sine), start: 0, stop: 0.16,
                frequency: .slide(from: 880, to: 1480, over: 0.08),
                gain: .envelope(start: 0, peak: 0.13, attack: 0.005, release: 0.14)
            )]

        case .alarm:
            // Four two-tone cycles under one sustained envelope.
            [SeslenVoice(
                .oscillator(.square), start: 0, stop: 0.84,
                frequency: AudioParam(default: 880, events: (0..<4).flatMap { cycle -> [AudioParamEvent] in
                    let low = Double(cycle) * 0.18
                    return [.setValue(880, at: low), .setValue(660, at: low + 0.09)]
                }),
                gain: .envelope(start: 0, peak: 0.12, attack: 0.01, release: 0.82, hold: 0.78)
            )]

        case .coin:
            Self.sequence(.square, notes: [(988, 0), (1320, 0.04)],
                          peak: 0.12, attack: 0.005, release: 0.14, tail: 0.16)

        case .collapse:
            [SeslenVoice(
                .oscillator(.sine), start: 0, stop: 0.22,
                frequency: .glide(from: 990, to: 330, over: 0.18),
                gain: .envelope(start: 0, peak: 0.1, attack: 0.02, release: 0.2)
            )]

        case .copy:
            Self.sequence(.sine, notes: [(1480, 0), (1480, 0.05)],
                          peak: 0.1, attack: 0.003, release: 0.04, tail: 0.05)

        case .delete:
            [Self.sweep(noiseFor: 0.2, stop: 0.22, kind: .lowpass, q: 4,
                        from: 4000, to: 400, over: 0.18,
                        peak: 0.18, attack: 0.01, release: 0.2)]

        case .drag:
            [SeslenVoice(
                .oscillator(.sine), start: 0, stop: 0.14,
                frequency: .slide(from: 440, to: 660, over: 0.1),
                gain: .envelope(start: 0, peak: 0.08, attack: 0.02, release: 0.12)
            )]

        case .drop:
            [SeslenVoice(
                .oscillator(.sine), start: 0, stop: 0.15,
                frequency: .glide(from: 220, to: 110, over: 0.1),
                gain: .envelope(start: 0, peak: 0.16, attack: 0.005, release: 0.13)
            )]

        case .error:
            [SeslenVoice(
                .oscillator(.square), start: 0, stop: 0.28,
                frequency: .slide(from: 220, to: 150, over: 0.22),
                gain: .envelope(start: 0, peak: 0.12, attack: 0.01, release: 0.26)
            )]

        case .expand:
            [SeslenVoice(
                .oscillator(.sine), start: 0, stop: 0.22,
                frequency: .glide(from: 330, to: 990, over: 0.18),
                gain: .envelope(start: 0, peak: 0.1, attack: 0.02, release: 0.2)
            )]

        case .explosion:
            [Self.sweep(noiseFor: 0.6, stop: 0.62, kind: .lowpass, q: 1,
                        from: 2000, to: 100, over: 0.55,
                        peak: 0.22, attack: 0.01, release: 0.6)]

        case .heartbeat:
            [0, 0.18].map { offset in
                SeslenVoice(
                    .oscillator(.sine), start: offset, stop: offset + 0.18,
                    frequency: .glide(from: 60, to: 40, start: offset, over: 0.14),
                    gain: .envelope(start: offset, peak: 0.22, attack: 0.01, release: 0.16)
                )
            }

        case .hover:
            [Self.blip(.sine, hertz: 2400, peak: 0.018, attack: 0.005, release: 0.025, stop: 0.03)]

        case .jump:
            [SeslenVoice(
                .oscillator(.square), start: 0, stop: 0.12,
                frequency: .glide(from: 220, to: 880, over: 0.08),
                gain: .envelope(start: 0, peak: 0.1, attack: 0.005, release: 0.1)
            )]

        case .keypress:
            [Self.blip(.square, hertz: 1800, peak: 0.06, attack: 0.002, release: 0.012, stop: 0.014)]

        case .levelUp:
            // C5 D5 E5 G5 C6
            Self.arpeggio([523.25, 587.33, 659.25, 783.99, 1046.5],
                          step: 0.09, peak: 0.16, attack: 0.008, release: 0.22, tail: 0.24)

        case .lock:
            Self.sequence(.square, notes: [(320, 0), (220, 0.06)],
                          peak: 0.14, attack: 0.003, release: 0.06, tail: 0.08)

        case .message:
            [
                SeslenVoice(
                    .oscillator(.sine), start: 0, stop: 0.3,
                    frequency: .pitch(880),
                    gain: .envelope(start: 0, peak: 0.14, attack: 0.01, release: 0.28)
                ),
                SeslenVoice(
                    .oscillator(.sine), start: 0.08, stop: 0.42,
                    frequency: .pitch(1320, at: 0.08),
                    gain: .envelope(start: 0.08, peak: 0.14 * 0.85, attack: 0.01, release: 0.32)
                ),
            ]

        case .notify:
            Self.sequence(.sine, notes: [(660, 0), (880, 0.1), (1320, 0.2)],
                          peak: 0.13, attack: 0.01, release: 0.16, tail: 0.18)

        case .paste:
            [SeslenVoice(
                .oscillator(.sine), start: 0, stop: 0.1,
                frequency: .pitch(880),
                gain: .envelope(start: 0, peak: 0.1, attack: 0.005, release: 0.08, hold: 0.05)
            )]

        case .pop:
            [SeslenVoice(
                .oscillator(.triangle), start: 0, stop: 0.1,
                frequency: .glide(from: 1200, to: 320, over: 0.08),
                gain: .envelope(start: 0, peak: 0.12, attack: 0.005, release: 0.09)
            )]

        case .receive:
            [SeslenVoice(
                .oscillator(.sine), start: 0, stop: 0.24,
                frequency: .slide(from: 1320, to: 880, over: 0.18),
                gain: .envelope(start: 0, peak: 0.12, attack: 0.02, release: 0.22)
            )]

        case .redo:
            [SeslenVoice(
                .oscillator(.triangle), start: 0, stop: 0.2,
                frequency: .slide(from: 520, to: 880, over: 0.16),
                gain: .envelope(start: 0, peak: 0.1, attack: 0.01, release: 0.18)
            )]

        case .scrollTick:
            [Self.blip(.triangle, hertz: 3000, peak: 0.04, attack: 0.001, release: 0.006, stop: 0.008)]

        case .send:
            [Self.sweep(noiseFor: 0.22, stop: 0.24, kind: .highpass, q: 3,
                        from: 600, to: 4000, over: 0.2,
                        peak: 0.18, attack: 0.03, release: 0.22)]

        case .shoot:
            [Self.sweep(noiseFor: 0.13, stop: 0.14, kind: .bandpass, q: 12,
                        from: 5000, to: 500, over: 0.12,
                        peak: 0.18, attack: 0.005, release: 0.13)]

        case .success:
            [SeslenVoice(
                .oscillator(.triangle), start: 0, stop: 0.34,
                frequency: AudioParam(default: 660, events: [
                    .setValue(660, at: 0),
                    .linearRamp(to: 990, at: 0.08),
                    .linearRamp(to: 1320, at: 0.18),
                ]),
                gain: .envelope(start: 0, peak: 0.18, attack: 0.01, release: 0.32)
            )]

        case .swoosh:
            [Self.sweep(noiseFor: 0.24, stop: 0.26, kind: .bandpass, q: 6,
                        from: 400, to: 4000, over: 0.22,
                        peak: 0.16, attack: 0.04, release: 0.24)]

        case .tick:
            // Upstream jitters the pitch with Math.random on every play. Cuelume
            // renders each cue once and caches it, so the draw is seeded instead.
            [SeslenVoice(
                .oscillator(.sine), start: 0, stop: 0.005,
                frequency: .pitch(4000 + Self.tickJitter * 400),
                gain: .envelope(start: 0, peak: 0.035, attack: 0.001, release: 0.003, floor: 0.001)
            )]

        case .toggleOff:
            Self.sequence(.sine, notes: [(1100, 0), (700, 0.05)],
                          peak: 0.1, attack: 0.005, release: 0.06, tail: 0.08)

        case .toggleOn:
            Self.sequence(.sine, notes: [(700, 0), (1100, 0.05)],
                          peak: 0.1, attack: 0.005, release: 0.06, tail: 0.08)

        case .typewriter:
            [Self.blip(.triangle, hertz: 2600, peak: 0.05, attack: 0.001, release: 0.008, stop: 0.01)]

        case .undo:
            [SeslenVoice(
                .oscillator(.triangle), start: 0, stop: 0.2,
                frequency: .slide(from: 880, to: 520, over: 0.16),
                gain: .envelope(start: 0, peak: 0.1, attack: 0.01, release: 0.18)
            )]

        case .unlock:
            Self.sequence(.triangle, notes: [(220, 0), (440, 0.06)],
                          peak: 0.12, attack: 0.003, release: 0.06, tail: 0.08)

        case .victory:
            // C5 E5 G5 C6
            Self.arpeggio([523.25, 659.25, 783.99, 1046.5],
                          step: 0.09, peak: 0.16, attack: 0.008, release: 0.24, tail: 0.26)

        case .warning:
            [SeslenVoice(
                .oscillator(.square), start: 0, stop: 0.52,
                frequency: AudioParam(default: 880, events: [
                    .setValue(880, at: 0),
                    .setValue(660, at: 0.16),
                    .setValue(880, at: 0.32),
                ]),
                gain: .envelope(start: 0, peak: 0.1, attack: 0.01, release: 0.5, hold: 0.46)
            )]
        }
    }

    // MARK: - Shapes shared by several presets

    /// A single fixed-pitch hit.
    private static func blip(
        _ waveform: Oscillator,
        hertz: Double,
        peak: Double,
        attack: Double,
        release: Double,
        stop: Double
    ) -> SeslenVoice {
        SeslenVoice(
            .oscillator(waveform), start: 0, stop: stop,
            frequency: .pitch(hertz),
            gain: .envelope(start: 0, peak: peak, attack: attack, release: release)
        )
    }

    /// Fixed-pitch hits at explicit offsets, each with the same envelope.
    private static func sequence(
        _ waveform: Oscillator,
        notes: [(hertz: Double, at: Double)],
        peak: Double,
        attack: Double,
        release: Double,
        tail: Double
    ) -> [SeslenVoice] {
        notes.map { note in
            SeslenVoice(
                .oscillator(waveform), start: note.at, stop: note.at + tail,
                frequency: .pitch(note.hertz, at: note.at),
                gain: .envelope(start: note.at, peak: peak, attack: attack, release: release)
            )
        }
    }

    /// Evenly spaced triangle notes — the shape both celebration presets use.
    private static func arpeggio(
        _ hertz: [Double],
        step: Double,
        peak: Double,
        attack: Double,
        release: Double,
        tail: Double
    ) -> [SeslenVoice] {
        hertz.enumerated().map { index, note in
            let start = Double(index) * step
            return SeslenVoice(
                .oscillator(.triangle), start: start, stop: start + tail,
                frequency: .pitch(note, at: start),
                gain: .envelope(start: start, peak: peak, attack: attack, release: release)
            )
        }
    }

    /// A noise burst through a sweeping filter — the shape every whoosh uses.
    private static func sweep(
        noiseFor bufferDuration: Double,
        stop: Double,
        kind: WebAudioFilterKind,
        q: Double,
        from: Double,
        to target: Double,
        over duration: Double,
        peak: Double,
        attack: Double,
        release: Double
    ) -> SeslenVoice {
        SeslenVoice(
            .noise(bufferDuration: bufferDuration), start: 0, stop: stop,
            gain: .envelope(start: 0, peak: peak, attack: attack, release: release),
            filter: SeslenFilter(
                kind: kind,
                q: q,
                frequency: .glide(from: from, to: target, over: duration)
            )
        )
    }

    /// The seeded stand-in for `tick`'s per-play pitch jitter, in 0..<1.
    private static var tickJitter: Double {
        var random = SeededRandom(seed: "seslen:tick")
        return random.next()
    }
}
