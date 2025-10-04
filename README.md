# LWAudioPlayer

[![CI Status](https://img.shields.io/travis/luowei/LWAudioPlayer.svg?style=flat)](https://travis-ci.org/luowei/LWAudioPlayer)
[![Version](https://img.shields.io/cocoapods/v/LWAudioPlayer.svg?style=flat)](https://cocoapods.org/pods/LWAudioPlayer)
[![License](https://img.shields.io/cocoapods/l/LWAudioPlayer.svg?style=flat)](https://cocoapods.org/pods/LWAudioPlayer)
[![Platform](https://img.shields.io/cocoapods/p/LWAudioPlayer.svg?style=flat)](https://cocoapods.org/pods/LWAudioPlayer)

[English](./README.md) | [中文版](./README_ZH.md) | [Swift Version](./README_SWIFT_VERSION.md)

---

## Overview

LWAudioPlayer is a dual-core audio player library for iOS that provides comprehensive audio playback capabilities. It supports advanced features including forward/backward seeking, loop playback, variable playback speed, and lock screen controls. Built on both AVAudioPlayer and StreamingKit, it offers flexible audio playback solutions for various scenarios.

## Features

### Core Capabilities
- **Dual Audio Engine**: Flexible audio playback powered by both AVAudioPlayer and StreamingKit (STKAudioPlayer)
- **Variable Speed Control**: Adjust playback speed dynamically with speed up/down controls
- **Loop Playback**: Single track loop playback support for repeated listening
- **Advanced Progress Control**: Forward, backward seeking, and precise position control

### Integration & UI
- **Lock Screen Integration**: Seamlessly control playback from iOS lock screen with metadata display
- **Playlist Management**: Complete playlist support with next/previous track navigation
- **Pre-built UI Components**: Ready-to-use audio player view with customizable interface
- **Delegate Pattern**: Comprehensive delegate callbacks for real-time UI updates

### Additional Features
- **Background Playback**: Uninterrupted audio playback in background mode
- **Resource Bundle Support**: Built-in image resources for player controls
- **Singleton Architecture**: Easy-to-use shared instance pattern

## Requirements

| Requirement | Version |
|------------|---------|
| iOS | 8.0+ |
| Xcode | 8.0+ |
| Language | Objective-C |

## Installation

### CocoaPods

LWAudioPlayer is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'LWAudioPlayer'
```

Then run:
```bash
pod install
```

### Carthage

Add the following line to your Cartfile:

```ruby
github "luowei/LWAudioPlayer"
```

Then run:
```bash
carthage update --platform iOS
```

## Usage

### Quick Start

#### 1. Import Headers

```objective-c
#import <LWAudioPlayer/LWAudioPlayer.h>
#import <LWAudioPlayer/LWAudioPlayerView.h>
```

#### 2. Basic Playback

Get the shared instance and play audio:

```objective-c
LWAudioPlayer *player = [LWAudioPlayer sharedInstance];
player.playerViewDelegate = self;

// Create and configure audio item
ListItem *item = [[ListItem alloc] init];
item.title = @"Audio Title";
item.url = @"http://example.com/audio.mp3";

// Start playback
[player playAudioWithItem:item];
```

#### 3. Add Player View (Optional)

Add the pre-built player view to your interface:

```objective-c
self.audioPlayerView = [LWAudioPlayerView new];
self.audioPlayerView.dataSource = self;
[self.view addSubview:self.audioPlayerView];
[self.audioPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.equalTo(self.view);
    make.height.mas_equalTo(75);
}];
```

### Advanced Usage

#### Implementing Data Source

Provide playlist data to the player view:

```objective-c
#pragma mark - LWAudioPlayerDataSource

- (NSArray <ListItem *>*)flatItemList:(NSArray <ListItem *>*)itemList withType:(NSString *)type {
    // Return your playlist data
    return self.playlist;
}
```

#### Implementing Delegate

Handle playback events and UI updates:

```objective-c
#pragma mark - LWAudioPlayerViewDelegate

- (void)updatePalyerTitleWithText:(NSString *)text {
    // Update UI with current track title
    self.titleLabel.text = text;
}

- (void)updateAudioPlayerStatusAndProgressUI {
    // Update progress bar and playback status
    // Called periodically during playback
}
```

#### Playback Controls

Control audio playback with simple method calls:

```objective-c
LWAudioPlayer *player = [LWAudioPlayer sharedInstance];

// Play or pause current track
[player playPuaseTrack];

// Navigate playlist
[player nextTrack];
[player previousTrack];

// Stop playback
[player stop];

// Adjust playback speed
[player speedUp];
[player speedDown];
```

#### Lock Screen Integration

Update lock screen controls with current playback information:

```objective-c
// Update now playing info for lock screen
[player updateNowPlayingInfoWithElapsedPlaybackTime:@(currentTime)
                                        playbackRate:@(rate)];
```

#### Resource Bundle Access

Access images from the resource bundle:

```objective-c
#define LWImageBundle(obj) ([NSBundle bundleWithPath:[[NSBundle bundleForClass:[obj class]] pathForResource:@"LWAudioPlayer" ofType:@"bundle"]] ?: ([NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LWAudioPlayer" ofType:@"bundle"]] ?: [NSBundle mainBundle]))

#define UIImageWithName(name,obj) ([UIImage imageNamed:name inBundle:LWImageBundle(obj) compatibleWithTraitCollection:nil])
```

## API Reference

### LWAudioPlayer

The main audio player class implemented as a singleton:

```objective-c
@interface LWAudioPlayer : UIResponder

// Audio engine instances
@property (nonatomic, strong) STKAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *avplayer;

// Current playback state
@property (nonatomic, strong) ListItem *currentItem;
@property (nonatomic) NSArray <ListItem *> *itemList;

// Delegate for UI updates
@property (nonatomic, weak) id<LWAudioPlayerViewDelegate> playerViewDelegate;
```

**Class Methods:**

```objective-c
// Get shared singleton instance
+ (LWAudioPlayer *)sharedInstance;
```

**Instance Methods:**

```objective-c
// Playback Control
- (void)playAudioWithItem:(ListItem *)item;  // Start playing audio item
- (void)stop;                                // Stop playback
- (void)playPuaseTrack;                      // Toggle play/pause
- (void)previousTrack;                       // Play previous track in playlist
- (void)nextTrack;                           // Play next track in playlist

// Speed Control (StreamingKit)
- (void)speedDown;                           // Decrease playback speed
- (void)speedUp;                             // Increase playback speed

// Speed Control (AVAudioPlayer)
- (void)av_speedDown;                        // Decrease AVPlayer speed
- (void)av_speedUp;                          // Increase AVPlayer speed

// Timer Management
- (void)schedulePlayerTimer;                 // Start playback timer
- (void)playerTimerInvalidate;               // Stop playback timer

// Loop Mode
- (BOOL)isSingleLoop;                        // Check if single loop is enabled

// Lock Screen Integration
- (void)updateNowPlayingInfoWithElapsedPlaybackTime:(NSNumber *)elapsedTime
                                        playbackRate:(NSNumber *)rate;

// AVAudioPlayer Specific Methods
- (void)av_togglePlayPause;                  // Toggle AVPlayer play/pause
- (void)av_stop;                             // Stop AVPlayer
- (void)av_refreshNoewPlayingInfo;           // Update AVPlayer now playing info
- (BOOL)av_isRuning;                         // Check if AVPlayer is running
- (BOOL)av_isPlaying;                        // Check if AVPlayer is playing

// Resource Management
- (void)releaseAudioPlayer;                  // Release player resources

@end
```

### LWAudioPlayerViewDelegate

Protocol for receiving playback events and UI update notifications:

```objective-c
@protocol LWAudioPlayerViewDelegate <NSObject>

- (void)updatePalyerTitleWithText:(NSString *)text;
// Called when track title changes

- (void)updateAudioPlayerStatusAndProgressUI;
// Called periodically to update progress and playback status

@end
```

### ListItem

Model class representing an audio track:

```objective-c
@interface ListItem : NSObject

@property (nonatomic, copy) NSString *title;  // Track title
@property (nonatomic, copy) NSString *url;    // Audio file URL (local or remote)

@end
```

## Example Project

To run the example project:

```bash
# Clone the repository
git clone https://github.com/luowei/LWAudioPlayer.git

# Navigate to Example directory
cd LWAudioPlayer/Example

# Install dependencies
pod install

# Open workspace
open LWAudioPlayer.xcworkspace
```

The example project demonstrates:
- Basic audio playback functionality
- Playlist management
- UI integration with LWAudioPlayerView
- Lock screen controls
- Speed control features

## Dependencies

LWAudioPlayer relies on the following dependencies:

| Dependency | Purpose | Status |
|-----------|---------|--------|
| [Masonry](https://github.com/SnapKit/Masonry) | Auto Layout DSL for constraint management | External |
| StreamingKit | Audio streaming engine for network playback | Built-in |
| MarqueeLabel | Scrolling label for displaying long track titles | Built-in |

## Contributing

Contributions are welcome! Please feel free to submit pull requests or create issues for bugs and feature requests.

## Author

**luowei**
Email: luowei@wodedata.com

## License

LWAudioPlayer is available under the MIT license. See the [LICENSE](LICENSE) file for more information.

---

**Made with ❤️ for iOS developers**
