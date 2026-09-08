//
//  SoundCache.swift
//  Cuelume
//
//  The palette is now large enough (nearly a thousand sounds once the uisfx
//  matrix is included) that rendering everything up front is not an option.
//  Buffers are rendered on first use and kept until a byte budget is reached,
//  then the least recently played one is dropped.
//

import Foundation

struct SoundCache {
    /// How many bytes of rendered audio to hold. Roughly a hundred short cues.
    private let budget: Int
    private var entries: [CuelumeSound: RenderedSound] = [:]
    /// Least recently used first.
    private var recency: [CuelumeSound] = []
    private var bytes = 0

    init(budget: Int = 8 * 1024 * 1024) {
        self.budget = budget
    }

    var count: Int { entries.count }
    var byteCount: Int { bytes }

    /// Returns the cached render, or renders and stores one.
    mutating func sound(for sound: CuelumeSound, sampleRate: Double) -> RenderedSound {
        if let cached = entries[sound] {
            touch(sound)
            return cached
        }
        let rendered = sound.render(sampleRate: sampleRate)
        insert(rendered, for: sound)
        return rendered
    }

    mutating func removeAll() {
        entries.removeAll()
        recency.removeAll()
        bytes = 0
    }

    private mutating func touch(_ sound: CuelumeSound) {
        if let index = recency.firstIndex(of: sound) {
            recency.remove(at: index)
        }
        recency.append(sound)
    }

    private mutating func insert(_ rendered: RenderedSound, for sound: CuelumeSound) {
        entries[sound] = rendered
        bytes += rendered.byteCount
        touch(sound)
        // A single sound always stays, even if it is larger than the whole budget.
        while bytes > budget, recency.count > 1 {
            let evicted = recency.removeFirst()
            if let dropped = entries.removeValue(forKey: evicted) {
                bytes -= dropped.byteCount
            }
        }
    }
}
