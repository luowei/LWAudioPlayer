# LWAudioPlayer Swift Version

This document describes how to use the Swift version of LWAudioPlayer.

## Overview

LWAudioPlayer_swift is a modern Swift implementation of the LWAudioPlayer library. It provides a type-safe, Swift-native API for audio playback with full support for SwiftUI, Combine framework, and modern async/await patterns.

## Requirements

- iOS 13.0+
- Swift 5.0+
- Xcode 11.0+

## Installation

### CocoaPods

Add the following line to your Podfile:

```ruby
pod 'LWAudioPlayer_swift'
```

Then run:
```bash
pod install
```

## Key Features

- **Swift-Native API** - Type-safe structs and enums instead of dictionaries
- **SwiftUI Integration** - Native SwiftUI views and modifiers
- **Combine Support** - Reactive audio state management with publishers
- **Async/Await** - Modern asynchronous audio loading and playback
- **Type Safety** - Full type safety with Swift's strong typing system
- **UIKit Bridge** - Seamless integration with UIKit views when needed

## Quick Start

### Basic Audio Playback

```swift
import LWAudioPlayer_swift

// Create an audio item
let audioItem = AudioItem(
    title: "Song Title",
    artist: "Artist Name",
    url: URL(string: "https://example.com/audio.mp3")!,
    artwork: UIImage(named: "artwork")
)

// Get the shared player manager
let player = AudioPlayerManager.shared

// Play the audio
player.play(audioItem)
```

### SwiftUI Integration

```swift
import SwiftUI
import LWAudioPlayer_swift

struct AudioPlayerView: View {
    @StateObject private var player = AudioPlayerManager.shared

    var body: some View {
        VStack {
            // Audio player controls
            AudioPlayerView(audioItem: audioItem)
                .frame(height: 200)

            // Playback controls
            HStack {
                Button(action: { player.previousTrack() }) {
                    Image(systemName: "backward.fill")
                }

                Button(action: { player.togglePlayPause() }) {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                }

                Button(action: { player.nextTrack() }) {
                    Image(systemName: "forward.fill")
                }
            }
            .font(.title)
        }
    }
}
```

### Using Combine Publishers

```swift
import Combine
import LWAudioPlayer_swift

class AudioViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0

    private var cancellables = Set<AnyCancellable>()

    init() {
        let player = AudioPlayerManager.shared

        // Subscribe to playback state
        player.$isPlaying
            .assign(to: &$isPlaying)

        // Subscribe to progress updates
        player.progressPublisher
            .sink { [weak self] progress in
                self?.currentTime = progress.current
                self?.duration = progress.duration
            }
            .store(in: &cancellables)
    }
}
```

## Advanced Usage

### Playback Speed Control

```swift
// Set playback speed
player.setPlaybackRate(1.5) // 1.5x speed

// Available speed presets
player.setPlaybackRate(0.5)  // Slow
player.setPlaybackRate(1.0)  // Normal
player.setPlaybackRate(1.5)  // Fast
player.setPlaybackRate(2.0)  // Very fast
```

### Loop and Repeat Modes

```swift
// Set repeat mode
player.repeatMode = .none      // No repeat
player.repeatMode = .one       // Repeat current track
player.repeatMode = .all       // Repeat all tracks
player.repeatMode = .shuffle   // Shuffle mode
```

### Seeking and Progress Control

```swift
// Seek to specific time
player.seek(to: 30.0) // Seek to 30 seconds

// Skip forward/backward
player.skipForward(by: 15)  // Skip forward 15 seconds
player.skipBackward(by: 15) // Skip backward 15 seconds

// Get current progress
let progress = player.currentProgress // Returns (current: TimeInterval, duration: TimeInterval)
```

### Playlist Management

```swift
// Create a playlist
let playlist = [
    AudioItem(title: "Track 1", url: track1URL),
    AudioItem(title: "Track 2", url: track2URL),
    AudioItem(title: "Track 3", url: track3URL)
]

// Load playlist
player.loadPlaylist(playlist)

// Navigate playlist
player.nextTrack()
player.previousTrack()

// Play specific track
player.playTrack(at: 1) // Play second track
```

### Background Playback

```swift
// Enable background playback
player.enableBackgroundPlayback()

// Configure lock screen controls
player.configureLockScreenControls(
    title: "Song Title",
    artist: "Artist Name",
    artwork: UIImage(named: "artwork")
)
```

## SwiftUI-Specific Features

### Audio Player View

```swift
struct ContentView: View {
    let audioItem = AudioItem(
        title: "My Song",
        artist: "My Artist",
        url: songURL
    )

    var body: some View {
        AudioPlayerView(audioItem: audioItem)
            .frame(height: 250)
            .cornerRadius(12)
            .padding()
    }
}
```

### Custom Player Controls

```swift
struct CustomPlayerView: View {
    @ObservedObject var player = AudioPlayerManager.shared

    var body: some View {
        VStack(spacing: 20) {
            // Progress bar
            ProgressView(value: player.currentProgress.current,
                        total: player.currentProgress.duration)

            // Time labels
            HStack {
                Text(timeString(player.currentProgress.current))
                Spacer()
                Text(timeString(player.currentProgress.duration))
            }
            .font(.caption)

            // Speed control
            Picker("Speed", selection: $player.playbackRate) {
                Text("0.5x").tag(0.5)
                Text("1.0x").tag(1.0)
                Text("1.5x").tag(1.5)
                Text("2.0x").tag(2.0)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    func timeString(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
```

