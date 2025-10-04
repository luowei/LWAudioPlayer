# LWAudioPlayer - Swift/SwiftUI Implementation

This is a modern Swift/SwiftUI implementation of the LWAudioPlayer library, maintaining compatibility with the original Objective-C API while providing native Swift and SwiftUI interfaces.

## Features

- Modern Swift implementation using Combine framework
- Native SwiftUI views with live preview support
- UIKit compatibility layer for hybrid apps
- Objective-C bridge for backward compatibility
- Background audio playback support
- Lock screen controls (Now Playing Info)
- Variable playback speed (0.1x - 3.0x)
- Single loop and sequential playback modes
- Remote control center integration
- Audio session interruption handling

## Architecture

### Core Components

1. **AudioItem** - Data model representing an audio file
   - Replaces Objective-C `ListItem`
   - Swift `Codable` support
   - UTI type detection

2. **AudioPlayerManager** - Core playback engine
   - Singleton pattern with `@Published` properties
   - AVAudioPlayer-based implementation
   - Combine framework integration
   - Automatic timer management

3. **AudioPlayerView** - SwiftUI player interface
   - Declarative UI with state management
   - Marquee text scrolling
   - Dark mode support
   - Adaptive layout

4. **AudioPlayerUIKitView** - UIKit wrapper
   - UIHostingController-based wrapper
   - Drop-in replacement for UIKit projects
   - Auto Layout support

5. **AudioPlayerBridge** - Objective-C compatibility
   - `@objc` exposed APIs
   - Maintains original method signatures
   - Delegate pattern support

## Usage

### Swift (Modern API)

```swift
import LWAudioPlayer

// Get shared instance
let player = LWAudioPlayerSwift.shared

// Create audio item
let item = AudioItem(
    name: "MySong.mp3",
    type: AudioItemType.audio,
    itemPath: "/path/to/song.mp3"
)

// Play audio
player.play(item)

// Control playback
player.togglePlayPause()
player.next()
player.previous()

// Speed control
player.increaseSpeed()
player.decreaseSpeed()

// Seek
player.seek(to: 30.0) // 30 seconds

// Loop mode
player.toggleLoopMode()
```

### SwiftUI

```swift
import SwiftUI
import LWAudioPlayer

struct ContentView: View {
    var body: some View {
        VStack {
            // Your content

            // Audio player view
            LWAudioPlayerSwift.createSwiftUIView()
                .frame(height: 140)
        }
    }
}
```

### UIKit

```swift
import UIKit
import LWAudioPlayer

class ViewController: UIViewController {

    let playerView = LWAudioPlayerSwift.createUIKitView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add player view
        view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 140)
        ])

        // Setup playlist
        let player = LWAudioPlayerSwift.shared
        player.itemList = [
            AudioItem(name: "Song1.mp3", type: AudioItemType.audio, itemPath: "/path/to/song1.mp3"),
            AudioItem(name: "Song2.mp3", type: AudioItemType.audio, itemPath: "/path/to/song2.mp3")
        ]
    }
}
```

### Objective-C Bridge (Backward Compatibility)

```objc
#import "LWAudioPlayer-Swift.h"

// Get shared instance
AudioPlayerBridge *player = [AudioPlayerBridge sharedInstance];

// Create audio item
AudioItem *item = [[AudioItem alloc] initWithName:@"MySong.mp3"
                                             type:@"audio"
                                         itemPath:@"/path/to/song.mp3"
                                         itemList:nil];

// Play audio
[player playAudioWith:item];

// Control playback
[player playPauseTrack];
[player nextTrack];
[player previousTrack];
```

## Delegate Pattern

### Swift

```swift
class MyViewController: UIViewController, AudioPlayerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        LWAudioPlayerSwift.shared.delegate = self
    }

    func updatePlayerTitle(with text: String) {
        // Update UI with current track title
        print("Now playing: \(text)")
    }

    func updateAudioPlayerStatusAndProgressUI() {
        // Update progress UI
        let progress = LWAudioPlayerSwift.shared.progress
        let duration = LWAudioPlayerSwift.shared.duration
        print("Progress: \(progress) / \(duration)")
    }
}
```

## Differences from Objective-C Version

### Improvements

1. **Type Safety** - Swift's strong typing eliminates runtime errors
2. **Reactive Programming** - Combine framework for state management
3. **Memory Management** - Automatic reference counting, no manual retain/release
4. **Modern Patterns** - Protocol-oriented design, value types where appropriate
5. **SwiftUI Support** - Native declarative UI components

### API Changes

1. `ListItem` → `AudioItem` (renamed for clarity)
2. `playAudioWithItem:` → `play(_:)` (Swift naming conventions)
3. Timer management is now automatic (no manual `schedulePlayerTimer` needed)
4. Now Playing Info updates automatically

### Maintained Compatibility

- All original public methods available through `AudioPlayerBridge`
- Same delegate pattern (with Swift protocol)
- Identical playback behavior
- Same user defaults keys

## Requirements

- iOS 13.0+
- Swift 5.5+
- Xcode 13.0+

## Migration Guide

### For Pure Swift Projects

Replace Objective-C imports:
```swift
// Old
// #import "LWAudioPlayer.h"

// New
import LWAudioPlayer
let player = LWAudioPlayerSwift.shared
```

### For Mixed Swift/Objective-C Projects

Use the bridge:
```swift
// Access from Swift
let bridge = AudioPlayerBridge.sharedInstance

// Access from Objective-C
AudioPlayerBridge *bridge = [AudioPlayerBridge sharedInstance];
```

## File Structure

```
LWAudioPlayer/Classes/
├── AudioItem.swift                  # Audio item model
├── AudioPlayerConstants.swift       # Constants and helpers
├── AudioPlayerManager.swift         # Core playback engine
├── AudioPlayerView.swift            # SwiftUI player view
├── AudioPlayerUIKitView.swift       # UIKit wrapper
├── AudioPlayerExtensions.swift      # UIKit extensions
├── AudioPlayerBridge.swift          # Objective-C bridge
└── LWAudioPlayerSwift.swift         # Public API
```

## Notes

1. The Swift implementation uses `AVAudioPlayer` for local file playback
2. For streaming audio, the original `StreamingKit` dependency is not included in the Swift version
3. If you need streaming support, you can integrate the Objective-C `STKAudioPlayer` or use modern Swift streaming libraries
4. Dark mode is automatically supported in SwiftUI views

## License

Same as original LWAudioPlayer library.

Copyright (c) 2025 luowei. All rights reserved.
