//
//  AudioParam.swift
//  Cuelume
//
//  An offline stand-in for Web Audio's AudioParam automation timeline, so
//  recipes written against `setValueAtTime` / `linearRampToValueAtTime` /
//  `exponentialRampToValueAtTime` can be transcribed literally.
//  https://webaudio.github.io/web-audio-api/#AudioParam
//

import Foundation

/// One scheduled automation event on a parameter timeline.
struct AudioParamEvent: Sendable {
    enum Kind: Sendable {
        /// Steps to `value` at `time` and holds it.
        case setValue
        /// Ramps linearly from the previous event to `value`, arriving at `time`.
        case linearRamp
        /// Ramps exponentially from the previous event to `value`, arriving at `time`.
        case exponentialRamp
    }

    var kind: Kind
    var value: Double
    var time: Double

    static func setValue(_ value: Double, at time: Double) -> AudioParamEvent {
        AudioParamEvent(kind: .setValue, value: value, time: time)
    }

    static func linearRamp(to value: Double, at time: Double) -> AudioParamEvent {
        AudioParamEvent(kind: .linearRamp, value: value, time: time)
    }

    static func exponentialRamp(to value: Double, at time: Double) -> AudioParamEvent {
        AudioParamEvent(kind: .exponentialRamp, value: value, time: time)
    }
}

/// A parameter timeline that can be sampled at any point in time.
///
/// Event lists in these recipes are short (rarely more than a handful), so the
/// lookup is a linear scan rather than a binary search.
struct AudioParam: Sendable {
    private let events: [AudioParamEvent]
    private let defaultValue: Double

    init(default defaultValue: Double, events: [AudioParamEvent] = []) {
        self.defaultValue = defaultValue
        self.events = events.sorted { $0.time < $1.time }
    }

    /// A parameter that never changes.
    init(constant value: Double) {
        self.init(default: value)
    }

    func value(at time: Double) -> Double {
        guard let first = events.first else { return defaultValue }
        if time <= first.time { return first.value }

        var previous = first
        for event in events.dropFirst() {
            if time >= event.time {
                previous = event
                continue
            }
            // `time` falls between `previous` and `event`.
            switch event.kind {
            case .setValue:
                return previous.value
            case .linearRamp:
                return Self.linear(from: previous, to: event, at: time)
            case .exponentialRamp:
                return Self.exponential(from: previous, to: event, at: time)
            }
        }
        return previous.value
    }

    private static func linear(from start: AudioParamEvent, to end: AudioParamEvent, at time: Double) -> Double {
        let span = end.time - start.time
        guard span > 0 else { return end.value }
        let progress = (time - start.time) / span
        return start.value + (end.value - start.value) * progress
    }

    private static func exponential(from start: AudioParamEvent, to end: AudioParamEvent, at time: Double) -> Double {
        let span = end.time - start.time
        guard span > 0 else { return end.value }
        let progress = (time - start.time) / span
        // Web Audio requires both endpoints to be non-zero and same-signed; anything
        // else is not a valid exponential ramp, so fall back to a linear one.
        guard start.value > 0, end.value > 0 else {
            return start.value + (end.value - start.value) * progress
        }
        return start.value * pow(end.value / start.value, progress)
    }
}