## UIKit Integration

### Using AudioPlayerUIKitView

```swift
import UIKit
import LWAudioPlayer_swift

class PlayerViewController: UIViewController {
    private var playerView: AudioPlayerUIKitView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create audio item
        let audioItem = AudioItem(
            title: "Song Title",
            artist: "Artist Name",
            url: audioURL
        )

        // Setup player view
        playerView = AudioPlayerUIKitView(audioItem: audioItem)
        playerView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 200)
        view.addSubview(playerView)
    }
}
```

### Bridge to Objective-C

```swift
import LWAudioPlayer_swift

// Bridge for Objective-C compatibility
@objc class AudioPlayerBridge: NSObject {
    @objc static let shared = AudioPlayerBridge()

    @objc func playAudioAtURL(_ url: URL, title: String, artist: String) {
        let item = AudioItem(title: title, artist: artist, url: url)
        AudioPlayerManager.shared.play(item)
    }

    @objc func pause() {
        AudioPlayerManager.shared.pause()
    }

    @objc func resume() {
        AudioPlayerManager.shared.resume()
    }
}
```

## API Reference

### AudioItem

```swift
struct AudioItem {
    let id: UUID
    let title: String
    let artist: String?
    let album: String?
    let url: URL
    let artwork: UIImage?
    let duration: TimeInterval?
}
```

### AudioPlayerManager

```swift
class AudioPlayerManager: ObservableObject {
    static let shared: AudioPlayerManager

    @Published var isPlaying: Bool
    @Published var currentItem: AudioItem?
    @Published var playbackRate: Double
    @Published var repeatMode: RepeatMode

    var progressPublisher: AnyPublisher<Progress, Never>
    var currentProgress: (current: TimeInterval, duration: TimeInterval)

    func play(_ item: AudioItem)
    func pause()
    func resume()
    func stop()
    func seek(to time: TimeInterval)
    func skipForward(by interval: TimeInterval)
    func skipBackward(by interval: TimeInterval)
    func setPlaybackRate(_ rate: Double)
    func nextTrack()
    func previousTrack()
    func loadPlaylist(_ items: [AudioItem])
    func playTrack(at index: Int)
}
```

### RepeatMode

```swift
enum RepeatMode {
    case none
    case one
    case all
    case shuffle
}
```

### AudioPlayerConstants

```swift
enum AudioPlayerConstants {
    static let defaultSkipInterval: TimeInterval = 15.0
    static let defaultPlaybackRate: Double = 1.0
    static let minPlaybackRate: Double = 0.5
    static let maxPlaybackRate: Double = 2.0
}
```

## Best Practices

### 1. Use Publishers for State Updates

```swift
// Good - Reactive updates
player.$isPlaying
    .sink { isPlaying in
        updateUI(isPlaying: isPlaying)
    }
    .store(in: &cancellables)

// Avoid - Polling
Timer.publish(every: 0.1, on: .main, in: .common)
    .sink { _ in
        checkIfPlaying()
    }
```

### 2. Handle Audio Session Properly

```swift
// Configure audio session
do {
    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
    try AVAudioSession.sharedInstance().setActive(true)
} catch {
    print("Failed to setup audio session: \(error)")
}
```

### 3. Clean Up Resources

```swift
class PlayerView: UIView {
    private var cancellables = Set<AnyCancellable>()

    deinit {
        cancellables.removeAll()
        AudioPlayerManager.shared.stop()
    }
}
```

## Migration from Objective-C Version

### Before (Objective-C)
```objective-c
LWAudioPlayerManager *player = [LWAudioPlayerManager sharedManager];
[player playAudioWithURL:url title:@"Song" artist:@"Artist"];
```

### After (Swift)
```swift
let player = AudioPlayerManager.shared
let item = AudioItem(title: "Song", artist: "Artist", url: url)
player.play(item)
```

## Troubleshooting

**Q: Audio not playing in background**
- Ensure background audio capability is enabled in project settings
- Call `enableBackgroundPlayback()` on the player manager

**Q: SwiftUI views not updating**
- Make sure AudioPlayerManager is declared with `@StateObject` or `@ObservedObject`
- Check that you're subscribing to the correct publishers

**Q: Playback rate not changing**
- Verify the rate is within supported range (0.5 - 2.0)
- Some audio formats may not support variable speed playback

**Q: Lock screen controls not showing**
- Call `configureLockScreenControls()` with track metadata
- Ensure MPNowPlayingInfoCenter is properly configured

## Examples

Check the example project for complete implementations:

```bash
cd LWAudioPlayer/Example
pod install
open LWAudioPlayer.xcworkspace
```

The example includes:
- Basic audio playback
- SwiftUI player interface
- Playlist management
- Speed control
- Lock screen integration

## License

LWAudioPlayer_swift is available under the MIT license. See the LICENSE file for more information.

## Author

**luowei**
- Email: luowei@wodedata.com
- GitHub: [@luowei](https://github.com/luowei)
