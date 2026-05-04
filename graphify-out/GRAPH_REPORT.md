# Graph Report - /Users/luowei/projects/libs/LWAudioPlayer  (2026-05-04)

## Corpus Check
- Corpus is ~37,054 words - fits in a single context window. You may not need a graph.

## Summary
- 622 nodes · 648 edges · 26 communities detected
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 11 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]

## God Nodes (most connected - your core abstractions)
1. `MarqueeLabel` - 111 edges
2. `STKAudioPlayer` - 100 edges
3. `LWAudioPlayer` - 50 edges
4. `AudioPlayerManager` - 33 edges
5. `AudioPlayerBridge` - 26 edges
6. `STKHTTPDataSource` - 25 edges
7. `STKAutoRecoveringHTTPDataSource` - 24 edges
8. `LWAudioPlayerView` - 19 edges
9. `LWAudioPlayerSwift` - 17 edges
10. `STKCoreFoundationDataSource` - 16 edges

## Surprising Connections (you probably didn't know these)
- `AudioPlayerDelegate` --inherits--> `AnyObject`  [EXTRACTED]
  LWAudioPlayer_swift/Classes/AudioPlayerManager.swift →   _Bridges community 3 → community 9_
- `AudioPlayerManager` --inherits--> `NSObject`  [EXTRACTED]
  LWAudioPlayer_swift/Classes/AudioPlayerManager.swift →   _Bridges community 3 → community 4_

## Communities (44 total, 0 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.02
Nodes (111): MarqueeLabel, -animationDidStopfinished, -applyGradientMaskForFadeLengthanimated, -attributedText, -awakeFromNib, -awayFromHome, -backgroundColor, -baselineAdjustment (+103 more)

### Community 1 - "Community 1"
Cohesion: 0.02
Nodes (100): STKAudioPlayer, -addFrameFilterwithNameafterFilterWithName, -addFrameFilterWithNameafterFilterWithNameblock, -appendFrameFilterWithNameblock, -audioGraphIsRunning, -audioQueueFinishedPlaying, -averagePowerInDecibelsForChannel, -clearQueue (+92 more)

### Community 2 - "Community 2"
Cohesion: 0.04
Nodes (50): LWAudioPlayer, -addPlayerNotificationObserver, -appDidReceiveRemoteControlNotification, -audioPlayDidEnd, -audioPlayer, -audioPlayerBeginInterruption, -audioPlayerDecodeErrorDidOccurerror, -audioPlayerdidFinishBufferingSourceWithQueueItemId (+42 more)

### Community 3 - "Community 3"
Cohesion: 0.13
Nodes (6): AVAudioPlayerDelegate, AudioLog(), AudioPlayerDelegate, AudioPlayerManager, String, ObservableObject

### Community 4 - "Community 4"
Cohesion: 0.07
Nodes (7): AudioPlayerDelegate, AudioItem, AudioItemType, AudioItem, AudioPlayerBridge, Codable, NSObject

### Community 5 - "Community 5"
Cohesion: 0.08
Nodes (3): AudioPlayerUIKitView, LWAudioPlayerSwift, UIView

### Community 6 - "Community 6"
Cohesion: 0.08
Nodes (25): LWAudioPlayerView, -dealloc, -doubleToNSStringTime, -init, -isDarkStyle, -playModeAction, -playNextAction, -playOrPuaseAction (+17 more)

### Community 7 - "Community 7"
Cohesion: 0.08
Nodes (25): STKHTTPDataSource, -audioFileTypeHint, -audioFileTypeHintFromMimeType, -dataAvailable, -dealloc, -description, -eventsRunLoop, -httpStatusCode (+17 more)

### Community 8 - "Community 8"
Cohesion: 0.08
Nodes (24): STKAutoRecoveringHTTPDataSource, -attemptReconnectWithSerial, -attemptReconnectWithTimer, -close, -createTimeoutTimer, -dataSourceDataAvailable, -dataSourceEof, -dataSourceErrorOccured (+16 more)

### Community 9 - "Community 9"
Cohesion: 0.1
Nodes (9): AnyObject, AudioPlayerBridgeDelegate, AudioPlayerDataSource, AudioPlayerView, AudioPlayerView_Previews, MarqueeText, String, PreviewProvider (+1 more)

