//
// AudioPlayerBridge.swift
// LWAudioPlayer
//
// Created by Swift Migration on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import Foundation
import AVFoundation

// MARK: - AudioPlayerBridge

/// Bridge class to provide Objective-C compatible API
/// This class maintains API compatibility with the original LWAudioPlayer
@objc public class AudioPlayerBridge: NSObject {

    // MARK: - Singleton

    @objc public static let sharedInstance = AudioPlayerBridge()

    // MARK: - Properties

    private let manager = AudioPlayerManager.shared

    @objc public weak var playerViewDelegate: AudioPlayerBridgeDelegate?

    @objc public var currentItem: AudioItem? {
        get { manager.currentItem }
        set { manager.currentItem = newValue }
    }

    @objc public var itemList: [AudioItem] {
        get { manager.itemList }
        set { manager.itemList = newValue }
    }

    // MARK: - Initialization

    private override init() {
        super.init()
        setupDelegateForwarding()
    }

    // MARK: - Setup

    private func setupDelegateForwarding() {
        manager.delegate = self
    }

    // MARK: - Playback Control

    /// Play audio with specified item
    @objc public func playAudio(with item: AudioItem) {
        manager.playAudio(with: item)
    }

    /// Stop playback
    @objc public func stop() {
        manager.stop()
    }

    /// Toggle play/pause
    @objc public func playPauseTrack() {
        manager.togglePlayPause()
    }

    /// Play previous track
    @objc public func previousTrack() {
        manager.previousTrack()
    }

    /// Play next track
    @objc public func nextTrack() {
        manager.nextTrack()
    }

    // MARK: - Speed Control

    /// Decrease playback speed
    @objc public func speedDown() {
        manager.speedDown()
    }

    /// Increase playback speed
    @objc public func speedUp() {
        manager.speedUp()
    }

    // MARK: - Timer Management

    /// Schedule player timer
    @objc public func schedulePlayerTimer() {
        // Timer is automatically managed in Swift version
    }

    /// Invalidate player timer
    @objc public func playerTimerInvalidate() {
        // Timer is automatically managed in Swift version
    }

    // MARK: - Loop Mode

    /// Check if single loop mode is enabled
    @objc public func isSingleLoop() -> Bool {
        return manager.isSingleLoop
    }

    // MARK: - Now Playing

    /// Update now playing info with elapsed time and playback rate
    @objc public func updateNowPlayingInfo(
        withElapsedPlaybackTime elapsedTime: NSNumber,
        playbackRate rate: NSNumber
    ) {
        // Now playing info is automatically managed in Swift version
    }

    // MARK: - Cleanup

    /// Release audio player
    @objc public func releaseAudioPlayer() {
        manager.releaseAudioPlayer()
    }

    // MARK: - Legacy AVPlayer Support (for compatibility)

    @objc public func av_togglePlayPause() {
        manager.togglePlayPause()
    }

    @objc public func av_stop() {
        manager.stop()
    }

    @objc public func av_refreshNowPlayingInfo() {
        // Now playing info is automatically managed
    }

    @objc public func av_isRunning() -> Bool {
        return manager.audioPlayer != nil
    }

    @objc public func av_isPlaying() -> Bool {
        return manager.isPlaying
    }

    @objc public func av_speedDown() {
        manager.speedDown()
    }

    @objc public func av_speedUp() {
        manager.speedUp()
    }
}

// MARK: - AudioPlayerDelegate

extension AudioPlayerBridge: AudioPlayerDelegate {

    public func updatePlayerTitle(with text: String) {
        playerViewDelegate?.updatePlayerTitle?(with: text)
    }

    public func updateAudioPlayerStatusAndProgressUI() {
        playerViewDelegate?.updateAudioPlayerStatusAndProgressUI?()
    }
}

// MARK: - AudioPlayerBridgeDelegate

/// Objective-C compatible delegate protocol
@objc public protocol AudioPlayerBridgeDelegate: AnyObject {

    /// Update player title
    @objc optional func updatePlayerTitle(with text: String)

    /// Update audio player status and progress UI
    @objc optional func updateAudioPlayerStatusAndProgressUI()
}

// MARK: - AudioItem Objective-C Bridge

extension AudioItem {

    /// Create AudioItem from Objective-C (convenience initializer)
    @objc public convenience init(
        name: String,
        type: String,
        itemPath: String,
        itemList: [AudioItem]?,
        artist: String?,
        albumTitle: String?
    ) {
        self.init(name: name, type: type, itemPath: itemPath, itemList: itemList)
        self.artist = artist
        self.albumTitle = albumTitle
    }

    /// Get UTI (Objective-C compatible)
    @objc public func getUTI() -> String {
        return uti()
    }
}
