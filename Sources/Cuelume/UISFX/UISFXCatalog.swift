//
//  UISFXCatalog.swift
//  Cuelume
//
//  GENERATED from uisfx's catalog.ts — do not edit by hand.
//  https://github.com/romainsimon/uisfx/blob/main/packages/uisfx/src/catalog.ts
//
//  12 packs x 78 cues. A pack is a timbre, a cue is an
//  intent; every pair renders to its own sound.
//

import Foundation

/// What a cue is for. Used to group the catalog in a picker.
public enum UISFXCategory: String, CaseIterable, Identifiable, Sendable {
    case input
    case selection
    case navigation
    case editing
    case movement
    case communication
    case feedback
    case progress
    case loops
    case media
    case system
    case reward
    case commerce

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .input: "Input"
        case .selection: "Selection"
        case .navigation: "Navigation"
        case .editing: "Editing"
        case .movement: "Movement"
        case .communication: "Communication"
        case .feedback: "Feedback"
        case .progress: "Progress"
        case .loops: "Loops"
        case .media: "Media"
        case .system: "System"
        case .reward: "Reward"
        case .commerce: "Commerce"
        }
    }

    public var detail: String {
        switch self {
        case .input: "Pointer, key, and touch contact."
        case .selection: "Choosing, switching, and changing state."
        case .navigation: "Moving through views and layers."
        case .editing: "Changing work with reversible and destructive actions."
        case .movement: "Dragging, snapping, and spatial gestures."
        case .communication: "Messages and attention."
        case .feedback: "Clear outcomes and system status."
        case .progress: "Processes from start to finish."
        case .loops: "Continuous state while work, capture, or connection is active."
        case .media: "Playback, seeking, and listening controls."
        case .system: "Connections, access, and device state."
        case .reward: "Milestones, value, and celebration."
        case .commerce: "Cart, checkout, and value exchange."
        }
    }

    /// Every cue in this category, in catalog order.
    public var cues: [UISFXCue] { UISFXCue.allCases.filter { $0.category == self } }
}

