//
// Created by luowei on 2017/4/12.
// Copyright (c) 2017 luowei. All rights reserved.
//
//参考：http://msching.github.io/blog/2014/11/06/audio-in-ios-8/
// https://github.com/MosheBerman/ios-audio-remote-control

#import "LWAudioPlayer.h"
#import "STKAudioPlayer.h"
#import "Defines.h"
#import "LWAudioPlayerView.h"
#import "ListItem.h"

@interface LWAudioPlayer ()<STKAudioPlayerDelegate>

@property(nonatomic, strong) MPMediaItemArtwork *artwork;
@property(nonatomic, strong) NSMutableDictionary *nowPlayingInfo;

@end

@implementation LWAudioPlayer {
    NSTimer *_playerTimer;

    BOOL _isav_Playing;
    BOOL _isav_Runing;
}

+ (LWAudioPlayer *)sharedInstance {
    __strong static LWAudioPlayer *sharedInstance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LWAudioPlayer alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {

        NSError *error;
        AVAudioSession *session=[AVAudioSession sharedInstance];
        session.delegate = self;  //waring:开启会导致在锁屏状态下10秒后切歌失败
        [session setActive:YES error:&error];
        [session setMode:AVAudioSessionModeDefault error:&error];
        [session setCategory:AVAudioSessionCategoryPlayback error:&error]; //后台播放
        if(error){
            LWAudioLog(@"====Error:%@",error);
        }

//        //允许应用程序接收远程控制
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

        [self addPlayerNotificationObserver];   //添加监听

        [self updateRemoteCommand];     //更新远程控制命令

    }

    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseAudioPlayer];
    LWAudioLog(@"========:releaseAudioPlayer");
}

/*
-(BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - 接收到媒体控制事件

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    Log(@"========remoteControlReceivedWithEvent:%@",event);
    if (event.type == UIEventTypeRemoteControl) {
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_AppDidReceiveRemoteControl object:nil userInfo:@{Key_EventSubtype: @(event.subtype)}];
    }
}
*/

#pragma mark - Notification

//接收到消息
- (void)appDidReceiveRemoteControlNotification:(NSNotification *)notification {
    LWAudioLog(@"--------%d:%s self:%@ \n\n ", __LINE__, __func__,self);
    UIEventSubtype eventSubtype = (UIEventSubtype) [notification.userInfo[Key_EventSubtype] intValue];

    switch (eventSubtype) {
        case UIEventSubtypeRemoteControlPause:
            [self.audioPlayer pause];
            break;
        case UIEventSubtypeRemoteControlPlay:
            [self.audioPlayer resume];
            break;
        case UIEventSubtypeRemoteControlStop:{
            [self stop];
            break;
        }
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextTrack];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousTrack];
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            LWAudioLog(@"========UIEventSubtypeRemoteControlTogglePlayPause");
            break;
        case UIEventSubtypeRemoteControlBeginSeekingBackward:
        case UIEventSubtypeRemoteControlBeginSeekingForward:
        case UIEventSubtypeRemoteControlEndSeekingBackward:
        case UIEventSubtypeRemoteControlEndSeekingForward:
        default:
            break;
    }
}

//处理播放结束通知
- (void)audioPlayDidEnd:(NSNotification *)notification {
    LWAudioLog(@"=============moviePlayDidEnd");
    BOOL isSingleLoop = [[NSUserDefaults standardUserDefaults] boolForKey:Key_isSingleLoop];
    if(isSingleLoop){
        [self playAudioWithItem:self.currentItem];
    }else{
        [self nextTrack];
    }
}


#pragma mark - Control 控制

/*
 * 根据Item播放
 */
