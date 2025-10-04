# LWAudioPlayer Swift - Quick Start Guide

## Installation

Add the Swift files to your Xcode project:

1. Drag all `.swift` files from `LWAudioPlayer/Classes/` to your Xcode project
2. Ensure "Copy items if needed" is checked
3. Add to your target

## Basic Usage

### 1. Simple Playback

```swift
import LWAudioPlayer

// Get player instance
let player = LWAudioPlayerSwift.shared

// Create audio item
let audioItem = AudioItem(
    name: "MySong.mp3",
    type: AudioItemType.audio,
    itemPath: "/path/to/MySong.mp3"
)

// Play
player.play(audioItem)
```

### 2. SwiftUI Integration

```swift
import SwiftUI
import LWAudioPlayer

struct MyPlayerView: View {
    var body: some View {
        VStack {
            Text("My Audio Player")
                .font(.headline)

            // Audio player UI
            LWAudioPlayerSwift.createSwiftUIView()
                .frame(height: 140)
                .background(Color(.systemBackground))
        }
    }
}
```

### 3. UIKit Integration

```swift
import UIKit
import LWAudioPlayer

class PlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create player view
        let playerView = LWAudioPlayerSwift.createUIKitView()
        view.addSubview(playerView)

        // Setup constraints
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 140)
        ])

        // Setup playlist
        setupPlaylist()
    }

    func setupPlaylist() {
        let player = LWAudioPlayerSwift.shared

        let songs = [
            AudioItem(name: "Song1.mp3", type: AudioItemType.audio, itemPath: "/path/to/song1.mp3"),
            AudioItem(name: "Song2.mp3", type: AudioItemType.audio, itemPath: "/path/to/song2.mp3"),
            AudioItem(name: "Song3.mp3", type: AudioItemType.audio, itemPath: "/path/to/song3.mp3")
        ]

        player.itemList = songs
        player.play(songs[0])
    }
}
```

### 4. Playback Control

```swift
let player = LWAudioPlayerSwift.shared

// Play/Pause
player.togglePlayPause()

// Next/Previous
player.next()
player.previous()

// Stop
player.stop()

// Seek
player.seek(to: 60.0) // Jump to 1 minute

// Speed control
player.increaseSpeed()
player.decreaseSpeed()

// Loop mode
player.toggleLoopMode()
```

### 5. Monitoring Playback

```swift
import Combine

class MyPlayerController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    let player = LWAudioPlayerSwift.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        observePlayer()
    }

    func observePlayer() {
        // Observe current item
        AudioPlayerManager.shared.$currentItem
            .sink { item in
                print("Now playing: \(item?.name ?? "None")")
            }
            .store(in: &cancellables)

        // Observe progress
        AudioPlayerManager.shared.$progress
            .sink { progress in
                print("Progress: \(progress) seconds")
            }
            .store(in: &cancellables)

        // Observe playing state
        AudioPlayerManager.shared.$isPlaying
            .sink { isPlaying in
                print("Is playing: \(isPlaying)")
            }
            .store(in: &cancellables)
    }
}
```

### 6. Using Delegate Pattern

```swift
class MyViewController: UIViewController, AudioPlayerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        LWAudioPlayerSwift.shared.delegate = self
    }

    func updatePlayerTitle(with text: String) {
        // Update your UI with current track name
        navigationItem.title = text
    }

    func updateAudioPlayerStatusAndProgressUI() {
        // Update progress bar, time labels, etc.
        let player = LWAudioPlayerSwift.shared
        updateProgressLabel(current: player.progress, total: player.duration)
    }

    func updateProgressLabel(current: TimeInterval, total: TimeInterval) {
        // Your UI update logic
    }
}
```

### 7. Creating Playlist from Files

```swift
// From file URLs
let audioFiles: [URL] = [
    URL(fileURLWithPath: "/path/to/song1.mp3"),
    URL(fileURLWithPath: "/path/to/song2.mp3"),
    URL(fileURLWithPath: "/path/to/song3.mp3")
]

let playlist = LWAudioPlayerSwift.createAudioItems(from: audioFiles)
LWAudioPlayerSwift.shared.itemList = playlist
LWAudioPlayerSwift.shared.play(playlist[0])
```

### 8. Background Audio Setup

Add to your `Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

The audio session is automatically configured for background playback.

## Common Tasks

### Format Time Display

```swift
extension TimeInterval {
    func formatAsTime() -> String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = interval / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// Usage
let time = player.progress.formatAsTime() // "01:23"
```

### Lock Screen Controls

Lock screen controls are automatically configured and work out of the box. The now playing info includes:
- Track title
- Artist name
- Album title
- Artwork
- Playback position
- Duration

### Custom Speed Rates

```swift
// Get current speed
let speed = UserDefaults.standard.float(forKey: AudioPlayerKeys.speedRate)

// Set custom speed (0.1 - 3.0)
let customSpeed: Float = 1.5
AudioPlayerManager.shared.playbackRate = customSpeed
UserDefaults.standard.set(customSpeed, forKey: AudioPlayerKeys.speedRate)
```

### Check Playback State

```swift
let player = LWAudioPlayerSwift.shared

if player.isPlaying {
    print("Audio is playing")
} else {
    print("Audio is paused")
}

print("Current position: \(player.progress)")
print("Total duration: \(player.duration)")
print("Playback rate: \(player.playbackRate)x")
```

## Migration from Objective-C

### Before (Objective-C)

```objc
LWAudioPlayer *player = [LWAudioPlayer sharedInstance];
ListItem *item = [[ListItem alloc] initWithName:@"Song.mp3"
                                            type:@"audio"
                                        itemPath:@"/path/to/song.mp3"
                                        itemList:nil];
[player playAudioWithItem:item];
```

### After (Swift)

```swift
let player = LWAudioPlayerSwift.shared
let item = AudioItem(name: "Song.mp3",
                     type: AudioItemType.audio,
                     itemPath: "/path/to/song.mp3")
player.play(item)
```

## Troubleshooting

### Audio not playing
- Check file path is correct and file exists
- Verify audio session permissions
- Check device volume and mute switch
- Enable debug logging (see `AudioPlayerConstants.swift`)

### Lock screen controls not working
- Verify `UIBackgroundModes` includes "audio" in Info.plist
- Check that audio session category is set to `.playback`
- Ensure now playing info is being updated

### Memory issues
- Call `player.release()` when done
- Use weak references for delegates
- Don't retain player in multiple places

## Best Practices

1. Use singleton instance: `LWAudioPlayerSwift.shared`
2. Set up playlist before playing
3. Implement delegate for UI updates
4. Use Combine publishers for reactive updates
5. Handle audio interruptions (automatic)
6. Clean up when view disappears

## Support

For issues with the Swift implementation, check:
1. SWIFT_README.md for detailed documentation
2. Original Objective-C implementation for reference
3. Code comments in source files

## License

Same as LWAudioPlayer library.
Copyright (c) 2025 luowei. All rights reserved.
