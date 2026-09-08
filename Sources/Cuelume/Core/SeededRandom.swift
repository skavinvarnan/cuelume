//
//  SeededRandom.swift
//  Cuelume
//
//  FNV-1a plus mulberry32, ported bit-for-bit from the uisfx generator so a cue
//  renders the same noise here as it does in the JavaScript original. Seeding the
//  noise also means a rendered buffer is reproducible, which is what lets the
//  engine cache it and the tests assert on it.
//

/// Deterministic 32-bit PRNG producing values in 0..<1.
struct SeededRandom: Sendable {
    private var state: UInt32

    init(seed: UInt32) {
        state = seed
    }

    init(seed: String) {
        self.init(seed: Self.hash(seed))
    }

    /// FNV-1a over the string's UTF-16 code units, matching `charCodeAt` in JavaScript.
    static func hash(_ value: String) -> UInt32 {
        var hash: UInt32 = 2_166_136_261
        for unit in value.utf16 {
            hash ^= UInt32(unit)
            hash = hash &* 16_777_619
        }
        return hash
    }

    mutating func next() -> Double {
        state = state &+ 0x6d2b_79f5
        var value = state
        value = (value ^ (value >> 15)) &* (value | 1)
        value ^= value &+ ((value ^ (value >> 7)) &* (value | 61))
        return Double(value ^ (value >> 14)) / 4_294_967_296
    }

    /// A sample of white noise in -1...1.
    mutating func nextBipolar() -> Double {
        next() * 2 - 1
    }
}
