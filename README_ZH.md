# LWAudioPlayer

[![CI Status](https://img.shields.io/travis/luowei/LWAudioPlayer.svg?style=flat)](https://travis-ci.org/luowei/LWAudioPlayer)
[![Version](https://img.shields.io/cocoapods/v/LWAudioPlayer.svg?style=flat)](https://cocoapods.org/pods/LWAudioPlayer)
[![License](https://img.shields.io/cocoapods/l/LWAudioPlayer.svg?style=flat)](https://cocoapods.org/pods/LWAudioPlayer)
[![Platform](https://img.shields.io/cocoapods/p/LWAudioPlayer.svg?style=flat)](https://cocoapods.org/pods/LWAudioPlayer)

[English Documentation](README.md)

## 项目描述

LWAudioPlayer 是一个适用于 iOS 的双核心音频播放器库，提供全面的音频播放功能。它支持前进/后退、循环播放、变速播放和锁屏控制等高级功能。基于 AVAudioPlayer 和 StreamingKit 构建，为各种场景提供灵活的音频播放解决方案。

## 功能特性

- **双音频引擎**: 支持 AVAudioPlayer 和 StreamingKit (STKAudioPlayer)
- **播放速度控制**: 使用加速/减速控制调整播放速度
- **循环播放**: 支持单曲循环播放
- **进度控制**: 前进、后退和精确定位功能
- **锁屏集成**: 从 iOS 锁屏更新和控制播放
- **播放列表管理**: 支持带有下一首/上一首导航的播放列表
- **UI 组件**: 预构建的可自定义界面音频播放器视图
- **委托模式**: 灵活的委托回调用于 UI 更新
- **后台播放**: 支持后台模式继续播放音频

## 系统要求

- iOS 8.0+
- Xcode 8.0+
- Objective-C

## 安装方法

### CocoaPods

LWAudioPlayer 可通过 [CocoaPods](https://cocoapods.org) 安装。只需在 Podfile 中添加以下行：

```ruby
pod 'LWAudioPlayer'
```

然后运行：
```bash
pod install
```

### Carthage

在 Cartfile 中添加以下行：

```ruby
github "luowei/LWAudioPlayer"
```

然后运行：
```bash
carthage update --platform iOS
```

## 使用方法

### 基本设置

导入头文件：

```objective-c
#import <LWAudioPlayer/LWAudioPlayer.h>
#import <LWAudioPlayer/LWAudioPlayerView.h>
```

### 使用 LWAudioPlayer

获取共享实例并播放音频：

```objective-c
LWAudioPlayer *player = [LWAudioPlayer sharedInstance];
player.playerViewDelegate = self;

// 使用 item 播放音频
ListItem *item = [[ListItem alloc] init];
item.title = @"音频标题";
item.url = @"http://example.com/audio.mp3";
[player playAudioWithItem:item];
```

### 使用 LWAudioPlayerView

将播放器视图添加到界面：

```objective-c
self.audioPlayerView = [LWAudioPlayerView new];
self.audioPlayerView.dataSource = self;
[self.view addSubview:self.audioPlayerView];
[self.audioPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.equalTo(self.view);
    make.height.mas_equalTo(75);
}];
```

### 实现数据源

```objective-c
#pragma mark - LWAudioPlayerDataSource

- (NSArray <ListItem *>*)flatItemList:(NSArray <ListItem *>*)itemList withType:(NSString *)type {
    // 返回你的播放列表数据
    return self.playlist;
}
```

### 实现委托

```objective-c
#pragma mark - LWAudioPlayerViewDelegate

- (void)updatePalyerTitleWithText:(NSString *)text {
    // 使用当前曲目标题更新 UI
    self.titleLabel.text = text;
}

- (void)updateAudioPlayerStatusAndProgressUI {
    // 更新进度条和播放状态
    // 在播放期间定期调用
}
```

### 播放控制

```objective-c
LWAudioPlayer *player = [LWAudioPlayer sharedInstance];

// 播放或暂停
[player playPuaseTrack];

// 下一首
[player nextTrack];

// 上一首
[player previousTrack];

// 停止播放
[player stop];

// 速度控制
[player speedUp];
[player speedDown];
```

### 锁屏集成

```objective-c
// 更新锁屏的正在播放信息
[player updateNowPlayingInfoWithElapsedPlaybackTime:@(currentTime)
                                        playbackRate:@(rate)];
```

### 访问资源包资源

访问资源包中的图片时：

```objective-c
#define LWImageBundle(obj) ([NSBundle bundleWithPath:[[NSBundle bundleForClass:[obj class]] pathForResource:@"LWAudioPlayer" ofType:@"bundle"]] ?: ([NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LWAudioPlayer" ofType:@"bundle"]] ?: [NSBundle mainBundle]))

#define UIImageWithName(name,obj) ([UIImage imageNamed:name inBundle:LWImageBundle(obj) compatibleWithTraitCollection:nil])
```

## API 文档

### LWAudioPlayer

主音频播放器类（单例）：

```objective-c
@interface LWAudioPlayer : UIResponder

@property (nonatomic, strong) STKAudioPlayer *audioPlayer;
@property (nonatomic, strong) ListItem *currentItem;
@property (nonatomic, weak) id<LWAudioPlayerViewDelegate> playerViewDelegate;
@property (nonatomic) NSArray <ListItem *> *itemList;
@property (nonatomic, strong) AVAudioPlayer* avplayer;

+ (LWAudioPlayer *)sharedInstance;

// 播放控制
- (void)playAudioWithItem:(ListItem *)item;
- (void)stop;
- (void)playPuaseTrack;
- (void)previousTrack;
- (void)nextTrack;

// 速度控制
- (void)speedDown;
- (void)speedUp;
- (void)av_speedDown;
- (void)av_speedUp;

// 定时器控制
- (void)schedulePlayerTimer;
- (void)playerTimerInvalidate;

// 循环模式
- (BOOL)isSingleLoop;

// 锁屏
- (void)updateNowPlayingInfoWithElapsedPlaybackTime:(NSNumber *)elapsedTime
                                        playbackRate:(NSNumber *)rate;

// AVAudioPlayer 特定方法
- (void)av_togglePlayPause;
- (void)av_stop;
- (void)av_refreshNoewPlayingInfo;
- (BOOL)av_isRuning;
- (BOOL)av_isPlaying;

// 清理
- (void)releaseAudioPlayer;

@end
```

### LWAudioPlayerViewDelegate

```objective-c
@protocol LWAudioPlayerViewDelegate <NSObject>

// 更新歌曲标题
- (void)updatePalyerTitleWithText:(NSString *)text;

// 更新进度和状态 UI
- (void)updateAudioPlayerStatusAndProgressUI;

@end
```

### ListItem

音频曲目信息模型：

```objective-c
@interface ListItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
// 曲目元数据的附加属性
@end
```

## 示例项目

要运行示例项目，请克隆仓库并首先从 Example 目录运行 `pod install`：

```bash
git clone https://github.com/luowei/LWAudioPlayer.git
cd LWAudioPlayer/Example
pod install
open LWAudioPlayer.xcworkspace
```

## 依赖库

- [Masonry](https://github.com/SnapKit/Masonry): 自动布局 DSL
- StreamingKit: 内置音频流引擎
- MarqueeLabel: 内置长标题滚动标签

## 作者

luowei, luowei@wodedata.com

## 许可证

LWAudioPlayer 基于 MIT 许可证开源。详见 LICENSE 文件。
