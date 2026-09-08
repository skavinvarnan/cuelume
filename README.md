# Cuelume

Interaction sounds for Swift apps. Synthesized live with `AVAudioEngine` — no MP3s, no WAVs, no extra assets.

Three sound libraries, one API:

| Library | Sounds | Character |
| --- | --- | --- |
| [CueLume](https://github.com/Danilaa1/cuelume) by Daniel Belyi | 17 cues | Melodic bells, clicks and status tones |
| [seslen](https://github.com/productdevbook/seslen) by productdevbook | 36 presets | Compact blips, sweeps and game-style cues |
| [uisfx](https://github.com/romainsimon/uisfx) by Yuki Capital | 78 cues × 12 packs | A full interaction taxonomy, retimbred by pack |

That is 989 sounds, all generated on device from recipes ported from the originals.

## Install

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/skavinvarnan/cuelume.git", from: "0.1.1")
]
```

In Xcode: **File → Add Package Dependencies…** and paste `https://github.com/skavinvarnan/cuelume.git`.

## Usage

```swift
import Cuelume

Cuelume.play(.success)                       // CueLume
Cuelume.play(seslen: .pop)                   // seslen
Cuelume.play(uisfx: .press, pack: .glass)    // uisfx

Cuelume.play(.success, volume: 0.4)          // one-off volume, 0...1

Cuelume.setVolume(0.7)
Cuelume.setEnabled(false)
```

Any sound can also be addressed as a `CuelumeSound`, which is what you want when the
choice is stored or passed around:

```swift
let confirm: CuelumeSound = .uisfx(.success, pack: .glass)
Cuelume.play(confirm)
```

SwiftUI, with an observable player:

```swift
import SwiftUI
import Cuelume

struct SaveButton: View {
    @State private var player = CuelumePlayer.shared

    var body: some View {
        Button("Save") {
            player.play(.success)
        }
    }
}
```

### Loops

Six uisfx cues (`loading`, `processing`, `recording`, `connecting`, `scanning`,
`streaming`) repeat until you stop them. `play` hands back a token for that:

```swift
let spinner = Cuelume.play(uisfx: .loading, pack: .dreamy)
// later
if let spinner { Cuelume.stop(spinner) }

Cuelume.stopAll()
```

Everything else is a one-shot, and `isLoop` tells you which is which.

### Prewarming

Sounds are rendered the first time they are played and then cached, so the first tap
of a cue costs a millisecond or two more than the rest. Prewarm the ones on a hot path:

```swift
Cuelume.prewarm([.cuelume(.tick), .uisfx(.press, pack: .minimal)])
```

The cache holds about 8 MB of audio and drops the least recently used sound beyond that.

Requires iOS 26, macOS 26, tvOS 26, or visionOS 26.

## Loudness

The three libraries were authored to different levels, and Cuelume keeps each one's
own balance rather than flattening them:

- **CueLume** cues run hottest, peaking around 0.2–0.4 at full volume.
- **uisfx** cues are normalised to a fixed peak, then played at the cue's own
  `suggestedVolume` — which is why `hover` sits far below `success`. Pass an explicit
  `volume:` to override it.
- **seslen** presets are the quietest by design; `hover` peaks at 0.018.

If you mix libraries in one app, expect to pass `volume:` to even them out.

## Sounds

### CueLume

| Name | Character |
| --- | --- |
| `chime` | Soft two-note ascending bell |
| `sparkle` | Quick four-note twinkle |
| `droplet` | Single note gliding down |
| `bloom` | Warm slow swell |
| `whisper` | Soft hush with a falling tone |
| `tick` | Crisp instant tick |
| `press` | Dull muted knock |
| `release` | Brighter springy tick |
| `toggle` | Mechanical click-clack |
| `success` | Warm three-note confirmation |
| `error` | Soft knock and descending refusal |
| `page` | Papery flick with a glass tick |
| `loading` | Brief unresolved rising shimmer |
| `ready` | Rising lock-on with a clear resolve |
| `pulse` | Compact synthetic chirp |
| `scan` | Fast three-step locator signal |
| `arrival` | Rising harmonic portal |

### seslen

`add` `alarm` `coin` `collapse` `copy` `delete` `drag` `drop` `error` `expand`
`explosion` `heartbeat` `hover` `jump` `keypress` `level-up` `lock` `message`
`notify` `paste` `pop` `receive` `redo` `scroll-tick` `send` `shoot` `success`
`swoosh` `tick` `toggle-off` `toggle-on` `typewriter` `undo` `unlock` `victory`
`warning`

Each carries its upstream `label`, `detail`, `recipeSummary` and `tags`.

### uisfx

78 cues across 13 categories — input, selection, navigation, editing, movement,
communication, feedback, progress, loops, media, system, reward and commerce —
rendered in any of 12 packs:

| Pack | Character |
| --- | --- |
| `minimal` | Dry, precise, almost invisible |
| `soft` | Rounded felt, warm and reassuring |
| `glass` | Bright, crystalline, and premium |
| `arcade` | Chunky pixels and cheerful voltage |
| `mechanical` | Switches, relays, and firm detents |
| `organic` | Wood, water, breath, and small stones |
| `dreamy` | Airy blooms, soft light, and slow sparkle |
| `scifi` | Clean holographic pings |
| `rubber` | Tactile elastic taps with a quick rebound |
| `cinematic` | Deep impacts, polished tails, and quiet scale |
| `studio` | Tactile editing precision with warm restraint |
| `zen` | Pure tones, dry wood, and brief washi detail |

Enumerate them with `UISFXCue.allCases`, `UISFXPack.allCases` and
`UISFXCategory.allCases`.

## Demo

Open `cuelume.xcodeproj` (scheme **CuelumeDemo**) and run the app. It lists every
sound in all three libraries; tap a row to hear it, and pick a pack to hear the uisfx
catalog in a different voice.

## How it works

Each cue is a **recipe**, not a recording.

- **CueLume** — sine/triangle oscillators, filtered noise, exponential envelopes,
  pitch glides, and a short delay shimmer.
- **seslen** — small Web Audio graphs: an oscillator or noise burst through an
  optional biquad into a scheduled gain envelope. Cuelume replays those automation
  timelines offline.
- **uisfx** — a harmonic tone with optional FM and elastic pitch, an event-bound
  noise texture, a transient, and (for `zen`) struck paper, brush, wood and chime
  models, then panned, echoed and normalised.

Buffers are rendered once and played through `AVAudioEngine`. The uisfx and seslen
renderers seed their noise, so a given sound renders identically every time — which is
what makes caching safe and the port testable.

## Porting notes

- The uisfx port was checked against the original TypeScript across all 936 pack ×
  cue pairs: recipes match exactly, and rendered PCM matches to float32 precision.
- The seslen port was checked by recording every upstream factory's scheduled Web
  Audio calls and diffing them against the Swift recipes.
- seslen's `tick` jitters its pitch with `Math.random` on every play. Cuelume renders
  a cue once and caches it, so that draw is seeded instead.
- Web Audio reads a lowpass or highpass `Q` in decibels, and Cuelume's shared biquad
  does the same, so the ported filters keep their intended resonance.

## License

MIT.

Sound recipes originated in [CueLume](https://github.com/Danilaa1/cuelume) (MIT),
[seslen](https://github.com/productdevbook/seslen) (MIT) and
[uisfx](https://github.com/romainsimon/uisfx) (MIT). Cuelume ports their synthesis
recipes; it does not redistribute uisfx's pre-rendered audio files.
