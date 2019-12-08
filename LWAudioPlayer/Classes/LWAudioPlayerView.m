//
// Created by luowei on 2018/4/11.
// Copyright (c) 2018 wodedata. All rights reserved.
//

#import "LWAudioPlayerView.h"
#import "MASConstraintMaker.h"
#import "View+MASAdditions.h"
#import "MarqueeLabel.h"
#import "STKDataSource.h"
#import "LWAudioPlayer.h"
#import "LWAudioCategories.h"
#import "Defines.h"
#import "STKAudioPlayer.h"
#import "ListItem.h"

@interface LWAudioPlayerView ()<LWAudioPlayerViewDelegate>

@property(nonatomic, strong) UIView *topLine;

@property(nonatomic, strong) UIButton *playBtn;

@property(nonatomic, strong) MarqueeLabel *textLabel;
@property(nonatomic, strong) UIButton *previousBtn;
@property(nonatomic, strong) UIButton *nextBtn;
@property(nonatomic, strong) UISlider *progressBar;
@property(nonatomic, strong) UILabel *progressLabel;

//进度条上的时间标签
@property(nonatomic, strong) UILabel *startLabel;
@property(nonatomic, strong) UILabel *endLabel;

@property(nonatomic, strong) UIImage *normalPauseImg;
@property(nonatomic, strong) UIImage *highlightPauseImg;
@property(nonatomic, strong) UIImage *normalPlayImg;
@property(nonatomic, strong) UIImage *highlightPlayImg;

@property(nonatomic, strong) UIButton *playModeBtn;
@property(nonatomic, strong) UIButton *shareBtn;
@end

@implementation LWAudioPlayerView {
}

- (instancetype)init {
    self = [super init];
    if (self) {
        LWAudioPlayer *player = [LWAudioPlayer sharedInstance];
        player.playerViewDelegate = self;

        self.normalPauseImg = UIImageWithName(@"pause",self);
        self.highlightPauseImg = [self.normalPauseImg lwaudio_imageWithOverlayColor:[UIColor lightGrayColor]];
        self.normalPlayImg = UIImageWithName(@"play",self);
        self.highlightPlayImg = [self.normalPlayImg lwaudio_imageWithOverlayColor:[UIColor lightGrayColor]];

        self.topLine = [UIView new];
        [self addSubview:self.topLine];
        self.topLine.backgroundColor = [UIColor lightGrayColor];
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(.5);
        }];

        //当前正在播放的歌曲
        self.textLabel = [[MarqueeLabel alloc] initWithFrame:CGRectZero duration:10 andFadeLength:15];
        [self addSubview:self.textLabel];
        self.textLabel.marqueeType = MLContinuous;
        self.textLabel.animationCurve = UIViewAnimationOptionCurveLinear;
        self.textLabel.leadingBuffer = 15.0f;
        self.textLabel.trailingBuffer = 15.0f;

        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.text = @"";
        if (player.currentItem) {
            [self updateTextLabelSpaceWithText:[player.currentItem.name stringByDeletingPathExtension]];
        }

        //更新textLabel的空格
        [self updateTextLabelSpaceWithText:self.textLabel.text];

        //进度条
        self.progressBar = [[UISlider alloc] initWithFrame:CGRectZero];
        [self addSubview:self.progressBar];
        self.progressBar.minimumValue = 0;
        self.progressBar.maximumValue = 150;
        self.progressBar.value = 0;
        self.progressBar.tintColor = [UIColor darkTextColor];
        [self.progressBar setThumbImage:UIImageWithName(@"cursor",self) forState:UIControlStateNormal];
        [self updateProgressLabelText:@"00:00"];

        [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-8);
            make.left.equalTo(self).offset(50);
            make.right.equalTo(self).offset(-50);
        }];
        [self.progressBar addTarget:self action:@selector(progressTouchDown) forControlEvents:UIControlEventTouchDown];
        [self.progressBar addTarget:self action:@selector(progressChanged) forControlEvents:UIControlEventValueChanged];

        //进度标签
        UIFont *labelFont = [UIFont systemFontOfSize:12];
        if (@available(iOS 8.2,*)) {
            labelFont = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
        }

        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.progressLabel];
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
        self.progressLabel.font = labelFont;
        self.progressLabel.text = @"";
        self.progressLabel.hidden = YES;

        //时间标签
        self.startLabel = [UILabel new];
        [self addSubview:self.startLabel];
        self.startLabel.font = labelFont;
        self.startLabel.text = @"00:00";
        self.startLabel.textAlignment = NSTextAlignmentLeft;
        [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(7);
            make.centerY.equalTo(self).offset(-8);
        }];

        self.endLabel = [UILabel new];
        [self addSubview:self.endLabel];
        self.endLabel.font = labelFont;
        self.endLabel.text = @"30:00";
        self.startLabel.textAlignment = NSTextAlignmentRight;
        [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-7);
            make.centerY.equalTo(self).offset(-8);
        }];


        //播放暂停按钮
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.playBtn];
        [self.playBtn setImage:UIImageWithName(@"play",self) forState:UIControlStateNormal];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(17.5);
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(30);
        }];
        [self.playBtn addTarget:self action:@selector(playOrPuaseAction) forControlEvents:UIControlEventTouchUpInside];


        //上一首
        self.previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.previousBtn];
        [self.previousBtn setImage:UIImageWithName(@"play_previous",self) forState:UIControlStateNormal];
        [self.previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(17.5);
            make.trailing.equalTo(self.playBtn.mas_leading).offset(-30);
            make.width.height.mas_equalTo(30);
        }];
        [self.previousBtn addTarget:self action:@selector(playPreviousAction) forControlEvents:UIControlEventTouchUpInside];


        //下一首
        self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.nextBtn];
        [self.nextBtn setImage:UIImageWithName(@"play_next",self) forState:UIControlStateNormal];
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(17.5);
            make.leading.equalTo(self.playBtn.mas_trailing).offset(30);
            make.width.height.mas_equalTo(30);
        }];
        [self.nextBtn addTarget:self action:@selector(playNextAction) forControlEvents:UIControlEventTouchUpInside];

        //播放模式
        self.playModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.playModeBtn];
        if(player.isSingleLoop){
            [self.playModeBtn setImage:UIImageWithName(@"loop_single",self) forState:UIControlStateNormal];
        }else{
            [self.playModeBtn setImage:UIImageWithName(@"loop_all",self) forState:UIControlStateNormal];
        }

        [self.playModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(17.5);
            make.left.equalTo(self).offset(10);
            make.width.height.mas_equalTo(30);
        }];
        [self.playModeBtn addTarget:self action:@selector(playModeAction) forControlEvents:UIControlEventTouchUpInside];

        //分享
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.shareBtn];
        [self.shareBtn setImage:UIImageWithName(@"share_audio",self) forState:UIControlStateNormal];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(17.5);
            make.right.equalTo(self).offset(-10);
            make.width.height.mas_equalTo(30);
        }];
        [self.shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

- (void)rotationToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    [super lwaudio_rotationToInterfaceOrientation:orientation];

    [self updateTextLabelSpaceWithText:self.textLabel.text];
}


