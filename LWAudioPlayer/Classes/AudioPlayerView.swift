//
// AudioPlayerView.swift
// LWAudioPlayer
//
// Created by Swift Migration on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - AudioPlayerDataSource Protocol

public protocol AudioPlayerDataSource: AnyObject {
    /// Get flat item list with specified type
    func flatItemList(_ itemList: [AudioItem]?, withType type: String) -> [AudioItem]
}

// MARK: - AudioPlayerView (SwiftUI)

public struct AudioPlayerView: View {

    // MARK: - Environment

    @Environment(\.colorScheme) var colorScheme

    // MARK: - State

    @StateObject private var player = AudioPlayerManager.shared
    @State private var currentProgress: Double = 0
    @State private var isDragging: Bool = false
    @State private var speedRate: Float = 1.0
    @State private var isSingleLoop: Bool = false

    public weak var dataSource: AudioPlayerDataSource?

    // MARK: - Initialization

    public init() {}

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            // Top separator line
            Rectangle()
                .fill(separatorColor)
                .frame(height: 0.5)

            VStack(spacing: 12) {
                // Title label (scrolling marquee)
                MarqueeText(text: player.currentItem?.name.deletingPathExtension ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(primaryTextColor)
                    .padding(.horizontal, 8)
                    .padding(.top, 4)

                // Progress bar with time labels
                HStack(spacing: 8) {
                    Text(formatTime(currentProgress))
                        .font(.system(size: 12, weight: .thin))
                        .foregroundColor(secondaryTextColor)
                        .frame(width: 45, alignment: .leading)

                    Slider(
                        value: Binding(
                            get: { isDragging ? currentProgress : player.progress },
                            set: { newValue in
                                currentProgress = newValue
                                if !isDragging {
                                    player.seek(to: newValue)
                                }
                            }
                        ),
                        in: 0...max(player.duration, 1),
                        onEditingChanged: { dragging in
                            isDragging = dragging
                            if !dragging {
                                player.seek(to: currentProgress)
                            }
                        }
                    )
                    .accentColor(primaryTextColor)

                    Text(formatTime(player.duration))
                        .font(.system(size: 12, weight: .thin))
                        .foregroundColor(secondaryTextColor)
                        .frame(width: 45, alignment: .trailing)
                }
                .padding(.horizontal, 8)

                // Control buttons
                HStack(spacing: 25) {
                    // Loop mode button
                    Button(action: toggleLoopMode) {
                        Image(systemName: isSingleLoop ? "repeat.1" : "repeat")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(primaryTextColor)
                    }

                    Spacer()

                    // Speed down button
                    Button(action: speedDownAction) {
                        Image(systemName: "backward.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(primaryTextColor)
                    }

                    // Previous track button
                    Button(action: previousAction) {
                        Image(systemName: "backward.end.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(primaryTextColor)
                    }

                    // Play/Pause button
                    Button(action: playPauseAction) {
                        Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(primaryTextColor)
                    }

                    // Next track button
                    Button(action: nextAction) {
                        Image(systemName: "forward.end.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(primaryTextColor)
                    }

                    // Speed up button
                    Button(action: speedUpAction) {
                        Image(systemName: "forward.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(primaryTextColor)
                    }

                    Spacer()

                    // Share button
                    Button(action: shareAction) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(primaryTextColor)
                    }
                }
                .padding(.horizontal, 16)

                // Speed label
                Text(String(format: "%.1fx", speedRate))
                    .font(.system(size: 12, weight: .thin))
                    .foregroundColor(secondaryTextColor)
            }
            .padding(.vertical, 12)
        }
        .frame(height: 140)
        .background(backgroundColor)
        .onAppear {
            updateSpeedRate()
            updateLoopMode()
        }
        .onReceive(player.$progress) { _ in
            if !isDragging {
                currentProgress = player.progress
            }
        }
    }

    // MARK: - Colors

    private var backgroundColor: Color {
        colorScheme == .dark ? Color(UIColor.systemBackground) : Color(UIColor.systemBackground)
    }

    private var separatorColor: Color {
        colorScheme == .dark ? Color(UIColor.separator) : Color.gray.opacity(0.3)
    }

    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black
    }

    private var secondaryTextColor: Color {
        colorScheme == .dark ? .gray : Color(UIColor.darkGray)
    }

    // MARK: - Actions

    private func playPauseAction() {
        if player.itemList.isEmpty, let dataSource = dataSource {
            player.itemList = dataSource.flatItemList(nil, withType: AudioItemType.audio)
        }
        player.togglePlayPause()
    }

    private func previousAction() {
        if player.itemList.isEmpty, let dataSource = dataSource {
            player.itemList = dataSource.flatItemList(nil, withType: AudioItemType.audio)
        }
        player.previousTrack()
    }

    private func nextAction() {
        if player.itemList.isEmpty, let dataSource = dataSource {
            player.itemList = dataSource.flatItemList(nil, withType: AudioItemType.audio)
        }
        player.nextTrack()
    }

    private func speedDownAction() {
        player.speedDown()
        updateSpeedRate()
    }

    private func speedUpAction() {
        player.speedUp()
        updateSpeedRate()
    }

    private func toggleLoopMode() {
        player.toggleLoopMode()
        updateLoopMode()
    }

    private func shareAction() {
        guard let item = player.currentItem else { return }
        // Share functionality would be implemented via UIActivityViewController
        // This is a placeholder for SwiftUI integration
        AudioLog("Share action triggered for: \(item.name)")
    }

    // MARK: - Helpers

    private func updateSpeedRate() {
        speedRate = UserDefaults.standard.float(forKey: AudioPlayerKeys.speedRate)
        if speedRate < 0.1 || speedRate > 3.0 {
            speedRate = 1.0
        }
    }

    private func updateLoopMode() {
        isSingleLoop = UserDefaults.standard.bool(forKey: AudioPlayerKeys.isSingleLoop)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let interval = Int(time)
        let seconds = interval % 60
        let minutes = interval / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Marquee Text

struct MarqueeText: View {
    let text: String
    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Text(text + "   " + text)
                .fixedSize()
                .offset(x: offset)
                .onAppear {
                    let textSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 15)])
                    textWidth = textSize.width
                    if textWidth > geometry.size.width {
                        startScrolling()
                    }
                }
        }
        .frame(height: 20)
        .clipped()
    }

    private func startScrolling() {
        withAnimation(.linear(duration: Double(textWidth / 30)).repeatForever(autoreverses: false)) {
            offset = -textWidth - 15
        }
    }
}

extension String {
    func size(withAttributes attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let string = self as NSString
        return string.size(withAttributes: attributes)
    }
}

// MARK: - Preview

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerView()
            .previewLayout(.fixed(width: 375, height: 140))
    }
}