- (void)playAudioWithItem:(ListItem *)item{
    [self playerTimerInvalidate];

    //初始化速率
    float speedRate = [NSUserDefaults.standardUserDefaults floatForKey:Key_AudioPlayer_SpeedRate];
    if(speedRate < 0.1 || speedRate > 3.0){
        speedRate = 1.0;
        [NSUserDefaults.standardUserDefaults setFloat:speedRate forKey:Key_AudioPlayer_SpeedRate];
    }
    [self.audioPlayer setplaybackbackspeed:(AudioUnitParameterValue) speedRate];


    //如果是上次播放的
    if (self.currentItem && [self.currentItem.itemPath isEqualToString:item.itemPath]) {
        if (self.audioPlayer.state == STKAudioPlayerStatePlaying) {   //正在播放
            [self pause];
        } else if (self.audioPlayer.state == STKAudioPlayerStatePaused) {  //暂停
            [self resume];
        } else {
            STKDataSource *dataSource = [STKAudioPlayer dataSourceFromURL:[NSURL fileURLWithPath:item.itemPath]];
            [self playDataSource:dataSource];
        }
    } else {
        if(!item.itemPath){
            return;
        }
        STKDataSource *dataSource = [STKAudioPlayer dataSourceFromURL:[NSURL fileURLWithPath:item.itemPath]];
        [self playDataSource:dataSource];
    }

    //播放视图跟踪进度
    if([self.playerViewDelegate respondsToSelector:@selector(updateAudioPlayerStatusAndProgressUI)]){
        [self.playerViewDelegate updateAudioPlayerStatusAndProgressUI];
    }
    //更新歌曲标题
    if([self.playerViewDelegate respondsToSelector:@selector(updatePalyerTitleWithText:)]){
        [self.playerViewDelegate updatePalyerTitleWithText:[item.name stringByDeletingPathExtension]];
    }

    self.currentItem = item;
    [self schedulePlayerTimer];

    self.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.audioPlayer.progress);    //已播放过的时间，音乐当前播放时间,在计时器中修改

}

- (void)playPuaseTrack {

    if (self.currentItem && [self.currentItem.type isEqualToString:TypeAudio]) {
        [self playAudioWithItem:self.currentItem];
    }else{
        if (self.itemList && self.itemList.count > 0) {
            [self playAudioWithItem:self.itemList.firstObject];
            return;
        }
    }

}

- (void)previousTrack {

    if (!self.itemList || self.itemList.count == 0) {
        [self playAudioWithItem:self.currentItem];
        return;
    }

    if (!self.currentItem) {
        [self playAudioWithItem:self.itemList.firstObject];
        return;
    }

    //查找上一首
    ListItem *preItem = self.itemList.firstObject;
    for (int i = 0; i < self.itemList.count; i++) {
        ListItem *item = self.itemList[(NSUInteger) i];
        if ([self.currentItem.itemPath isEqualToString:item.itemPath]) {
            preItem = self.itemList[(NSUInteger) (i - 1 > 0 ? i - 1 : self.itemList.count - 1)];
            break;
        }
    }
    [self playAudioWithItem:preItem];
}

- (void)nextTrack {

    if (!self.itemList || self.itemList.count == 0) {
        LWAudioLog(@"=============LWAudioPlayer itemList is nil");
        [self playAudioWithItem:self.currentItem];
        return;
    }

    if (!self.currentItem) {
        LWAudioLog(@"=============LWAudioPlayer currentItem is nil");
        [self playAudioWithItem:self.itemList.firstObject];
        return;
    }

    //查找下一首
    ListItem *nextItem = self.itemList.firstObject;
    for (int i = 0; i < self.itemList.count; i++) {
        ListItem *item = self.itemList[(NSUInteger) i];
        if ([self.currentItem.itemPath isEqualToString:item.itemPath]) {
            nextItem = self.itemList[(NSUInteger) (i + 1 < self.itemList.count ? i + 1 : 0)];
            break;
        }
    }
    [self playAudioWithItem:nextItem];
}

- (void)stop {
    [self.audioPlayer stop];
}


- (void)speedDown {
    float speedRate = [NSUserDefaults.standardUserDefaults floatForKey:Key_AudioPlayer_SpeedRate];
    if(speedRate > 0.1){
        speedRate -= 0.1;
    }else{
        speedRate = 0.1;
    }
    //设置速率
    [self.audioPlayer setplaybackbackspeed:(AudioUnitParameterValue) speedRate];
    [NSUserDefaults.standardUserDefaults setFloat:speedRate forKey:Key_AudioPlayer_SpeedRate];
}

- (void)speedUp {
    float speedRate = [NSUserDefaults.standardUserDefaults floatForKey:Key_AudioPlayer_SpeedRate];
    if(speedRate <= 3.0){
        speedRate += 0.1;
    }else{
        speedRate = 3.0;
    }
    //设置速率
    [self.audioPlayer setplaybackbackspeed:(AudioUnitParameterValue) speedRate];
    [NSUserDefaults.standardUserDefaults setFloat:speedRate forKey:Key_AudioPlayer_SpeedRate];
}