- (void)dealloc {
    LWAudioLog(@"=======dealloc LWAudioPlayerView");
}


#pragma mark - LWAudioPlayerDelegate

//更新歌曲标题
- (void)updatePalyerTitleWithText:(NSString *)text {
    [self updateTextLabelSpaceWithText:text];
}

//追踪更新音乐播放进度
- (void)updateAudioPlayerStatusAndProgressUI {

    LWAudioPlayer *player = [LWAudioPlayer sharedInstance];

//    //如果播放队列不存在
//    if (player.audioPlayer.currentlyPlayingQueueItemId == nil) {
//        self.progressBar.value = 0;
//        if (player.audioPlayer.state == STKAudioPlayerStateBuffering && player.currentItem) {
//            [player playAudioWithItem:player.currentItem];
//        }
//        return;
//    }

    //更新播放按钮状态,处理非运行状态或是暂停状态
    //NSLog(@"========player stare:%d",player.state);
    if ((player.audioPlayer.state == STKAudioPlayerStateBuffering) || (player.audioPlayer.state == STKAudioPlayerStatePlaying)
            || (player.av_isRuning && player.av_isPlaying) ) {
        [self.playBtn setImage:self.normalPauseImg forState:UIControlStateNormal];
        [self.playBtn setImage:self.highlightPauseImg forState:UIControlStateHighlighted];
    } else {
        [self.playBtn setImage:self.normalPlayImg forState:UIControlStateNormal];
        [self.playBtn setImage:self.highlightPlayImg forState:UIControlStateHighlighted];
    }

    //如音乐持续时间有不为0
    if (player.audioPlayer.duration != 0) {
            [self.progressBar setValue:(CGFloat) player.audioPlayer.progress animated:NO];
            NSString *progressText = [self doubleToNSStringTime:player.audioPlayer.progress];
            [self updateProgressLabelText:progressText];

    }else if(player.av_isRuning){
        [self.progressBar setValue:(CGFloat) player.avplayer.currentTime animated:NO];
        NSString *progressText = [self doubleToNSStringTime:player.avplayer.currentTime];
        [self updateProgressLabelText:progressText];

    } else {
        [self.progressBar setValue:0 animated:NO];
        [self updateProgressLabelText:@"00:00"];
        return;
    }

    double duration = player.audioPlayer.duration;
    if(player.av_isRuning){
        duration = player.avplayer.duration;
    }
    if (self.progressBar.maximumValue != duration) {
        //NSLog(@"========duration:%f",duration);
        self.progressBar.maximumValue = (float) duration;
        self.endLabel.text = [self doubleToNSStringTime:self.progressBar.maximumValue];
    }

}


