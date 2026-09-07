# Cuelume

Seventeen interaction sounds for Swift apps. Synthesized live with `AVAudioEngine` — no MP3s, no WAVs, no extra assets.

This is a Swift port of [CueLume](https://github.com/Danilaa1/cuelume) by Daniel Belyi. The recipes (frequencies, envelopes, filters, shimmer) match the original Web Audio library.

## Install

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/skavinvarnan/cuelume.git", from: "0.1.0")
]
```

In Xcode: **File → Add Package Dependencies…** and paste `https://github.com/skavinvarnan/cuelume.git`.

## Usage

```swift
import Cuelume

Cuelume.play(.success)
Cuelume.play(.success, volume: 0.4)

Cuelume.setVolume(0.7)
Cuelume.setEnabled(false)
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

Requires iOS 26, macOS 26, tvOS 26, or visionOS 26.

## Sounds

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

## Demo

Open `cuelume.xcodeproj` (scheme **CuelumeDemo**) and run the app. It lists every cue; tap a row to hear it.

## How it works

Each cue is a **recipe**, not a recording: sine/triangle oscillators, filtered noise, exponential envelopes, optional pitch glides, and a short delay shimmer. Buffers are rendered once, then played through `AVAudioEngine`.

## License

MIT. Sound recipes originated in [CueLume](https://github.com/Danilaa1/cuelume).