/// A timbre applied across the whole cue catalog.
public enum UISFXPack: String, CaseIterable, Identifiable, Sendable {
    case minimal
    case soft
    case glass
    case arcade
    case mechanical
    case organic
    case dreamy
    case scifi
    case rubber
    case cinematic
    case studio
    case zen

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .minimal: "Minimal"
        case .soft: "Soft"
        case .glass: "Glass"
        case .arcade: "Arcade"
        case .mechanical: "Mechanical"
        case .organic: "Organic"
        case .dreamy: "Dreamy"
        case .scifi: "Sci-fi"
        case .rubber: "Rubber"
        case .cinematic: "Cinematic"
        case .studio: "Studio"
        case .zen: "Zen"
        }
    }

    public var detail: String {
        switch self {
        case .minimal: "Dry, precise, almost invisible."
        case .soft: "Rounded felt, warm and reassuring."
        case .glass: "Bright, crystalline, and premium."
        case .arcade: "Chunky pixels and cheerful voltage."
        case .mechanical: "Switches, relays, and firm detents."
        case .organic: "Wood, water, breath, and small stones."
        case .dreamy: "Airy blooms, soft light, and slow sparkle."
        case .scifi: "Clean holographic pings with a restrained digital shimmer."
        case .rubber: "Tactile elastic taps with a quick, friendly rebound."
        case .cinematic: "Deep impacts, polished tails, and quiet scale."
        case .studio: "Tactile editing precision with warm cinematic restraint."
        case .zen: "Pure tones, dry wood, and brief washi detail."
        }
    }

    /// The kind of product this pack was tuned for.
    public var bestFor: String {
        switch self {
        case .minimal: "Productivity, SaaS, system UI"
        case .soft: "Mobile, wellness, friendly SaaS"
        case .glass: "Media, finance, luxury products"
        case .arcade: "Games, streaks, gamified learning"
        case .mechanical: "Devtools, hardware, industrial UI"
        case .organic: "Education, kids, calm games"
        case .dreamy: "Creative tools, wellness, ambient apps"
        case .scifi: "AI tools, spatial UI, futuristic games"
        case .rubber: "Kids, playful mobile, casual games"
        case .cinematic: "Premium media, games, dramatic moments"
        case .studio: "Film, audio, and AI creative tools"
        case .zen: "Mindfulness, reading, writing, calm productivity"
        }
    }

    /// Accent colour as an sRGB hex string, for demo UIs.
    public var accentHex: String {
        switch self {
        case .minimal: "#e84d2a"
        case .soft: "#d47b83"
        case .glass: "#4c8ca5"
        case .arcade: "#7257d9"
        case .mechanical: "#68736f"
        case .organic: "#718b4e"
        case .dreamy: "#a36cad"
        case .scifi: "#20a29d"
        case .rubber: "#d99a24"
        case .cinematic: "#3f5873"
        case .studio: "#6261a8"
        case .zen: "#7d8f77"
        }
    }

    var definition: UISFXPackDefinition {
        typealias Harmonic = UISFXHarmonic
        switch self {
        case .minimal:
            UISFXPackDefinition(
                waveform: .sine,
                pitch: 1,
                duration: 0.78,
                attack: 0.004,
                decay: 2.3,
                noise: 0.05,
                transient: 0.15,
                brightness: 0.78,
                echo: 0,
                bitDepth: 16,
                harmonics: [Harmonic(1, 1), Harmonic(2, 0.08)]
            )
        case .soft:
            UISFXPackDefinition(
                waveform: .triangle,
                pitch: 0.9,
                duration: 1.08,
                attack: 0.012,
                decay: 1.65,
                noise: 0.08,
                transient: 0.08,
                brightness: 0.46,
                echo: 0.04,
                bitDepth: 16,
                harmonics: [Harmonic(1, 1), Harmonic(2, 0.14), Harmonic(3, 0.04)]
            )
        case .glass:
            UISFXPackDefinition(
                waveform: .sine,
                pitch: 1.22,
                duration: 1.22,
                attack: 0.003,
                decay: 1.32,
                noise: 0.025,
                transient: 0.12,
                brightness: 0.95,
                echo: 0.09,
                bitDepth: 16,
                harmonics: [Harmonic(1, 1), Harmonic(2.72, 0.28), Harmonic(4.19, 0.11), Harmonic(6.8, 0.05)]
            )
        case .arcade:
            UISFXPackDefinition(
                waveform: .square,
                pitch: 1.08,
                duration: 0.86,
                attack: 0.002,
                decay: 1.1,
                noise: 0.035,
                transient: 0.2,
                brightness: 0.72,
                echo: 0.025,
                bitDepth: 8,
                harmonics: [Harmonic(1, 1), Harmonic(2, 0.08)]
            )
        case .mechanical:
            UISFXPackDefinition(
                waveform: .triangle,
                pitch: 0.74,
                duration: 0.72,
                attack: 0.001,
                decay: 2.8,
                noise: 0.24,
                transient: 0.72,
                brightness: 0.58,
                echo: 0.015,
                bitDepth: 12,
                harmonics: [Harmonic(1, 1), Harmonic(1.5, 0.13), Harmonic(2.1, 0.08)]
            )
        case .organic:
            UISFXPackDefinition(
                waveform: .sine,
                pitch: 0.94,
                duration: 1.12,
                attack: 0.008,
                decay: 1.85,
                noise: 0.18,
                transient: 0.28,
                brightness: 0.4,
                echo: 0.055,
                bitDepth: 16,
                harmonics: [Harmonic(1, 1), Harmonic(1.48, 0.18), Harmonic(2.02, 0.09), Harmonic(3.05, 0.035)]
            )
        case .dreamy:
            UISFXPackDefinition(
                waveform: .sine,
                pitch: 1.05,
                duration: 1.18,
                attack: 0.02,
                decay: 1.42,
                noise: 0.045,
                transient: 0.045,
                brightness: 0.56,
                echo: 0.13,
                bitDepth: 16,
                harmonics: [Harmonic(1, 1), Harmonic(2, 0.12), Harmonic(3.01, 0.07), Harmonic(5.02, 0.025)]
            )
        case .scifi:
            UISFXPackDefinition(
                waveform: .sine,
                pitch: 1.1,
                duration: 0.84,
                attack: 0.0025,
                decay: 2.05,
                noise: 0.025,
                transient: 0.16,
                brightness: 0.82,
                echo: 0.035,
                bitDepth: 16,
                harmonics: [Harmonic(1, 1), Harmonic(2.01, 0.11), Harmonic(3.98, 0.025)],
                fmRatio: 2.01,
                fmDepth: 0.42
            )
        case .rubber:
            UISFXPackDefinition(
                waveform: .triangle,
                pitch: 0.86,
                duration: 0.88,
                attack: 0.0035,
                decay: 2.2,
                noise: 0.018,
                transient: 0.22,
                brightness: 0.5,
                echo: 0.012,
                bitDepth: 16,
                harmonics: [Harmonic(1, 1), Harmonic(1.5, 0.075), Harmonic(2.02, 0.04)],
                elasticity: 1.15
            )
        case .cinematic:
            UISFXPackDefinition(
                waveform: .sine,
                pitch: 0.7,
                duration: 1.28,
                attack: 0.008,
                decay: 1.78,
                noise: 0.12,
                transient: 0.55,
                brightness: 0.38,
                echo: 0.11,
                bitDepth: 16,
                harmonics: [Harmonic(1, 1), Harmonic(0.5, 0.22), Harmonic(2, 0.1), Harmonic(3, 0.035)]
            )
        case .studio:
            UISFXPackDefinition(
                waveform: .triangle,
                pitch: 0.86,
                duration: 0.82,
                attack: 0.004,
                decay: 2.15,
                noise: 0.09,
                transient: 0.24,
                brightness: 0.48,
                echo: 0.025,
                bitDepth: 16,
                harmonics: [Harmonic(1, 1), Harmonic(2, 0.11), Harmonic(3, 0.035)]
            )
        case .zen:
            UISFXPackDefinition(
                waveform: .sine,
                pitch: 0.94,
                duration: 0.82,
                attack: 0.003,
                decay: 2.7,
                noise: 0,
                transient: 0.025,
                brightness: 0.52,
                echo: 0,
                bitDepth: 16,
                harmonics: [Harmonic(1, 1), Harmonic(2.01, 0.035)],
                paper: 0.12,
                brush: 0.065,
                wood: 0.16,
                chime: 0.09
            )
        }
    }
}

