//
// AudioPlayerUIKitView.swift
// LWAudioPlayer
//
// Created by Swift Migration on 2025-10-03.
// Copyright (c) 2025 luowei. All rights reserved.
//

import UIKit
import SwiftUI

// MARK: - AudioPlayerUIKitView

/// UIKit wrapper for AudioPlayerView (SwiftUI)
/// This allows the SwiftUI view to be used in UIKit-based projects
public class AudioPlayerUIKitView: UIView {

    // MARK: - Properties

    public weak var dataSource: AudioPlayerDataSource? {
        didSet {
            // Update the SwiftUI view's data source if needed
        }
    }

    private var hostingController: UIHostingController<AudioPlayerView>?

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        let swiftUIView = AudioPlayerView()
        let hostingController = UIHostingController(rootView: swiftUIView)

        // Add as subview
        if let hostView = hostingController.view {
            hostView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(hostView)

            NSLayoutConstraint.activate([
                hostView.topAnchor.constraint(equalTo: topAnchor),
                hostView.leadingAnchor.constraint(equalTo: leadingAnchor),
                hostView.trailingAnchor.constraint(equalTo: trailingAnchor),
                hostView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

        self.hostingController = hostingController
    }

    // MARK: - Public Methods

    /// Play or pause the current track
    public func playOrPauseAction() {
        AudioPlayerManager.shared.togglePlayPause()
    }

    /// Play previous track
    public func playPreviousAction() {
        AudioPlayerManager.shared.previousTrack()
    }

    /// Play next track
    public func playNextAction() {
        AudioPlayerManager.shared.nextTrack()
    }

    /// Get the hosting controller (useful for adding to view controller hierarchy)
    public func getHostingController() -> UIViewController? {
        return hostingController
    }
}
