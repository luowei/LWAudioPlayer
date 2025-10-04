//
// LWAudioPlayerSwift.swift
// LWAudioPlayer
//
// Created by Swift Migration on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Public API

/// Main entry point for LWAudioPlayer Swift API
/// Use this class to access the audio player functionality
///
/// Example usage:
/// ```swift
/// let player = LWAudioPlayerSwift.shared
/// let item = AudioItem(name: "Song.mp3", type: "audio", itemPath: "/path/to/song.mp3")
/// player.play(item)
/// ```
public class LWAudioPlayerSwift {

    // MARK: - Singleton

    public static let shared = LWAudioPlayerSwift()

    // MARK: - Properties

    private let manager = AudioPlayerManager.shared

    /// Current playing item
    public var currentItem: AudioItem? {
        get { manager.currentItem }
        set { manager.currentItem = newValue }
    }

    /// Playlist items
    public var itemList: [AudioItem] {
        get { manager.itemList }
        set { manager.itemList = newValue }
    }

    /// Is currently playing
    public var isPlaying: Bool {
        manager.isPlaying
    }

    /// Current progress in seconds
    public var progress: TimeInterval {
        manager.progress
    }

    /// Total duration in seconds
    public var duration: TimeInterval {
        manager.duration
    }

    /// Current playback rate (0.1 - 3.0)
    public var playbackRate: Float {
        manager.playbackRate
    }

    /// Delegate for UI updates
    public weak var delegate: AudioPlayerDelegate? {
        get { manager.delegate }
        set { manager.delegate = newValue }
    }

    // MARK: - Initialization

    private init() {}

    // MARK: - Playback Control

    /// Play audio with specified item
    public func play(_ item: AudioItem) {
        manager.playAudio(with: item)
    }

    /// Toggle play/pause
    public func togglePlayPause() {
        manager.togglePlayPause()
    }

    /// Pause playback
    public func pause() {
        manager.pause()
    }

    /// Stop playback
    public func stop() {
        manager.stop()
    }

    /// Play previous track
    public func previous() {
        manager.previousTrack()
    }

    /// Play next track
    public func next() {
        manager.nextTrack()
    }

    /// Seek to specific time
    public func seek(to time: TimeInterval) {
        manager.seek(to: time)
    }

    // MARK: - Speed Control

    /// Increase playback speed
    public func increaseSpeed() {
        manager.speedUp()
    }

    /// Decrease playback speed
    public func decreaseSpeed() {
        manager.speedDown()
    }

    // MARK: - Loop Mode

    /// Check if single loop mode is enabled
    public var isSingleLoop: Bool {
        manager.isSingleLoop
    }

    /// Toggle single loop mode
    public func toggleLoopMode() {
        manager.toggleLoopMode()
    }

    // MARK: - Cleanup

    /// Release audio player resources
    public func release() {
        manager.releaseAudioPlayer()
    }
}

// MARK: - SwiftUI View Factory

public extension LWAudioPlayerSwift {

    /// Create a SwiftUI audio player view
    /// - Returns: AudioPlayerView for use in SwiftUI
    static func createSwiftUIView() -> some View {
        AudioPlayerView()
    }

    /// Create a UIKit-compatible audio player view
    /// - Returns: UIView that wraps the SwiftUI player
    static func createUIKitView() -> AudioPlayerUIKitView {
        AudioPlayerUIKitView()
    }
}

// MARK: - Convenience Methods

public extension LWAudioPlayerSwift {

    /// Create an audio item from a file URL
    static func createAudioItem(from url: URL, name: String? = nil) -> AudioItem {
        let fileName = name ?? url.lastPathComponent
        return AudioItem(
            name: fileName,
            type: AudioItemType.audio,
            itemPath: url.path
        )
    }

    /// Create audio items from multiple file URLs
    static func createAudioItems(from urls: [URL]) -> [AudioItem] {
        urls.map { url in
            createAudioItem(from: url)
        }
    }
}

// MARK: - Objective-C Compatibility

public extension LWAudioPlayerSwift {

    /// Get Objective-C compatible bridge instance
    static var objcBridge: AudioPlayerBridge {
        AudioPlayerBridge.sharedInstance
    }
}
