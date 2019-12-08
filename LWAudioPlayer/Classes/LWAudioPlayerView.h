//
// Created by luowei on 2018/4/11.
// Copyright (c) 2018 wodedata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListItem;
@class LWAudioPlayer;
@class STKDataSource;


@interface LWAudioPlayerView : UIView

/*
 * 播放或暂停
 */
- (void)playOrPuaseAction;

/*
 * 上一首
 */
- (void)playPreviousAction;

/*
 * 下一首
 */
- (void)playNextAction;


@end