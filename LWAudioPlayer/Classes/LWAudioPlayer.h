//
// Created by luowei on 2017/4/12.
// Copyright (c) 2017 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@class STKAudioPlayer;
@class ListItem;
@class STKDataSource;

@protocol LWAudioPlayerViewDelegate<NSObject>

//更新歌曲标题
- (void)updatePalyerTitleWithText:(NSString *)text;

//追踪音乐播放进度
- (void)updateAudioPlayerStatusAndProgressUI;

@end

@interface LWAudioPlayer : UIResponder <AVAudioSessionDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) STKAudioPlayer *audioPlayer;

@property(nonatomic, strong) ListItem *currentItem;

@property (nonatomic, weak) id<LWAudioPlayerViewDelegate> playerViewDelegate;

@property(nonatomic) NSArray <ListItem *> *itemList;

@property (nonatomic, strong) AVAudioPlayer* avplayer;

+ (LWAudioPlayer *)sharedInstance;

//释放AudioPlayer
-(void)releaseAudioPlayer;

/*
 * 根据Item播放
 */
- (void)playAudioWithItem:(ListItem *)item;

- (void)stop;

//播放或暂停
- (void)playPuaseTrack;

- (void)previousTrack;

- (void)nextTrack;

//启动播放监听定时器
- (void)schedulePlayerTimer;

- (void)playerTimerInvalidate;

//是否为单曲循环
- (BOOL)isSingleLoop;

//更新锁屏时的播放信息
- (void)updateNowPlayingInfoWithElapsedPlaybackTime:(NSNumber *)elapsedTime playbackRate:(NSNumber *)rate;

- (void)av_togglePlayPause;
-(void)av_stop;
- (void)av_refreshNoewPlayingInfo;
//av是否在播放
-(BOOL)av_isRuning;
-(BOOL)av_isPlaying;

- (void)av_speedDown;
- (void)av_speedUp;

- (void)speedDown;
- (void)speedUp;

@end