//释放AudioPlayer
-(void)releaseAudioPlayer{
    if(_audioPlayer){
        [_audioPlayer dispose];
        [_audioPlayer clearQueue];
        _audioPlayer = nil;
    }
}

//启动播放监听定时器
- (void)schedulePlayerTimer {
    if(!_playerTimer){
        _playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateAudioPlayerUI) userInfo:nil repeats:YES];
    }
    //[[NSRunLoop currentRunLoop] addTimer:_playerTimer forMode:NSRunLoopCommonModes];
//    dispatch_async(dispatch_get_main_queue(), ^{});
}

- (void)playerTimerInvalidate {
    if(_playerTimer){
        [_playerTimer invalidate];
        _playerTimer = nil;
    }
}

#pragma mark  - Private Method

//添加播放器的通知监听
- (void)addPlayerNotificationObserver {
    //播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    //处理远程控制
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidReceiveRemoteControlNotification:) name:Notification_AppDidReceiveRemoteControl object:nil];

}


//删除播放器的通知监听
-(void)removePlayerNotificationObserver{
    //播放结束
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    //处理远程控制
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_AppDidReceiveRemoteControl object:nil];

}

//更新远程控制命令
- (void)updateRemoteCommand {
    //参考：https://github.com/tzahola/MPNowPlayingInfoCenter-iOS-11-Bug
    MPRemoteCommandCenter* commandCenter = MPRemoteCommandCenter.sharedCommandCenter;
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if(self.av_isRuning){
            [self av_play];
        }else{
            [self playAudioWithItem:self.currentItem];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if(self.av_isRuning){
            [self av_pause];
        } else{
            [self pause];
        }

        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if(self.av_isRuning){
            [self av_togglePlayPause];
        }else{
            [self playAudioWithItem:self.currentItem];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if(self.av_isRuning){
            [self av_stop];
        }
        [self previousTrack];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if(self.av_isRuning){
            [self av_stop];
        }
        [self nextTrack];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if(self.av_isRuning){
            _avplayer.currentTime = ((MPChangePlaybackPositionCommandEvent*)event).positionTime;
            [self av_refreshNoewPlayingInfo];
        }else{
            NSTimeInterval progress = ((MPChangePlaybackPositionCommandEvent*)event).positionTime;
            [self.audioPlayer seekToTime:progress];
            [self updateNowPlayingInfoWithElapsedPlaybackTime:@(progress) playbackRate:@(1.0)];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}


-(void)playDataSource:(STKDataSource *)dataSource{
    if(!dataSource){
        return;
    }
    [self.audioPlayer playDataSource:dataSource];
    //[self addPlayerNotificationObserver];
}

- (void)resume {
    [self.audioPlayer resume];
    //[self addPlayerNotificationObserver];
}

- (void)pause {
    [self.audioPlayer pause];
    //[self removePlayerNotificationObserver];
}

//定时器定时调用
- (void)updateAudioPlayerUI {
    [self updateNowPlayingInfoWithElapsedPlaybackTime:@(self.audioPlayer.progress) playbackRate:@(self.audioPlayer.state == STKAudioPlayerStatePlaying ? 1.0 : 0.0)];
    //播放视图跟踪进度
    if([self.playerViewDelegate respondsToSelector:@selector(updateAudioPlayerStatusAndProgressUI)]){
        [self.playerViewDelegate updateAudioPlayerStatusAndProgressUI];
    }
}

//是否为单曲循环
- (BOOL)isSingleLoop {
    BOOL isSingleLoop = [[NSUserDefaults standardUserDefaults] boolForKey:Key_isSingleLoop];
    return isSingleLoop;
}

#pragma mark - AVAudioSessionDelegate

- (void)beginInterruption{
    LWAudioLog(@"----AVAudioSessionDelegate----%d:%s self:%@ \n\n ", __LINE__, __func__,self);
    if(self.audioPlayer.state == STKAudioPlayerStatePlaying){
        [self.audioPlayer pause];
    }
}

- (void)endInterruptionWithFlags:(NSUInteger)flags{
    LWAudioLog(@"----AVAudioSessionDelegate----%d:%s self:%@ \n\n ", __LINE__, __func__,self);
    if(self.audioPlayer.state == STKAudioPlayerStatePaused){
        [self.audioPlayer resume];
    }
}

- (void)endInterruption{
    LWAudioLog(@"----AVAudioSessionDelegate----%d:%s self:%@ \n\n ", __LINE__, __func__,self);
    if(self.audioPlayer.state == STKAudioPlayerStatePaused){
        [self.audioPlayer resume];
    }
}

- (void)inputIsAvailableChanged:(BOOL)isInputAvailable{
    LWAudioLog(@"----AVAudioSessionDelegate----%d:%s self:%@ \n\n ", __LINE__, __func__,self);
}


#pragma mark - STKAudioPlayerDelegate

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId {
    LWAudioLog(@"----audioPlayer----%d:%s self:%@ \n\n ", __LINE__, __func__,self);

    [self updateNowPlayingInfoWithElapsedPlaybackTime:@(audioPlayer.progress) playbackRate:@(1.0)];

}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId {
    LWAudioLog(@"----audioPlayer----%d:%s self:%@ \n\n ", __LINE__, __func__,self);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    LWAudioLog(@"----audioPlayer----%d:%s self:%@ ====stateChanged:%ld previousState:%d \n\n ", __LINE__, __func__,self,(long)state,previousState);

    //更新锁屏时的播放信息
    if(state == STKAudioPlayerStatePlaying){ //由暂停切换到播放
            [self updateNowPlayingInfoWithElapsedPlaybackTime:@(audioPlayer.progress) playbackRate:@(1.0)];
    }else if(state == STKAudioPlayerStatePaused){   //由播放切换到暂停状态
            [self updateNowPlayingInfoWithElapsedPlaybackTime:@(audioPlayer.progress) playbackRate:@(0.0)];
    } else if(state == STKAudioPlayerStateStopped || state == STKAudioPlayerStateDisposed || state == STKAudioPlayerStateError){
        [self updateNowPlayingInfoWithElapsedPlaybackTime:@(0.0) playbackRate:@(0.0)];
    }

    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = self.nowPlayingInfo;
}


- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    LWAudioLog(@"----audioPlayer----%d:%s self:%@ \n\n ", __LINE__, __func__,self);
    if(stopReason == STKAudioPlayerStopReasonEof && !_isav_Playing){  //播放一下首
        if([self isSingleLoop]){
            [self playAudioWithItem:self.currentItem];
        }else{
            LWAudioLog(@"================LWAudioPlayer nextTrack");
            [self nextTrack];
        }

    }else if(stopReason == STKAudioPlayerStopReasonUserAction
            || stopReason == STKAudioPlayerStopReasonDisposed){ //用户停止
        LWAudioLog(@"================LWAudioPlayer 用户停止");
    }
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    LWAudioLog(@"----audioPlayer----%d:%s self:%@ errorCode:%d\n\n ", __LINE__, __func__,self,errorCode);
    if(_audioPlayer.state == STKAudioPlayerStateError && ![self.currentItem.name containsString:@"//"]){
        NSError* error;
        NSURL *fileURL = [NSURL fileURLWithPath:self.currentItem.itemPath];
        _avplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        _avplayer.delegate = self;
        _avplayer.enableRate = YES;
        [self av_play];
    }
}

//更新锁屏时的播放信息
- (void)updateNowPlayingInfoWithElapsedPlaybackTime:(NSNumber *)elapsedTime playbackRate:(NSNumber *)rate {
    if(!self.artwork){
        self.artwork = [[MPMediaItemArtwork alloc] initWithImage:UIImageWithName(@"Artwork_Image",self)];
    }
    if(!self.nowPlayingInfo){
        self.nowPlayingInfo = @{}.mutableCopy;
    }

    self.nowPlayingInfo[MPMediaItemPropertyTitle] = [self.currentItem.name stringByDeletingPathExtension];  //图片
    self.nowPlayingInfo[MPMediaItemPropertyArtist] = self.currentItem.artist;
    self.nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = self.currentItem.albumTitle;
    self.nowPlayingInfo[MPMediaItemPropertyArtwork] = self.artwork;
    self.nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = @(self.audioPlayer.duration);    //音乐剩余时长

    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")){
        self.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = @(self.audioPlayer.progress/ self.audioPlayer.duration);
        self.nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = @(MPNowPlayingInfoMediaTypeAudio);
    }

    self.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime;    ///音乐当前播放时间,在计时器中修改
    self.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = rate;    ///音乐当前播放时间,在计时器中修改
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = self.nowPlayingInfo;
}


#pragma mark  - Getter and Setter

-(STKAudioPlayer *)audioPlayer{
    if(!_audioPlayer){
        _audioPlayer = [[STKAudioPlayer alloc] init];
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

#pragma mark - AVPlayer

- (void)av_togglePlayPause {
    if (_isav_Playing) {
        [self av_pause];
    } else {
        [self av_play];
    }
}

- (void)av_play {
    float speedRate = [NSUserDefaults.standardUserDefaults floatForKey:Key_AudioPlayer_SpeedRate];
    if(speedRate < 0.1 || speedRate > 3.0){
        speedRate = 1.0;
        [NSUserDefaults.standardUserDefaults setFloat:speedRate forKey:Key_AudioPlayer_SpeedRate];
    }
    _avplayer.rate = speedRate;

    _isav_Runing = YES;
    _isav_Playing = YES;
    [_avplayer play];
    [self av_refreshNoewPlayingInfo];
}

- (void)av_pause {
    _isav_Playing = NO;
    [_avplayer pause];
    [self av_refreshNoewPlayingInfo];
}

-(void)av_stop {
    _isav_Runing = NO;
    [_avplayer stop];
}

- (void)av_speedDown {
    float speedRate = [NSUserDefaults.standardUserDefaults floatForKey:Key_AudioPlayer_SpeedRate];
    if(speedRate > 0.1){
        speedRate -= 0.1;
    }else{
        speedRate = 0.1;
    }
    [_avplayer pause];
    _avplayer.rate = speedRate;
    [_avplayer play];
    [NSUserDefaults.standardUserDefaults setFloat:_avplayer.rate forKey:Key_AudioPlayer_SpeedRate];
}

- (void)av_speedUp {
    float speedRate = [NSUserDefaults.standardUserDefaults floatForKey:Key_AudioPlayer_SpeedRate];
    if(speedRate <= 3.0){
        speedRate += 0.1;
    }else{
        speedRate = 3.0;
    }
    [_avplayer pause];
    _avplayer.rate = speedRate;
    [_avplayer play];
    [NSUserDefaults.standardUserDefaults setFloat:_avplayer.rate forKey:Key_AudioPlayer_SpeedRate];

}

- (void)av_refreshNoewPlayingInfo {

    if(!self.artwork){
        self.artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"MyBrowser"]];
    }
    if(!self.nowPlayingInfo){
        self.nowPlayingInfo = @{}.mutableCopy;
    }

    self.nowPlayingInfo[MPMediaItemPropertyTitle] = [self.currentItem.name stringByDeletingPathExtension];  //图片
    self.nowPlayingInfo[MPMediaItemPropertyArtist] = self.currentItem.artist;
    self.nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = self.currentItem.albumTitle;
    self.nowPlayingInfo[MPMediaItemPropertyArtwork] = self.artwork;
    self.nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = @(_avplayer.duration);    //音乐剩余时长

    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")){
        self.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = @(_avplayer.currentTime/ _avplayer.duration);
        self.nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = @(MPNowPlayingInfoMediaTypeAudio);
    }

    self.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(_avplayer.currentTime);    ///音乐当前播放时间,在计时器中修改
    self.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = @(_isav_Playing ? _avplayer.rate : 0);    ///音乐当前播放时间,在计时器中修改
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = self.nowPlayingInfo;

}

-(BOOL)av_isRuning {
    return _isav_Runing;
}

-(BOOL)av_isPlaying {
    return _isav_Playing;
}


#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    BOOL isSingleLoop = [[NSUserDefaults standardUserDefaults] boolForKey:Key_isSingleLoop];
    if(isSingleLoop){
        [self playAudioWithItem:self.currentItem];
    }else{
        if(self.av_isRuning){
            [self av_stop];
        }
        [self nextTrack];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    [self av_stop];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    if(self.av_isRuning){
        [self av_togglePlayPause];
    }
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    if(self.av_isRuning && !_isav_Playing){
        [self av_play];
    }
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    if(self.av_isRuning && !_isav_Playing){
        [self av_play];
    }
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    if(self.av_isRuning && !_isav_Playing){
        [self av_play];
    }
}

@end
