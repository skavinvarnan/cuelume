//
//  SeslenCatalog.swift
//  Cuelume
//
//  GENERATED metadata from seslen's presets — do not edit by hand.
//  https://github.com/productdevbook/seslen/tree/main/src/presets
//
//  The synthesis for each preset lives in SeslenPresets.swift.
//

import Foundation

/// A seslen preset. Pass one to `Cuelume.play(seslen:)`.
public enum SeslenSound: String, CaseIterable, Identifiable, Sendable {
    case add
    case alarm
    case coin
    case collapse
    case copy
    case delete
    case drag
    case drop
    case error
    case expand
    case explosion
    case heartbeat
    case hover
    case jump
    case keypress
    case levelUp = "level-up"
    case lock
    case message
    case notify
    case paste
    case pop
    case receive
    case redo
    case scrollTick = "scroll-tick"
    case send
    case shoot
    case success
    case swoosh
    case tick
    case toggleOff = "toggle-off"
    case toggleOn = "toggle-on"
    case typewriter
    case undo
    case unlock
    case victory
    case warning

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .add: "Add"
        case .alarm: "Alarm"
        case .coin: "Coin"
        case .collapse: "Collapse"
        case .copy: "Copy"
        case .delete: "Delete"
        case .drag: "Drag"
        case .drop: "Drop"
        case .error: "Error"
        case .expand: "Expand"
        case .explosion: "Explosion"
        case .heartbeat: "Heartbeat"
        case .hover: "Hover"
        case .jump: "Jump"
        case .keypress: "Keypress"
        case .levelUp: "Level up"
        case .lock: "Lock"
        case .message: "Message"
        case .notify: "Notify"
        case .paste: "Paste"
        case .pop: "Pop"
        case .receive: "Receive"
        case .redo: "Redo"
        case .scrollTick: "Scroll tick"
        case .send: "Send"
        case .shoot: "Shoot"
        case .success: "Success"
        case .swoosh: "Swoosh"
        case .tick: "Tick"
        case .toggleOff: "Toggle off"
        case .toggleOn: "Toggle on"
        case .typewriter: "Typewriter"
        case .undo: "Undo"
        case .unlock: "Unlock"
        case .victory: "Victory"
        case .warning: "Warning"
        }
    }

    public var detail: String {
        switch self {
        case .add: "A quick rising blip for adding items, ticking todos and incrementing counters."
        case .alarm: "Repeating two-tone siren for sustained alarms and timed warnings."
        case .coin: "Two-note metallic ping for coin pickups, points and item collections."
        case .collapse: "Falling arc for accordions, drawers and panels collapsing."
        case .copy: "Bright two-tap blip for copy-to-clipboard confirmations."
        case .delete: "Filtered noise swoosh for removing items and dismissing dialogs."
        case .drag: "Soft pickup chirp for the start of a drag gesture."
        case .drop: "Short low thud for the end of a drag gesture or item drop."
        case .error: "A short descending buzz for failed or rejected actions."
        case .expand: "Smooth rising arc for accordions, drawers and panels opening up."
        case .explosion: "Low rumbling noise burst for explosions, crashes and impact moments."
        case .heartbeat: "Two low thumps spaced like a human heartbeat — for tension and pulse states."
        case .hover: "A near-silent sine puff for hover affordance — safe to fire repeatedly."
        case .jump: "Quick rising blip for jumps and pop-up animations."
        case .keypress: "A short mechanical-key click — defaults to heavy jitter so typing feels organic."
        case .levelUp: "Bright ascending five-note scale for level-ups, milestones and rewards."
        case .lock: "Two heavy clicks for locking, sealing and confirming a secured state."
        case .message: "Soft two-tone bell for incoming messages and notifications."
        case .notify: "Three-tone ascending notification for in-app alerts and banners."
        case .paste: "Soft sustained tap for paste / drop-in confirmations."
        case .pop: "Bubbly downward pop for popovers, dismissals and lightweight toggles."
        case .receive: "Soft falling chime for incoming messages and received items."
        case .redo: "Two-note forward blip for redo and replay actions."
        case .scrollTick: "Tiny detent click for scroll wheels, sliders, steppers and value pickers."
        case .send: "Rising whoosh for send, submit and publish actions."
        case .shoot: "Bandpassed noise zap for shoots, lasers and quick projectiles."
        case .success: "Two-step rising chirp for completed actions and confirmations."
        case .swoosh: "Filtered noise sweep for transitions, modal opens and panel reveals."
        case .tick: "A short, crisp click for buttons, toggles and toasts."
        case .toggleOff: "A two-step descending click for switches and checkboxes turning off."
        case .toggleOn: "A two-step ascending click for switches and checkboxes turning on."
        case .typewriter: "Tiny dry tick for streaming text and typewriter character reveals."
        case .undo: "Two-note reverse blip for undo, back and step-back actions."
        case .unlock: "Two light clicks rising in pitch for unlock and grant-access actions."
        case .victory: "A four-note major arpeggio for level-ups and game-style success."
        case .warning: "Two-tone alarm for cautions and confirmations that need attention."
        }
    }

    /// The preset's one-line synthesis summary, as written upstream.
    public var recipeSummary: String {
        switch self {
        case .add: "sine 880→1480 Hz · 140 ms"
        case .alarm: "square 880↔660 Hz · 4 cycles · 800 ms"
        case .coin: "square 988 + 1320 Hz · 180 ms"
        case .collapse: "sine 990→330 Hz · 200 ms"
        case .copy: "sine 1480 + 1480 Hz · 90 ms"
        case .delete: "noise sweep 4 kHz→400 Hz · 200 ms"
        case .drag: "sine 440→660 Hz · 120 ms"
        case .drop: "sine 220→110 Hz · 120 ms"
        case .error: "square 220→150 Hz · 260 ms"
        case .expand: "sine 330→990 Hz · 200 ms"
        case .explosion: "noise lowpass 2 kHz→100 Hz · 600 ms"
        case .heartbeat: "sine 60 Hz double-thump · 600 ms"
        case .hover: "sine 2.4 kHz · 25 ms"
        case .jump: "square 220→880 Hz · 100 ms"
        case .keypress: "square 1.8 kHz · 12 ms"
        case .levelUp: "C-D-E-G-C arpeggio · 480 ms"
        case .lock: "square 320 + 220 Hz · 140 ms"
        case .message: "sine 880 + 1320 Hz · 420 ms"
        case .notify: "sine 660-880-1320 Hz · 360 ms"
        case .paste: "sine 880 Hz · 80 ms"
        case .pop: "triangle 1200→320 Hz · 90 ms"
        case .receive: "sine 1320→880 Hz · 220 ms"
        case .redo: "triangle 520→880 Hz · 180 ms"
        case .scrollTick: "triangle 3 kHz · 6 ms"
        case .send: "noise sweep 600→4000 Hz · 220 ms"
        case .shoot: "noise sweep 5 kHz→500 Hz · 130 ms"
        case .success: "triangle 660→990→1320 Hz · 320 ms"
        case .swoosh: "noise sweep 400→4000 Hz · 240 ms"
        case .tick: "sine 4 kHz · 3 ms"
        case .toggleOff: "sine 1100 + 700 Hz · 110 ms"
        case .toggleOn: "sine 700 + 1100 Hz · 110 ms"
        case .typewriter: "triangle 2.6 kHz · 8 ms"
        case .undo: "triangle 880→520 Hz · 180 ms"
        case .unlock: "triangle 220 + 440 Hz · 140 ms"
        case .victory: "C-E-G-C arpeggio · 360 ms"
        case .warning: "square 880↔660 Hz · 500 ms"
        }
    }

    /// Search and filter tags from the upstream catalog.
    public var tags: [String] {
        switch self {
        case .add: ["ui", "feedback", "chirp"]
        case .alarm: ["feedback", "warning"]
        case .coin: ["game", "pickup"]
        case .collapse: ["ui", "transition"]
        case .copy: ["ui", "feedback"]
        case .delete: ["ui", "noise", "sweep"]
        case .drag: ["ui", "drag"]
        case .drop: ["ui", "drag"]
        case .error: ["feedback", "error"]
        case .expand: ["ui", "transition"]
        case .explosion: ["game", "noise"]
        case .heartbeat: ["ambient", "rhythm"]
        case .hover: ["ui", "hover"]
        case .jump: ["game"]
        case .keypress: ["ui", "click", "keyboard"]
        case .levelUp: ["game", "success", "arpeggio"]
        case .lock: ["ui", "feedback", "click"]
        case .message: ["notification", "bell"]
        case .notify: ["notification", "chirp"]
        case .paste: ["ui", "feedback"]
        case .pop: ["ui", "feedback"]
        case .receive: ["notification", "chirp"]
        case .redo: ["ui", "feedback"]
        case .scrollTick: ["ui", "click"]
        case .send: ["ui", "noise", "sweep"]
        case .shoot: ["game", "noise"]
        case .success: ["feedback", "success", "chirp"]
        case .swoosh: ["ui", "noise", "sweep"]
        case .tick: ["ui", "feedback", "click"]
        case .toggleOff: ["ui", "feedback", "toggle"]
        case .toggleOn: ["ui", "feedback", "toggle"]
        case .typewriter: ["ui", "click"]
        case .undo: ["ui", "feedback"]
        case .unlock: ["ui", "feedback", "click"]
        case .victory: ["game", "success", "arpeggio"]
        case .warning: ["feedback", "warning"]
        }
    }

    /// The preset's audible length in seconds, as declared upstream.
    public var duration: Double {
        switch self {
        case .add: 0.16
        case .alarm: 0.84
        case .coin: 0.2
        case .collapse: 0.22
        case .copy: 0.1
        case .delete: 0.22
        case .drag: 0.14
        case .drop: 0.15
        case .error: 0.28
        case .expand: 0.22
        case .explosion: 0.62
        case .heartbeat: 0.36
        case .hover: 0.03
        case .jump: 0.12
        case .keypress: 0.014
        case .levelUp: 0.7
        case .lock: 0.14
        case .message: 0.42
        case .notify: 0.38
        case .paste: 0.1
        case .pop: 0.1
        case .receive: 0.24
        case .redo: 0.2
        case .scrollTick: 0.008
        case .send: 0.24
        case .shoot: 0.14
        case .success: 0.34
        case .swoosh: 0.26
        case .tick: 0.005
        case .toggleOff: 0.13
        case .toggleOn: 0.13
        case .typewriter: 0.01
        case .undo: 0.2
        case .unlock: 0.14
        case .victory: 0.6
        case .warning: 0.52
        }
    }
}