/// An interaction intent. Pair it with a `UISFXPack` to get a sound.
public enum UISFXCue: String, CaseIterable, Identifiable, Sendable {
    case hover
    case press
    case release
    case doubleClick = "double-click"
    case focus
    case longPress = "long-press"
    case select
    case deselect
    case toggleOn = "toggle-on"
    case toggleOff = "toggle-off"
    case check
    case uncheck
    case delete
    case cancel
    case undo
    case redo
    case copy
    case paste
    case `open`
    case close
    case back
    case forward
    case expand
    case collapse
    case dragStart = "drag-start"
    case drop
    case snap
    case swipe
    case reorder
    case invalidDrop = "invalid-drop"
    case send
    case receive
    case notification
    case mention
    case typing
    case reaction
    case success
    case error
    case warning
    case info
    case blocked
    case retry
    case start
    case stop
    case progressStep = "progress-step"
    case complete
    case queued
    case checkpoint
    case loading
    case processing
    case recording
    case connecting
    case scanning
    case streaming
    case play
    case pause
    case seek
    case volumeChange = "volume-change"
    case skipNext = "skip-next"
    case skipPrevious = "skip-previous"
    case connect
    case disconnect
    case lock
    case unlock
    case wake
    case sleep
    case reward
    case levelUp = "level-up"
    case achievement
    case streak
    case badge
    case bonus
    case addToCart = "add-to-cart"
    case removeFromCart = "remove-from-cart"
    case checkout
    case purchase
    case coupon
    case refund

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .hover: "Hover"
        case .press: "Press"
        case .release: "Release"
        case .doubleClick: "Double click"
        case .focus: "Focus"
        case .longPress: "Long press"
        case .select: "Select"
        case .deselect: "Deselect"
        case .toggleOn: "Toggle on"
        case .toggleOff: "Toggle off"
        case .check: "Check"
        case .uncheck: "Uncheck"
        case .delete: "Delete"
        case .cancel: "Cancel"
        case .undo: "Undo"
        case .redo: "Redo"
        case .copy: "Copy"
        case .paste: "Paste"
        case .open: "Open"
        case .close: "Close"
        case .back: "Back"
        case .forward: "Forward"
        case .expand: "Expand"
        case .collapse: "Collapse"
        case .dragStart: "Drag start"
        case .drop: "Drop"
        case .snap: "Snap"
        case .swipe: "Swipe"
        case .reorder: "Reorder"
        case .invalidDrop: "Invalid drop"
        case .send: "Send"
        case .receive: "Receive"
        case .notification: "Notification"
        case .mention: "Mention"
        case .typing: "Typing"
        case .reaction: "Reaction"
        case .success: "Success"
        case .error: "Error"
        case .warning: "Warning"
        case .info: "Info"
        case .blocked: "Blocked"
        case .retry: "Retry"
        case .start: "Start"
        case .stop: "Stop"
        case .progressStep: "Progress step"
        case .complete: "Complete"
        case .queued: "Queued"
        case .checkpoint: "Checkpoint"
        case .loading: "Loading"
        case .processing: "Processing"
        case .recording: "Recording"
        case .connecting: "Connecting"
        case .scanning: "Scanning"
        case .streaming: "Streaming"
        case .play: "Play"
        case .pause: "Pause"
        case .seek: "Seek"
        case .volumeChange: "Volume change"
        case .skipNext: "Skip next"
        case .skipPrevious: "Skip previous"
        case .connect: "Connect"
        case .disconnect: "Disconnect"
        case .lock: "Lock"
        case .unlock: "Unlock"
        case .wake: "Wake"
        case .sleep: "Sleep"
        case .reward: "Reward"
        case .levelUp: "Level up"
        case .achievement: "Achievement"
        case .streak: "Streak"
        case .badge: "Badge"
        case .bonus: "Bonus"
        case .addToCart: "Add to cart"
        case .removeFromCart: "Remove from cart"
        case .checkout: "Checkout"
        case .purchase: "Purchase"
        case .coupon: "Coupon"
        case .refund: "Refund"
        }
    }

    public var detail: String {
        switch self {
        case .hover: "Fine-pointer discovery without commitment."
        case .press: "A control is physically engaged."
        case .release: "A pressed control springs back."
        case .doubleClick: "A rapid secondary activation."
        case .focus: "A control becomes ready for keyboard or text input."
        case .longPress: "A sustained press reveals a secondary action."
        case .select: "An item enters the active set."
        case .deselect: "An item leaves the active set."
        case .toggleOn: "A binary setting becomes active."
        case .toggleOff: "A binary setting becomes inactive."
        case .check: "A checkbox or task enters its completed state."
        case .uncheck: "A checkbox or task returns to its incomplete state."
        case .delete: "A destructive removal is committed."
        case .cancel: "A pending action is abandoned without applying."
        case .undo: "The most recent change is reversed."
        case .redo: "A reversed change is applied again."
        case .copy: "Selected content is placed on the clipboard."
        case .paste: "Clipboard content is inserted into the current context."
        case .open: "A menu, sheet, panel, or detail view appears."
        case .close: "A menu, sheet, panel, or detail view recedes."
        case .back: "Navigation returns to the previous place."
        case .forward: "Navigation advances to the next place."
        case .expand: "A collapsed region reveals more detail."
        case .collapse: "An expanded region returns to its compact state."
        case .dragStart: "An object lifts from its resting place."
        case .drop: "A dragged object lands in a valid target."
        case .snap: "An object locks into a precise position."
        case .swipe: "A touch gesture moves content spatially."
        case .reorder: "An item settles into a new position in a sequence."
        case .invalidDrop: "A dragged object cannot land in the current target."
        case .send: "A message or object leaves the user."
        case .receive: "A response or object arrives."
        case .notification: "New information is available, without urgency."
        case .mention: "The user is directly addressed."
        case .typing: "A brief key contact during text entry."
        case .reaction: "A lightweight social response is added."
        case .success: "An action finished with the expected result."
        case .error: "An action failed and needs attention."
        case .warning: "A risky or consequential state needs review."
        case .info: "A neutral system fact is surfaced."
        case .blocked: "An action cannot continue in the current state."
        case .retry: "A failed action is attempted again."
        case .start: "A process, recording, or session begins."
        case .stop: "A process, recording, or session ends."
        case .progressStep: "A discrete step advances inside a longer process."
        case .complete: "A multi-step process reaches its final state."
        case .queued: "Work is accepted and waiting to begin."
        case .checkpoint: "A meaningful stage in a longer process is saved."
        case .loading: "A quiet repeating pulse while an interface fetches or waits."
        case .processing: "A restrained repeating bed while sustained work is running."
        case .recording: "A calm periodic pulse while audio or video capture is live."
        case .connecting: "A repeating search pattern while a device or live session connects."
        case .scanning: "A spatial sweep repeats while content or devices are discovered."
        case .streaming: "A quiet repeating flow while live data or media continues."
        case .play: "Media playback begins or resumes."
        case .pause: "Media playback pauses at the current position."
        case .seek: "The playback position moves to a new point."
        case .volumeChange: "Playback loudness moves to a new level."
        case .skipNext: "Playback advances to the next item."
        case .skipPrevious: "Playback returns to the previous item."
        case .connect: "A device, service, or live session becomes available."
        case .disconnect: "A device, service, or live session goes offline."
        case .lock: "Access closes or a protected state engages."
        case .unlock: "Access opens or a protected state disengages."
        case .wake: "A device or dormant interface becomes active."
        case .sleep: "A device or interface enters a dormant state."
        case .reward: "The user receives a small unit of value."
        case .levelUp: "Capability, rank, or progression increases."
        case .achievement: "A rare milestone deserves a fuller celebration."
        case .streak: "Repeated participation extends an active streak."
        case .badge: "A collectible distinction is awarded."
        case .bonus: "An unexpected extra reward is revealed."
        case .addToCart: "An item enters a cart or pending order."
        case .removeFromCart: "An item leaves a cart or pending order."
        case .checkout: "A cart advances into the payment flow."
        case .purchase: "A paid transaction or value exchange completes."
        case .coupon: "A discount or promotional code is accepted."
        case .refund: "Value returns after a completed transaction."
        }
    }

    public var category: UISFXCategory {
        switch self {
        case .hover: .input
        case .press: .input
        case .release: .input
        case .doubleClick: .input
        case .focus: .input
        case .longPress: .input
        case .select: .selection
        case .deselect: .selection
        case .toggleOn: .selection
        case .toggleOff: .selection
        case .check: .selection
        case .uncheck: .selection
        case .delete: .editing
        case .cancel: .editing
        case .undo: .editing
        case .redo: .editing
        case .copy: .editing
        case .paste: .editing
        case .open: .navigation
        case .close: .navigation
        case .back: .navigation
        case .forward: .navigation
        case .expand: .navigation
        case .collapse: .navigation
        case .dragStart: .movement
        case .drop: .movement
        case .snap: .movement
        case .swipe: .movement
        case .reorder: .movement
        case .invalidDrop: .movement
        case .send: .communication
        case .receive: .communication
        case .notification: .communication
        case .mention: .communication
        case .typing: .communication
        case .reaction: .communication
        case .success: .feedback
        case .error: .feedback
        case .warning: .feedback
        case .info: .feedback
        case .blocked: .feedback
        case .retry: .feedback
        case .start: .progress
        case .stop: .progress
        case .progressStep: .progress
        case .complete: .progress
        case .queued: .progress
        case .checkpoint: .progress
        case .loading: .loops
        case .processing: .loops
        case .recording: .loops
        case .connecting: .loops
        case .scanning: .loops
        case .streaming: .loops
        case .play: .media
        case .pause: .media
        case .seek: .media
        case .volumeChange: .media
        case .skipNext: .media
        case .skipPrevious: .media
        case .connect: .system
        case .disconnect: .system
        case .lock: .system
        case .unlock: .system
        case .wake: .system
        case .sleep: .system
        case .reward: .reward
        case .levelUp: .reward
        case .achievement: .reward
        case .streak: .reward
        case .badge: .reward
        case .bonus: .reward
        case .addToCart: .commerce
        case .removeFromCart: .commerce
        case .checkout: .commerce
        case .purchase: .commerce
        case .coupon: .commerce
        case .refund: .commerce
        }
    }

    /// Loop cues repeat until stopped; every other cue is a one-shot.
    public var isLoop: Bool {
        switch self {
        case .loading, .processing, .recording, .connecting, .scanning, .streaming: true
        default: false
        }
    }

    /// The catalog's suggested playback volume for this cue, 0...1.
    public var suggestedVolume: Double {
        switch self {
        case .hover: 0.12
        case .press: 0.2
        case .release: 0.18
        case .doubleClick: 0.2
        case .focus: 0.12
        case .longPress: 0.18
        case .select: 0.2
        case .deselect: 0.17
        case .toggleOn: 0.2
        case .toggleOff: 0.18
        case .check: 0.17
        case .uncheck: 0.15
        case .delete: 0.22
        case .cancel: 0.17
        case .undo: 0.18
        case .redo: 0.18
        case .copy: 0.15
        case .paste: 0.17
        case .open: 0.18
        case .close: 0.17
        case .back: 0.17
        case .forward: 0.17
        case .expand: 0.16
        case .collapse: 0.15
        case .dragStart: 0.18
        case .drop: 0.22
        case .snap: 0.2
        case .swipe: 0.14
        case .reorder: 0.18
        case .invalidDrop: 0.19
        case .send: 0.2
        case .receive: 0.2
        case .notification: 0.2
        case .mention: 0.22
        case .typing: 0.065
        case .reaction: 0.17
        case .success: 0.23
        case .error: 0.22
        case .warning: 0.22
        case .info: 0.16
        case .blocked: 0.2
        case .retry: 0.18
        case .start: 0.19
        case .stop: 0.19
        case .progressStep: 0.12
        case .complete: 0.24
        case .queued: 0.14
        case .checkpoint: 0.18
        case .loading: 0.1
        case .processing: 0.08
        case .recording: 0.09
        case .connecting: 0.09
        case .scanning: 0.075
        case .streaming: 0.07
        case .play: 0.18
        case .pause: 0.17
        case .seek: 0.13
        case .volumeChange: 0.11
        case .skipNext: 0.16
        case .skipPrevious: 0.16
        case .connect: 0.2
        case .disconnect: 0.19
        case .lock: 0.2
        case .unlock: 0.2
        case .wake: 0.17
        case .sleep: 0.15
        case .reward: 0.22
        case .levelUp: 0.25
        case .achievement: 0.26
        case .streak: 0.21
        case .badge: 0.22
        case .bonus: 0.24
        case .addToCart: 0.19
        case .removeFromCart: 0.17
        case .checkout: 0.2
        case .purchase: 0.22
        case .coupon: 0.18
        case .refund: 0.2
        }
    }

    var definition: UISFXCueDefinition {
        typealias Note = UISFXPatternNote
        switch self {
        case .hover:
            UISFXCueDefinition(
                duration: 0.12,
                baseMidi: 78,
                notes: [Note(at: 0, semitone: 0, length: 0.09)],
                noise: 0.04,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .press:
            UISFXCueDefinition(
                duration: 0.16,
                baseMidi: 62,
                notes: [Note(at: 0, semitone: 3, length: 0.13, glide: -4)],
                noise: 0.14,
                transient: 0.5,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .release:
            UISFXCueDefinition(
                duration: 0.18,
                baseMidi: 68,
                notes: [Note(at: 0.01, semitone: -2, length: 0.14, glide: 4)],
                noise: 0.06,
                transient: 0.3,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .doubleClick:
            UISFXCueDefinition(
                duration: 0.24,
                baseMidi: 72,
                notes: [Note(at: 0, semitone: 0, length: 0.07), Note(at: 0.105, semitone: 2, length: 0.08)],
                noise: 0,
                transient: 0.5,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .focus:
            UISFXCueDefinition(
                duration: 0.23,
                baseMidi: 74,
                notes: [Note(at: 0, semitone: -5, length: 0.17, glide: 1), Note(at: 0, semitone: 2, length: 0.17, gain: 0.26)],
                noise: 0.015,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .longPress:
            UISFXCueDefinition(
                duration: 0.46,
                baseMidi: 58,
                notes: [Note(at: 0, semitone: 0, length: 0.34, glide: 5), Note(at: 0.28, semitone: 7, length: 0.13, gain: 0.5)],
                noise: 0.08,
                transient: 0.32,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .select:
            UISFXCueDefinition(
                duration: 0.28,
                baseMidi: 70,
                notes: [Note(at: 0, semitone: 0, length: 0.12), Note(at: 0.09, semitone: 7, length: 0.16)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .deselect:
            UISFXCueDefinition(
                duration: 0.25,
                baseMidi: 70,
                notes: [Note(at: 0, semitone: 4, length: 0.09), Note(at: 0.075, semitone: -2, length: 0.15)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .toggleOn:
            UISFXCueDefinition(
                duration: 0.3,
                baseMidi: 67,
                notes: [Note(at: 0, semitone: -3, length: 0.065, glide: -1), Note(at: 0.065, semitone: 9, length: 0.2)],
                noise: 0,
                transient: 0.3,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .toggleOff:
            UISFXCueDefinition(
                duration: 0.29,
                baseMidi: 67,
                notes: [Note(at: 0, semitone: 9, length: 0.065), Note(at: 0.07, semitone: -3, length: 0.18, glide: -1)],
                noise: 0,
                transient: 0.28,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .check:
            UISFXCueDefinition(
                duration: 0.29,
                baseMidi: 71,
                notes: [Note(at: 0, semitone: -5, length: 0.075), Note(at: 0.07, semitone: 9, length: 0.17)],
                noise: 0,
                transient: 0.24,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .uncheck:
            UISFXCueDefinition(
                duration: 0.27,
                baseMidi: 71,
                notes: [Note(at: 0, semitone: 9, length: 0.07), Note(at: 0.065, semitone: -5, length: 0.15)],
                noise: 0,
                transient: 0.22,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .delete:
            UISFXCueDefinition(
                duration: 0.48,
                baseMidi: 58,
                notes: [Note(at: 0, semitone: 6, length: 0.2, glide: -7), Note(at: 0.16, semitone: -2, length: 0.24, gain: 0.6)],
                noise: 0.18,
                transient: 0.5,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .cancel:
            UISFXCueDefinition(
                duration: 0.34,
                baseMidi: 64,
                notes: [Note(at: 0, semitone: 3, length: 0.11), Note(at: 0.08, semitone: -3, length: 0.2, glide: -2)],
                noise: 0.05,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .undo:
            UISFXCueDefinition(
                duration: 0.44,
                baseMidi: 67,
                notes: [Note(at: 0, semitone: 9, length: 0.16, glide: -3), Note(at: 0.15, semitone: 4, length: 0.14), Note(at: 0.27, semitone: -2, length: 0.13, gain: 0.62)],
                noise: 0,
                transient: 0,
                panFrom: 0.45,
                panTo: -0.45,
                loop: false
            )
        case .redo:
            UISFXCueDefinition(
                duration: 0.44,
                baseMidi: 67,
                notes: [Note(at: 0, semitone: -2, length: 0.13, gain: 0.62), Note(at: 0.12, semitone: 4, length: 0.14), Note(at: 0.25, semitone: 9, length: 0.16, glide: 2)],
                noise: 0,
                transient: 0,
                panFrom: -0.45,
                panTo: 0.45,
                loop: false
            )
        case .copy:
            UISFXCueDefinition(
                duration: 0.3,
                baseMidi: 70,
                notes: [Note(at: 0, semitone: 0, length: 0.14), Note(at: 0.1, semitone: 12, length: 0.15, gain: 0.48)],
                noise: 0,
                transient: 0,
                panFrom: -0.2,
                panTo: 0.2,
                loop: false
            )
        case .paste:
            UISFXCueDefinition(
                duration: 0.36,
                baseMidi: 67,
                notes: [Note(at: 0, semitone: 12, length: 0.08, gain: 0.3), Note(at: 0.065, semitone: 0, length: 0.19), Note(at: 0.17, semitone: 3, length: 0.14, gain: 0.42)],
                noise: 0,
                transient: 0.22,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .open:
            UISFXCueDefinition(
                duration: 0.37,
                baseMidi: 64,
                notes: [Note(at: 0, semitone: -2, length: 0.28, glide: 9), Note(at: 0.18, semitone: 12, length: 0.11, gain: 0.3)],
                noise: 0.05,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .close:
            UISFXCueDefinition(
                duration: 0.34,
                baseMidi: 64,
                notes: [Note(at: 0, semitone: 12, length: 0.1, gain: 0.34), Note(at: 0.055, semitone: 5, length: 0.24, glide: -8)],
                noise: 0.04,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .back:
            UISFXCueDefinition(
                duration: 0.3,
                baseMidi: 66,
                notes: [Note(at: 0, semitone: 3, length: 0.23, glide: -5)],
                noise: 0.08,
                transient: 0,
                panFrom: 0.35,
                panTo: -0.55,
                loop: false
            )
        case .forward:
            UISFXCueDefinition(
                duration: 0.31,
                baseMidi: 66,
                notes: [Note(at: 0, semitone: -5, length: 0.12, glide: 3, gain: 0.55), Note(at: 0.09, semitone: 4, length: 0.17)],
                noise: 0.06,
                transient: 0,
                panFrom: -0.35,
                panTo: 0.55,
                loop: false
            )
        case .expand:
            UISFXCueDefinition(
                duration: 0.37,
                baseMidi: 64,
                notes: [Note(at: 0, semitone: 0, length: 0.12), Note(at: 0.11, semitone: 4, length: 0.13), Note(at: 0.22, semitone: 9, length: 0.12, gain: 0.52)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0.35,
                loop: false
            )
        case .collapse:
            UISFXCueDefinition(
                duration: 0.35,
                baseMidi: 64,
                notes: [Note(at: 0, semitone: 9, length: 0.11, gain: 0.52), Note(at: 0.1, semitone: 4, length: 0.12), Note(at: 0.2, semitone: 0, length: 0.12)],
                noise: 0,
                transient: 0,
                panFrom: 0.35,
                panTo: 0,
                loop: false
            )
        case .dragStart:
            UISFXCueDefinition(
                duration: 0.28,
                baseMidi: 57,
                notes: [Note(at: 0, semitone: -2, length: 0.22, glide: 6)],
                noise: 0.14,
                transient: 0.3,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .drop:
            UISFXCueDefinition(
                duration: 0.3,
                baseMidi: 55,
                notes: [Note(at: 0, semitone: 7, length: 0.1, gain: 0.4), Note(at: 0.045, semitone: 0, length: 0.17, glide: -5), Note(at: 0.12, semitone: -5, length: 0.13, gain: 0.38)],
                noise: 0.18,
                transient: 0.6,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .snap:
            UISFXCueDefinition(
                duration: 0.16,
                baseMidi: 73,
                notes: [Note(at: 0, semitone: 0, length: 0.1), Note(at: 0.045, semitone: 12, length: 0.08, gain: 0.45)],
                noise: 0,
                transient: 0.75,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .swipe:
            UISFXCueDefinition(
                duration: 0.38,
                baseMidi: 69,
                notes: [Note(at: 0.02, semitone: -4, length: 0.29, glide: 8, gain: 0.28)],
                noise: 0.38,
                transient: 0.08,
                panFrom: -0.7,
                panTo: 0.7,
                loop: false
            )
        case .reorder:
            UISFXCueDefinition(
                duration: 0.34,
                baseMidi: 61,
                notes: [Note(at: 0, semitone: 7, length: 0.1, glide: -2), Note(at: 0.085, semitone: 2, length: 0.1), Note(at: 0.17, semitone: 0, length: 0.13)],
                noise: 0.08,
                transient: 0.38,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .invalidDrop:
            UISFXCueDefinition(
                duration: 0.4,
                baseMidi: 59,
                notes: [Note(at: 0, semitone: 1, length: 0.11), Note(at: 0.12, semitone: -4, length: 0.13), Note(at: 0.24, semitone: 1, length: 0.11, glide: -2, gain: 0.65)],
                noise: 0.14,
                transient: 0.3,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .send:
            UISFXCueDefinition(
                duration: 0.42,
                baseMidi: 69,
                notes: [Note(at: 0, semitone: -2, length: 0.28, glide: 9), Note(at: 0.19, semitone: 12, length: 0.16, gain: 0.6)],
                noise: 0.16,
                transient: 0,
                panFrom: -0.2,
                panTo: 0.5,
                loop: false
            )
        case .receive:
            UISFXCueDefinition(
                duration: 0.47,
                baseMidi: 72,
                notes: [Note(at: 0, semitone: 12, length: 0.12, gain: 0.42), Note(at: 0.11, semitone: 4, length: 0.2, glide: -2), Note(at: 0.25, semitone: 0, length: 0.17, gain: 0.62)],
                noise: 0.06,
                transient: 0,
                panFrom: 0.45,
                panTo: 0,
                loop: false
            )
        case .notification:
            UISFXCueDefinition(
                duration: 0.58,
                baseMidi: 72,
                notes: [Note(at: 0, semitone: 0, length: 0.26), Note(at: 0.19, semitone: 5, length: 0.3)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .mention:
            UISFXCueDefinition(
                duration: 0.64,
                baseMidi: 74,
                notes: [Note(at: 0, semitone: 0, length: 0.18), Note(at: 0.16, semitone: 4, length: 0.18), Note(at: 0.32, semitone: 9, length: 0.25)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .typing:
            UISFXCueDefinition(
                duration: 0.045,
                baseMidi: 73,
                notes: [Note(at: 0, semitone: 0, length: 0.024, glide: -1)],
                noise: 0.025,
                transient: 0.18,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .reaction:
            UISFXCueDefinition(
                duration: 0.4,
                baseMidi: 75,
                notes: [Note(at: 0, semitone: 0, length: 0.1), Note(at: 0.075, semitone: 12, length: 0.13, gain: 0.62), Note(at: 0.18, semitone: 7, length: 0.16)],
                noise: 0,
                transient: 0.16,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .success:
            UISFXCueDefinition(
                duration: 0.72,
                baseMidi: 67,
                notes: [Note(at: 0, semitone: 0, length: 0.3), Note(at: 0.16, semitone: 4, length: 0.32), Note(at: 0.33, semitone: 7, length: 0.33)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .error:
            UISFXCueDefinition(
                duration: 0.62,
                baseMidi: 62,
                notes: [Note(at: 0, semitone: 6, length: 0.28), Note(at: 0.22, semitone: 0, length: 0.32, glide: -2)],
                noise: 0.1,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .warning:
            UISFXCueDefinition(
                duration: 0.68,
                baseMidi: 65,
                notes: [Note(at: 0, semitone: 0, length: 0.22), Note(at: 0.28, semitone: 0, length: 0.3)],
                noise: 0,
                transient: 0.2,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .info:
            UISFXCueDefinition(
                duration: 0.46,
                baseMidi: 70,
                notes: [Note(at: 0, semitone: 0, length: 0.18), Note(at: 0.2, semitone: 5, length: 0.18, gain: 0.58)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .blocked:
            UISFXCueDefinition(
                duration: 0.43,
                baseMidi: 57,
                notes: [Note(at: 0, semitone: -5, length: 0.13), Note(at: 0.14, semitone: -5, length: 0.2, glide: -2)],
                noise: 0.12,
                transient: 0.44,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .retry:
            UISFXCueDefinition(
                duration: 0.42,
                baseMidi: 64,
                notes: [Note(at: 0, semitone: -2, length: 0.17, glide: 4), Note(at: 0.16, semitone: 5, length: 0.21)],
                noise: 0.06,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .start:
            UISFXCueDefinition(
                duration: 0.46,
                baseMidi: 60,
                notes: [Note(at: 0, semitone: -5, length: 0.12, gain: 0.48), Note(at: 0.1, semitone: 0, length: 0.18), Note(at: 0.24, semitone: 7, length: 0.18)],
                noise: 0.04,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .stop:
            UISFXCueDefinition(
                duration: 0.4,
                baseMidi: 60,
                notes: [Note(at: 0, semitone: 7, length: 0.11), Note(at: 0.1, semitone: 2, length: 0.12), Note(at: 0.2, semitone: -5, length: 0.15, gain: 0.72)],
                noise: 0.06,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .progressStep:
            UISFXCueDefinition(
                duration: 0.23,
                baseMidi: 72,
                notes: [Note(at: 0, semitone: 0, length: 0.07), Note(at: 0.085, semitone: 3, length: 0.1, gain: 0.64)],
                noise: 0.02,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .complete:
            UISFXCueDefinition(
                duration: 0.8,
                baseMidi: 65,
                notes: [Note(at: 0, semitone: 0, length: 0.22), Note(at: 0.22, semitone: 7, length: 0.25), Note(at: 0.46, semitone: 12, length: 0.27)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .queued:
            UISFXCueDefinition(
                duration: 0.36,
                baseMidi: 64,
                notes: [Note(at: 0, semitone: 0, length: 0.14), Note(at: 0.13, semitone: 2, length: 0.18, gain: 0.65)],
                noise: 0.04,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .checkpoint:
            UISFXCueDefinition(
                duration: 0.5,
                baseMidi: 69,
                notes: [Note(at: 0, semitone: 0, length: 0.18), Note(at: 0.14, semitone: 5, length: 0.18), Note(at: 0.28, semitone: 9, length: 0.17, gain: 0.6)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .loading:
            UISFXCueDefinition(
                duration: 1.2,
                baseMidi: 72,
                notes: [Note(at: 0, semitone: 0, length: 0.16), Note(at: 0.3, semitone: 5, length: 0.16), Note(at: 0.6, semitone: 2, length: 0.16), Note(at: 0.9, semitone: 7, length: 0.16)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: true
            )
        case .processing:
            UISFXCueDefinition(
                duration: 1.6,
                baseMidi: 62,
                notes: [Note(at: 0, semitone: 0, length: 0.24), Note(at: 0.4, semitone: 5, length: 0.2, gain: 0.7), Note(at: 0.8, semitone: 2, length: 0.24), Note(at: 1.2, semitone: 7, length: 0.2, gain: 0.7)],
                noise: 0.05,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: true
            )
        case .recording:
            UISFXCueDefinition(
                duration: 1,
                baseMidi: 67,
                notes: [Note(at: 0, semitone: 0, length: 0.2), Note(at: 0.5, semitone: 0, length: 0.14, gain: 0.45)],
                noise: 0,
                transient: 0.08,
                panFrom: 0,
                panTo: 0,
                loop: true
            )
        case .connecting:
            UISFXCueDefinition(
                duration: 1.5,
                baseMidi: 69,
                notes: [Note(at: 0, semitone: 0, length: 0.18), Note(at: 0.375, semitone: 4, length: 0.18), Note(at: 0.75, semitone: 7, length: 0.2), Note(at: 1.125, semitone: 4, length: 0.16, gain: 0.55)],
                noise: 0,
                transient: 0,
                panFrom: -0.3,
                panTo: 0.3,
                loop: true
            )
        case .scanning:
            UISFXCueDefinition(
                duration: 1.4,
                baseMidi: 72,
                notes: [Note(at: 0, semitone: -5, length: 0.28, glide: 8, gain: 0.55), Note(at: 0.7, semitone: 3, length: 0.28, glide: -8, gain: 0.45)],
                noise: 0.12,
                transient: 0,
                panFrom: -0.65,
                panTo: 0.65,
                loop: true
            )
        case .streaming:
            UISFXCueDefinition(
                duration: 1.2,
                baseMidi: 65,
                notes: [Note(at: 0, semitone: 0, length: 0.2), Note(at: 0.3, semitone: 7, length: 0.16, gain: 0.5), Note(at: 0.6, semitone: 2, length: 0.2), Note(at: 0.9, semitone: 9, length: 0.16, gain: 0.5)],
                noise: 0.08,
                transient: 0,
                panFrom: -0.2,
                panTo: 0.2,
                loop: true
            )
        case .play:
            UISFXCueDefinition(
                duration: 0.34,
                baseMidi: 67,
                notes: [Note(at: 0, semitone: -5, length: 0.09, gain: 0.52), Note(at: 0.075, semitone: 0, length: 0.11), Note(at: 0.16, semitone: 7, length: 0.13, gain: 0.72)],
                noise: 0,
                transient: 0.2,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .pause:
            UISFXCueDefinition(
                duration: 0.32,
                baseMidi: 67,
                notes: [Note(at: 0, semitone: 4, length: 0.11), Note(at: 0.13, semitone: 4, length: 0.13)],
                noise: 0,
                transient: 0.25,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .seek:
            UISFXCueDefinition(
                duration: 0.3,
                baseMidi: 72,
                notes: [Note(at: 0, semitone: -5, length: 0.105, glide: 2, gain: 0.55), Note(at: 0.115, semitone: 5, length: 0.12, glide: 2, gain: 0.72)],
                noise: 0.15,
                transient: 0,
                panFrom: -0.55,
                panTo: 0.55,
                loop: false
            )
        case .volumeChange:
            UISFXCueDefinition(
                duration: 0.24,
                baseMidi: 76,
                notes: [Note(at: 0, semitone: -4, length: 0.055, gain: 0.45), Note(at: 0.055, semitone: 0, length: 0.065, gain: 0.62), Note(at: 0.115, semitone: 4, length: 0.08)],
                noise: 0.02,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .skipNext:
            UISFXCueDefinition(
                duration: 0.29,
                baseMidi: 70,
                notes: [Note(at: 0, semitone: 0, length: 0.075, gain: 0.58), Note(at: 0.07, semitone: 4, length: 0.085), Note(at: 0.145, semitone: 12, length: 0.105, gain: 0.78)],
                noise: 0,
                transient: 0,
                panFrom: -0.35,
                panTo: 0.55,
                loop: false
            )
        case .skipPrevious:
            UISFXCueDefinition(
                duration: 0.29,
                baseMidi: 70,
                notes: [Note(at: 0, semitone: 12, length: 0.075, gain: 0.78), Note(at: 0.07, semitone: 4, length: 0.085), Note(at: 0.145, semitone: 0, length: 0.105, gain: 0.58)],
                noise: 0,
                transient: 0,
                panFrom: 0.55,
                panTo: -0.35,
                loop: false
            )
        case .connect:
            UISFXCueDefinition(
                duration: 0.62,
                baseMidi: 64,
                notes: [Note(at: 0, semitone: 0, length: 0.22), Note(at: 0.18, semitone: 5, length: 0.23), Note(at: 0.37, semitone: 12, length: 0.18, gain: 0.55)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .disconnect:
            UISFXCueDefinition(
                duration: 0.58,
                baseMidi: 64,
                notes: [Note(at: 0, semitone: 12, length: 0.21), Note(at: 0.18, semitone: 5, length: 0.22), Note(at: 0.34, semitone: 0, length: 0.18, gain: 0.6)],
                noise: 0.06,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .lock:
            UISFXCueDefinition(
                duration: 0.34,
                baseMidi: 55,
                notes: [Note(at: 0, semitone: 4, length: 0.14, glide: -4), Note(at: 0.11, semitone: 0, length: 0.17, gain: 0.7)],
                noise: 0,
                transient: 0.55,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .unlock:
            UISFXCueDefinition(
                duration: 0.45,
                baseMidi: 62,
                notes: [Note(at: 0, semitone: -2, length: 0.1), Note(at: 0.095, semitone: 5, length: 0.14), Note(at: 0.21, semitone: 12, length: 0.18, glide: 2)],
                noise: 0,
                transient: 0.3,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .wake:
            UISFXCueDefinition(
                duration: 0.46,
                baseMidi: 61,
                notes: [Note(at: 0, semitone: -5, length: 0.31, glide: 9), Note(at: 0.24, semitone: 7, length: 0.16, gain: 0.45)],
                noise: 0.06,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .sleep:
            UISFXCueDefinition(
                duration: 0.48,
                baseMidi: 61,
                notes: [Note(at: 0, semitone: 7, length: 0.26, glide: -7), Note(at: 0.21, semitone: -2, length: 0.2, gain: 0.5)],
                noise: 0.08,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .reward:
            UISFXCueDefinition(
                duration: 0.64,
                baseMidi: 76,
                notes: [Note(at: 0, semitone: 0, length: 0.22), Note(at: 0.1, semitone: 12, length: 0.24), Note(at: 0.26, semitone: 7, length: 0.29)],
                noise: 0,
                transient: 0.35,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .levelUp:
            UISFXCueDefinition(
                duration: 0.92,
                baseMidi: 64,
                notes: [Note(at: 0, semitone: 0, length: 0.24), Note(at: 0.17, semitone: 4, length: 0.25), Note(at: 0.34, semitone: 7, length: 0.26), Note(at: 0.51, semitone: 12, length: 0.32)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .achievement:
            UISFXCueDefinition(
                duration: 1.16,
                baseMidi: 62,
                notes: [Note(at: 0, semitone: 0, length: 0.34), Note(at: 0.16, semitone: 7, length: 0.34), Note(at: 0.34, semitone: 12, length: 0.38), Note(at: 0.56, semitone: 16, length: 0.42), Note(at: 0.73, semitone: 19, length: 0.38)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .streak:
            UISFXCueDefinition(
                duration: 0.72,
                baseMidi: 69,
                notes: [Note(at: 0, semitone: 0, length: 0.17), Note(at: 0.14, semitone: 2, length: 0.18), Note(at: 0.28, semitone: 4, length: 0.19), Note(at: 0.43, semitone: 7, length: 0.21)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .badge:
            UISFXCueDefinition(
                duration: 0.8,
                baseMidi: 71,
                notes: [Note(at: 0, semitone: 0, length: 0.19), Note(at: 0.14, semitone: 9, length: 0.23), Note(at: 0.33, semitone: 16, length: 0.35)],
                noise: 0,
                transient: 0.2,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .bonus:
            UISFXCueDefinition(
                duration: 0.86,
                baseMidi: 66,
                notes: [Note(at: 0, semitone: 0, length: 0.18), Note(at: 0.12, semitone: 4, length: 0.19), Note(at: 0.25, semitone: 9, length: 0.23), Note(at: 0.43, semitone: 16, length: 0.34)],
                noise: 0,
                transient: 0.3,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .addToCart:
            UISFXCueDefinition(
                duration: 0.49,
                baseMidi: 70,
                notes: [Note(at: 0, semitone: -2, length: 0.1, gain: 0.52), Note(at: 0.105, semitone: 7, length: 0.18), Note(at: 0.26, semitone: 2, length: 0.17, gain: 0.58)],
                noise: 0,
                transient: 0.28,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .removeFromCart:
            UISFXCueDefinition(
                duration: 0.45,
                baseMidi: 70,
                notes: [Note(at: 0, semitone: 10, length: 0.1, gain: 0.55), Note(at: 0.1, semitone: 3, length: 0.14), Note(at: 0.22, semitone: -2, length: 0.16, gain: 0.64)],
                noise: 0,
                transient: 0.22,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .checkout:
            UISFXCueDefinition(
                duration: 0.66,
                baseMidi: 65,
                notes: [Note(at: 0, semitone: 0, length: 0.22), Note(at: 0.18, semitone: 5, length: 0.23), Note(at: 0.35, semitone: 9, length: 0.24)],
                noise: 0,
                transient: 0,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .purchase:
            UISFXCueDefinition(
                duration: 0.76,
                baseMidi: 69,
                notes: [Note(at: 0, semitone: -5, length: 0.12), Note(at: 0.11, semitone: 0, length: 0.24), Note(at: 0.28, semitone: 7, length: 0.32)],
                noise: 0.12,
                transient: 0.55,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .coupon:
            UISFXCueDefinition(
                duration: 0.52,
                baseMidi: 72,
                notes: [Note(at: 0, semitone: 0, length: 0.16), Note(at: 0.13, semitone: 4, length: 0.18), Note(at: 0.26, semitone: 9, length: 0.21)],
                noise: 0,
                transient: 0.16,
                panFrom: 0,
                panTo: 0,
                loop: false
            )
        case .refund:
            UISFXCueDefinition(
                duration: 0.7,
                baseMidi: 67,
                notes: [Note(at: 0, semitone: 7, length: 0.24), Note(at: 0.19, semitone: 2, length: 0.25), Note(at: 0.39, semitone: 0, length: 0.23, gain: 0.65)],
                noise: 0,
                transient: 0,
                panFrom: 0.35,
                panTo: -0.2,
                loop: false
            )
        }
    }
}