### Community 10 - "Community 10"
Cohesion: 0.11
Nodes (17): CoreFoundationDataSourceClientInfo, STKCoreFoundationDataSource, -close, -dataAvailable, -dealloc, -eof, -errorOccured, -hasBytesAvailable (+9 more)

### Community 11 - "Community 11"
Cohesion: 0.12
Nodes (16): STKDataSourceWrapper, -audioFileTypeHint, -close, -dataSourceDataAvailable, -dataSourcedidReadStreamMetadata, -dataSourceEof, -dataSourceErrorOccured, -dealloc (+8 more)

### Community 12 - "Community 12"
Cohesion: 0.15
Nodes (12): STKLocalFileDataSource, -audioFileTypeHint, -audioFileTypeHintFromFileExtension, -close, -dealloc, -description, -initWithFilePath, -length (+4 more)

### Community 13 - "Community 13"
Cohesion: 0.17
Nodes (11): STKDataSource, -audioFileTypeHint, -close, -hasBytesAvailable, -length, -position, -readIntoBufferwithSize, -registerForEvents (+3 more)

### Community 14 - "Community 14"
Cohesion: 0.2
Nodes (9): STKQueueEntry, -audioDataLengthInBytes, -calculatedBitRate, -description, -duration, -initWithDataSourceandQueueItemId, -isDefinitelyCompatible, -progressInFrames (+1 more)

### Community 15 - "Community 15"
Cohesion: 0.25
Nodes (7): LWAppDelegate, -applicationDidBecomeActive, -applicationDidEnterBackground, -applicationdidFinishLaunchingWithOptions, -applicationWillEnterForeground, -applicationWillResignActive, -applicationWillTerminate

### Community 16 - "Community 16"
Cohesion: 0.29
Nodes (4): AudioPlayerBundle, AudioPlayerKeys, ScreenDimensions, SystemVersion

### Community 17 - "Community 17"
Cohesion: 0.25
Nodes (3): UIImage, UIResponder, UIView

### Community 18 - "Community 18"
Cohesion: 0.25
Nodes (7): ListItem, -copyWithZone, -encodeWithCoder, -initWithCoder, -initWithNametypeitemPathitemList, -mutableCopyWithZone, -uti

### Community 19 - "Community 19"
Cohesion: 0.29
Nodes (7): CAMediaTimingFunction, -controlPoints, -derivativeYValueForCurveAtwithControlPoints, -durationPercentageForPositionPercentagewithDuration, -solveTForYwithEpsiloncontrolPoints, -XforCurveAtwithControlPoints, -YforCurveAtwithControlPoints

### Community 20 - "Community 20"
Cohesion: 0.29
Nodes (6): NSMutableArray, -dequeue, -enqueue, -peek, -skipQueue, -skipQueueWithQueue

### Community 21 - "Community 21"
Cohesion: 0.33
Nodes (5): UIImage, -lwaudio_imageWithOverlayColor, UIView, -lwaudio_rotationToInterfaceOrientation, -lwaudio_superViewWithClass

### Community 22 - "Community 22"
Cohesion: 0.4
Nodes (4): Tests, -setUp, -tearDown, -testExample

### Community 23 - "Community 23"
Cohesion: 0.4
Nodes (4): GradientSetupAnimation, UIView, -firstAvailableViewController, -traverseResponderChainForFirstViewController

### Community 24 - "Community 24"
Cohesion: 0.4
Nodes (4): STKFrameFilterEntry, -filter, -initWithFilterandName, -name

### Community 25 - "Community 25"
Cohesion: 0.5
Nodes (3): LWViewController, -flatItemListwithType, -viewDidLoad

## Knowledge Gaps
- **426 isolated node(s):** `-setUp`, `-tearDown`, `-testExample`, `-applicationdidFinishLaunchingWithOptions`, `-applicationWillResignActive` (+421 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `MarqueeLabel` connect `Community 0` to `Community 23`?**
  _High betweenness centrality (0.038) - this node is a cross-community bridge._
- **Why does `STKAudioPlayer` connect `Community 1` to `Community 24`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **Why does `AudioPlayerView` connect `Community 9` to `Community 5`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **What connects `-setUp`, `-tearDown`, `-testExample` to the rest of the system?**
  _426 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.02 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.02 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._