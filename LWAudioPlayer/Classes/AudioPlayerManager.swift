//
// AudioPlayerManager.swift
// LWAudioPlayer
//
// Created by Swift Migration on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import Combine

// MARK: - AudioPlayerDelegate

public protocol AudioPlayerDelegate: AnyObject {
    /// Called when the player title should be updated
    func updatePlayerTitle(with text: String)

    /// Called to update the audio player status and progress UI
    func updateAudioPlayerStatusAndProgressUI()
}

// MARK: - AudioPlayerManager

public class AudioPlayerManager: NSObject, ObservableObject {

    // MARK: - Singleton

    public static let shared = AudioPlayerManager()

    // MARK: - Published Properties

    @Published public var currentItem: AudioItem?
    @Published public var itemList: [AudioItem] = []
    @Published public var isPlaying: Bool = false
    @Published public var progress: TimeInterval = 0
    @Published public var duration: TimeInterval = 0
    @Published public var playbackRate: Float = 1.0

    // MARK: - Properties

    public weak var delegate: AudioPlayerDelegate?

    private var audioPlayer: AVAudioPlayer?
    private var playerTimer: Timer?
    private var nowPlayingInfo: [String: Any] = [:]
    private var artwork: MPMediaItemArtwork?

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    private override init() {
        super.init()
        setupAudioSession()
        setupRemoteCommandCenter()
        setupNotifications()
        loadSpeedRate()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        releaseAudioPlayer()
        AudioLog("AudioPlayerManager deinitialized")
    }

