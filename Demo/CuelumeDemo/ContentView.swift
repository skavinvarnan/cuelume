//
//  ContentView.swift
//  cuelume
//
//  Created by Kavin Varnan on 07/09/26.
//

import Cuelume
import SwiftUI

struct ContentView: View {
    @State private var player = CuelumePlayer.shared

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Seventeen interaction sounds, synthesized on device the moment you tap. No MP3s, no WAVs.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)

                    HStack(spacing: 12) {
                        Image(systemName: "speaker.fill")
                            .foregroundStyle(.secondary)
                        Slider(value: $player.volume, in: 0...1)
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("Volume")
                }

                ForEach(SoundGroup.allCases) { group in
                    Section(group.rawValue) {
                        ForEach(group.sounds) { sound in
                            Button {
                                player.play(sound)
                            } label: {
                                SoundRow(sound: sound, isPlaying: player.playing == sound)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Play \(sound.rawValue)")
                            .accessibilityHint(sound.detail)
                        }
                    }
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
        }
    }
}

private struct SoundRow: View {
    let sound: SoundName
    let isPlaying: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: isPlaying ? "speaker.wave.2.fill" : "play.fill")
                .font(.body.weight(.semibold))
                .foregroundStyle(isPlaying ? Color.accentColor : Color.secondary)
                .frame(width: 28)
                .symbolEffect(.variableColor.iterative, options: .repeating, isActive: isPlaying)

            VStack(alignment: .leading, spacing: 3) {
                Text(sound.rawValue)
                    .font(.body.weight(.semibold).monospaced())
                    .foregroundStyle(.primary)
                Text(sound.detail)
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