#pragma mark - Action and Control

- (void)progressTouchDown {
    [[LWAudioPlayer sharedInstance] playerTimerInvalidate];
}

- (void)progressChanged {
    LWAudioPlayer *player = [LWAudioPlayer sharedInstance];
    if(player.av_isRuning){
        [player.avplayer setCurrentTime:self.progressBar.value];
        [player resignFirstResponder];

    }else{
        STKAudioPlayer *audioPlayer = [LWAudioPlayer sharedInstance].audioPlayer;
        [audioPlayer seekToTime:self.progressBar.value];
        [player updateNowPlayingInfoWithElapsedPlaybackTime:@(audioPlayer.progress) playbackRate:@(1.0)];
    }

    [[LWAudioPlayer sharedInstance] schedulePlayerTimer];
}

- (void)playModeAction {
    BOOL isSingleLoop = [[NSUserDefaults standardUserDefaults] boolForKey:Key_isSingleLoop];
    if(isSingleLoop){   //如果单曲循环模式,则设置为有顺序循环
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:Key_isSingleLoop];
        [self.playModeBtn setImage:UIImageWithName(@"loop_all",self) forState:UIControlStateNormal];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Key_isSingleLoop];
        [self.playModeBtn setImage:UIImageWithName(@"loop_single",self) forState:UIControlStateNormal];
    }
}

-(void)shareAction{
    UIViewController *vc = [self lwaudio_superViewWithClass:[UIViewController class] ];

    LWAudioPlayer *player = [LWAudioPlayer sharedInstance];
    NSURL *itemURL = nil;
    if(!player.currentItem){
        return;
    }
    if([player.currentItem.name containsString:@"//"]){
        itemURL = [NSURL URLWithString:player.currentItem.name];
    }else{
        itemURL = [NSURL fileURLWithPath:player.currentItem.itemPath];
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[itemURL] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [vc presentViewController:activityVC animated:YES completion:nil];
}

/*
 * 播放或暂停
 */
- (void)playOrPuaseAction {

    LWAudioPlayer *player = [LWAudioPlayer sharedInstance];
    if(player.av_isRuning){
        [player av_togglePlayPause];
        return;
    }

    [player playPuaseTrack];
}


/*
 * 上一首
 */
- (void)playPreviousAction{
    LWAudioPlayer *player = [LWAudioPlayer sharedInstance];
    if(player.av_isRuning){
        [player av_stop];
    }

    [player previousTrack];
}

/*
 * 下一首
 */
- (void)playNextAction {
    LWAudioPlayer *player = [LWAudioPlayer sharedInstance];
    if(player.av_isRuning){
        [player av_stop];
    }

    [player nextTrack];
}


#pragma mark - Getter and Setter



#pragma mark - Private Method

/*
 * 数值转时间
 */
- (NSString *)doubleToNSStringTime:(double)value {
    NSInteger interval = (NSInteger) value;
    //double milliseconds = (value - interval) * 1000;
    NSInteger seconds = interval % 60;
    NSInteger minutes = interval / 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

/*
 * 更新textLabel的空格
 */
- (void)updateTextLabelSpaceWithText:(NSString *)text {
    self.textLabel.text = text;
    CGFloat textWidth = [text sizeWithAttributes:@{NSFontAttributeName: self.textLabel.font}].width;
    while (textWidth <= CGRectGetWidth([UIScreen mainScreen].bounds)) {
        self.textLabel.text = [self.textLabel.text stringByAppendingString:@" "];
        textWidth = [self.textLabel.text sizeWithAttributes:@{NSFontAttributeName: self.textLabel.font}].width;
    }
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-0);
        make.top.equalTo(self).offset(4);
    }];
}

/*
 * 更新进度游标时间
 */
- (void)updateProgressLabelText:(NSString *)text {
    self.progressLabel.hidden = NO;
    self.progressLabel.text = text;
    CGRect trackRect = [self.progressBar trackRectForBounds:self.progressBar.bounds];
    CGRect thumbRect = [self.progressBar thumbRectForBounds:self.progressBar.bounds trackRect:trackRect value:self.progressBar.value];
    self.progressLabel.bounds = CGRectMake(0, 0, 45, 14);
    self.progressLabel.center = CGPointMake(thumbRect.origin.x + self.progressBar.frame.origin.x, self.progressBar.frame.origin.y + self.progressBar.frame.size.height - 2);
}


@end