    // MARK: - Setup

    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
            try session.setMode(.default)
            try session.setCategory(.playback, mode: .default)
        } catch {
            AudioLog("Audio session setup error: \(error)")
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(audioPlayDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }

        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.previousTrack()
            return .success
        }

        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.nextTrack()
            return .success
        }

        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let self = self,
                  let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            self.seek(to: event.positionTime)
            return .success
        }
    }

    private func loadSpeedRate() {
        let rate = UserDefaults.standard.float(forKey: AudioPlayerKeys.speedRate)
        if rate >= 0.1 && rate <= 3.0 {
            playbackRate = rate
        } else {
            playbackRate = 1.0
            UserDefaults.standard.set(1.0, forKey: AudioPlayerKeys.speedRate)
        }
    }

    // MARK: - Playback Control

    /// Play audio with the specified item
    public func playAudio(with item: AudioItem) {
        invalidateTimer()

        // If playing the same item, toggle play/pause
        if let currentItem = currentItem, currentItem.itemPath == item.itemPath {
            if isPlaying {
                pause()
            } else {
                resume()
            }
            return
        }

        // Create new player
        guard !item.itemPath.isEmpty else { return }

        do {
            let url = URL(fileURLWithPath: item.itemPath)
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.enableRate = true
            player.rate = playbackRate

            audioPlayer = player
            self.currentItem = item
            self.duration = player.duration

            player.play()
            isPlaying = true

            scheduleTimer()
            updateNowPlayingInfo()

            // Notify delegate
            delegate?.updatePlayerTitle(with: item.name.deletingPathExtension)
            delegate?.updateAudioPlayerStatusAndProgressUI()

        } catch {
            AudioLog("Failed to play audio: \(error)")
        }
    }

    /// Toggle play/pause
    public func togglePlayPause() {
        if let currentItem = currentItem, currentItem.type == AudioItemType.audio {
            playAudio(with: currentItem)
        } else if !itemList.isEmpty {
            playAudio(with: itemList[0])
        }
    }

    /// Play
    private func play() {
        guard let player = audioPlayer else { return }
        player.rate = playbackRate
        player.play()
        isPlaying = true
        scheduleTimer()
        updateNowPlayingInfo()
    }

    /// Resume playback
    private func resume() {
        play()
    }

    /// Pause playback
    public func pause() {
        audioPlayer?.pause()
        isPlaying = false
        updateNowPlayingInfo()
    }

    /// Stop playback
    public func stop() {
        audioPlayer?.stop()
        isPlaying = false
        progress = 0
        invalidateTimer()
        updateNowPlayingInfo()
    }

    /// Play previous track
    public func previousTrack() {
        guard !itemList.isEmpty else {
            if let item = currentItem {
                playAudio(with: item)
            }
            return
        }

        guard let current = currentItem else {
            playAudio(with: itemList[0])
            return
        }

        // Find previous item
        if let currentIndex = itemList.firstIndex(where: { $0.itemPath == current.itemPath }) {
            let previousIndex = currentIndex > 0 ? currentIndex - 1 : itemList.count - 1
            playAudio(with: itemList[previousIndex])
        }
    }

    /// Play next track
    public func nextTrack() {
        guard !itemList.isEmpty else {
            AudioLog("itemList is empty")
            if let item = currentItem {
                playAudio(with: item)
            }
            return
        }

        guard let current = currentItem else {
            AudioLog("currentItem is nil")
            playAudio(with: itemList[0])
            return
        }

        // Find next item
        if let currentIndex = itemList.firstIndex(where: { $0.itemPath == current.itemPath }) {
            let nextIndex = currentIndex < itemList.count - 1 ? currentIndex + 1 : 0
            playAudio(with: itemList[nextIndex])
        }
    }

    /// Seek to time
    public func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        progress = time
        updateNowPlayingInfo()
    }

    // MARK: - Speed Control

    /// Increase playback speed
    public func speedUp() {
        var rate = UserDefaults.standard.float(forKey: AudioPlayerKeys.speedRate)
        if rate <= 3.0 {
            rate += 0.1
        } else {
            rate = 3.0
        }
        setSpeed(rate)
    }

    /// Decrease playback speed
    public func speedDown() {
        var rate = UserDefaults.standard.float(forKey: AudioPlayerKeys.speedRate)
        if rate > 0.1 {
            rate -= 0.1
        } else {
            rate = 0.1
        }
        setSpeed(rate)
    }

    /// Set playback speed
    private func setSpeed(_ rate: Float) {
        playbackRate = rate
        audioPlayer?.rate = rate
        UserDefaults.standard.set(rate, forKey: AudioPlayerKeys.speedRate)
    }

    // MARK: - Loop Mode

    /// Check if single loop mode is enabled
    public var isSingleLoop: Bool {
        UserDefaults.standard.bool(forKey: AudioPlayerKeys.isSingleLoop)
    }

    /// Toggle single loop mode
    public func toggleLoopMode() {
        let current = isSingleLoop
        UserDefaults.standard.set(!current, forKey: AudioPlayerKeys.isSingleLoop)
    }

    // MARK: - Timer Management

    private func scheduleTimer() {
        guard playerTimer == nil else { return }
        playerTimer = Timer.scheduledTimer(
            withTimeInterval: 0.01,
            repeats: true
        ) { [weak self] _ in
            self?.updateUI()
        }
    }

    private func invalidateTimer() {
        playerTimer?.invalidate()
        playerTimer = nil
    }

    @objc private func updateUI() {
        if let player = audioPlayer {
            progress = player.currentTime
            duration = player.duration
        }
        updateNowPlayingInfo()
        delegate?.updateAudioPlayerStatusAndProgressUI()
    }

    // MARK: - Now Playing Info

    private func updateNowPlayingInfo() {
        guard let item = currentItem else { return }

        if artwork == nil {
            if let image = AudioPlayerBundle.image(named: "Artwork_Image", for: type(of: self)) {
                artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            }
        }

        var info: [String: Any] = [:]
        info[MPMediaItemPropertyTitle] = item.name.deletingPathExtension
        info[MPMediaItemPropertyArtist] = item.artist ?? ""
        info[MPMediaItemPropertyAlbumTitle] = item.albumTitle ?? ""
        if let artwork = artwork {
            info[MPMediaItemPropertyArtwork] = artwork
        }
        info[MPMediaItemPropertyPlaybackDuration] = duration
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = progress
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? playbackRate : 0.0

        if SystemVersion.isGreaterThanOrEqualTo("10.0") {
            info[MPNowPlayingInfoPropertyPlaybackProgress] = duration > 0 ? progress / duration : 0
            info[MPNowPlayingInfoPropertyMediaType] = MPNowPlayingInfoMediaType.audio.rawValue
        }

        nowPlayingInfo = info
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    // MARK: - Cleanup

    public func releaseAudioPlayer() {
        audioPlayer?.stop()
        audioPlayer = nil
        invalidateTimer()
    }

    // MARK: - Notification Handlers

    @objc private func audioPlayDidEnd(_ notification: Notification) {
        AudioLog("Audio playback ended")
        if isSingleLoop, let item = currentItem {
            playAudio(with: item)
        } else {
            nextTrack()
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayerManager: AVAudioPlayerDelegate {

    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isSingleLoop, let item = currentItem {
            playAudio(with: item)
        } else {
            nextTrack()
        }
    }

    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        AudioLog("Audio player decode error: \(String(describing: error))")
        stop()
    }

    public func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        if isPlaying {
            pause()
        }
    }

    public func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        if !isPlaying {
            resume()
        }
    }
}

// MARK: - String Extension

extension String {
    var deletingPathExtension: String {
        (self as NSString).deletingPathExtension
    }
}
