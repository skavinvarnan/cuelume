//
//  ContentView.swift
//  cuelume
//
//  Created by Kavin Varnan on 07/09/26.
//

import Cuelume
import SwiftUI

struct ContentView: View {
    private enum Library: String, CaseIterable, Identifiable {
        case cuelume = "CueLume"
        case seslen = "seslen"
        case uisfx = "uisfx"

        var id: String { rawValue }
    }

    @State private var player = CuelumePlayer.shared
    @State private var library: Library = .cuelume
    @State private var pack: UISFXPack = .minimal
    @State private var loop: CuelumePlayer.Playback?
    @State private var loopingCue: UISFXCue?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(blurb)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 4)

                    Picker("Library", selection: $library) {
                        ForEach(Library.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)

                    HStack(spacing: 12) {
                        Image(systemName: "speaker.fill")
                            .foregroundStyle(.secondary)
                        Slider(value: $player.volume, in: 0...1)
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("Volume")
                }

                switch library {
                case .cuelume: cuelumeSections
                case .seslen: seslenSection
                case .uisfx: uisfxSections
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Cuelume")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                if player.volume == 1 {
                    player.volume = 0.7
                }
            }
            .onChange(of: library) { _, _ in stopLoop() }
        }
    }

    private var blurb: String {
        switch library {
        case .cuelume:
            "Seventeen interaction sounds, synthesized on device the moment you tap. No MP3s, no WAVs."
        case .seslen:
            "Thirty-six seslen presets. Deliberately quiet — they are authored to sit under an interface."
        case .uisfx:
            "Seventy-eight uisfx cues in twelve packs. Pick a pack to hear the whole catalog in that voice."
        }
    }

    // MARK: - CueLume

    @ViewBuilder
    private var cuelumeSections: some View {
        ForEach(SoundGroup.allCases) { group in
            Section(group.rawValue) {
                ForEach(group.sounds) { sound in
                    Button {
                        player.play(sound)
                    } label: {
                        SoundRow(
                            name: sound.rawValue,
                            detail: sound.detail,
                            isPlaying: player.nowPlaying == .cuelume(sound)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Play \(sound.rawValue)")
                    .accessibilityHint(sound.detail)
                }
            }
        }
    }

    // MARK: - seslen

    @ViewBuilder
    private var seslenSection: some View {
        Section("Presets") {
            ForEach(SeslenSound.allCases) { sound in
                Button {
                    player.play(.seslen(sound))
                } label: {
                    SoundRow(
                        name: sound.rawValue,
                        detail: sound.recipeSummary,
                        isPlaying: player.nowPlaying == .seslen(sound)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Play \(sound.label)")
                .accessibilityHint(sound.detail)
            }
        }
    }

    // MARK: - uisfx

    @ViewBuilder
    private var uisfxSections: some View {
        Section("Pack") {
            Picker("Pack", selection: $pack) {
                ForEach(UISFXPack.allCases) { Text($0.label).tag($0) }
            }
            .pickerStyle(.menu)
            Text(pack.detail)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text("Best for \(pack.bestFor.lowercased())")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }

        ForEach(UISFXCategory.allCases) { category in
            Section(category.label) {
                ForEach(category.cues) { cue in
                    Button {
                        toggle(cue)
                    } label: {
                        SoundRow(
                            name: cue.rawValue,
                            detail: cue.detail,
                            isPlaying: isSounding(cue),
                            accessory: cue.isLoop ? (loopingCue == cue ? "stop.fill" : "repeat") : nil
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Play \(cue.label)")
                    .accessibilityHint(cue.detail)
                }
            }
        }
    }

    private func isSounding(_ cue: UISFXCue) -> Bool {
        if cue.isLoop { return loopingCue == cue }
        return player.nowPlaying == .uisfx(cue, pack: pack)
    }

    /// Loop cues stay running until they are tapped again.
    private func toggle(_ cue: UISFXCue) {
        guard cue.isLoop else {
            player.play(.uisfx(cue, pack: pack), volume: cue.suggestedVolume)
            return
        }
        if loopingCue == cue {
            stopLoop()
            return
        }
        stopLoop()
        loop = player.play(.uisfx(cue, pack: pack), volume: cue.suggestedVolume)
        loopingCue = loop == nil ? nil : cue
    }

    private func stopLoop() {
        if let loop {
            player.stop(loop)
        }
        loop = nil
        loopingCue = nil
    }
}

private struct SoundRow: View {
    let name: String
    let detail: String
    let isPlaying: Bool
    var accessory: String? = nil

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: isPlaying ? "speaker.wave.2.fill" : (accessory ?? "play.fill"))
                .font(.body.weight(.semibold))
                .foregroundStyle(isPlaying ? Color.accentColor : Color.secondary)
                .frame(width: 28)
                .symbolEffect(.variableColor.iterative, options: .repeating, isActive: isPlaying)

            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.body.weight(.semibold).monospaced())
                    .foregroundStyle(.primary)
                Text(detail)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

#Preview {
    ContentView()
}
