# Changelog

## 0.1.3

### Compatibility

- Minimum platforms lowered to iOS 18, macOS 15, tvOS 18 and visionOS 2.

## 0.1.2

### Fixed

- Crash on launch when `CuelumePlayer.shared` was first touched from a SwiftUI
  view. `AVAudioEngine.prepare()` ran before the audio session was active and
  threw an NSException. The engine now starts on the first `play()`, after the
  session is configured and a player node is attached.
- Compile error in the uisfx pack and cue definition getters (`Missing return
  in getter`) when a `typealias` made the getter a multi-statement body.

### Compatibility

Public API is unchanged from 0.1.1.

## 0.1.1

Adds two more sound libraries alongside the original CueLume palette. 17 sounds
becomes 989.

### Added

- **[seslen](https://github.com/productdevbook/seslen) — 36 presets.** Play them with
  `Cuelume.play(seslen:)`. Each preset carries its upstream `label`, `detail`,
  `recipeSummary`, `tags` and `duration`.
- **[uisfx](https://github.com/romainsimon/uisfx) — 78 cues across 12 packs.** Play
  them with `Cuelume.play(uisfx:pack:)`. Cues are grouped into 13 categories, and each
  carries the catalog's own `suggestedVolume`, which is applied unless you pass a
  `volume:`.
- `CuelumeSound`, one address for any sound in the package, so a choice can be stored
  or passed around.
- Loop playback. The six uisfx `loops` cues repeat until stopped; `play` now returns a
  `CuelumePlayer.Playback` token, and `Cuelume.stop(_:)` / `Cuelume.stopAll()` end
  them.
- `Cuelume.prewarm(_:)` to render sounds ahead of their first play.
- `CuelumePlayer.nowPlaying`, covering all three libraries.
- `Cuelume.version`.

### Changed

- Buffers are now rendered on first use and cached under an 8 MB budget, instead of
  rendering the whole palette when the player is created. With 989 sounds, rendering
  everything up front is no longer viable.
- Output is stereo, because uisfx cues pan. Mono sounds are sent to both channels.
- The audio session category is set once rather than on every `play` call.
- The player pool is capped at 16 voices and steals the oldest when it is full, rather
  than attaching an unbounded number of player nodes under rapid playback.
- Playback now ends on the engine's own completion callback rather than a timer.

### Compatibility

`Cuelume.play(.success)`, `setVolume`, `setEnabled`, `sounds` and
`CuelumePlayer.playing` all behave as they did in 0.1.0. `play` gained a discardable
return value, and `playing` became a computed view of `nowPlaying`; neither breaks
existing call sites. The 17 CueLume sounds themselves are unchanged.
