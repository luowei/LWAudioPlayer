//
// Created by luowei on 2018/4/11.
// Copyright (c) 2018 wodedata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListItem;
@class LWAudioPlayer;
@class STKDataSource;

#define Key_AudioPlayer_SpeedRate @"Key_AudioPlayer_SpeedRate"

@protocol LWAudioPlayerDataSource <NSObject>

//获得播放列表，扁平化的ItemList
-(NSArray <ListItem *>*)flatItemList:(NSArray <ListItem *>*)itemList withType:(NSString *)type;

@end

@interface LWAudioPlayerView : UIView

@property(nonatomic, weak) id<LWAudioPlayerDataSource> dataSource;

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

@interface UIImage (OverColor)

// 给指定的图片染色
- (UIImage *)imageWithOverlayColor:(UIColor *)color;

@end

@interface UIResponder (Extension)

//获得指class类型的父视图
- (id)superViewWithClass:(Class)clazz;

@end

@interface UIView (Rotation)

//用于接收屏幕发生旋转消息
- (void)rotationToInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
