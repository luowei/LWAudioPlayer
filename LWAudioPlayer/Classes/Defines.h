//
//  Defines.h
//  Webkit-Demo
//
//  Created by luowei on 15/6/26.
//  Copyright (c) 2015 rootls. All rights reserved.
//

#ifndef Webkit_Demo_Defines____FILEEXTENSION___
#define Webkit_Demo_Defines____FILEEXTENSION___

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define LWAudioLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define LWAudioLog(format, ...)
#endif

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define TypeFolder  @"folder"
#define TypeFile  @"file"
#define TypeDocument  @"document"
#define TypeImage  @"image"
#define TypeVideo  @"video"
#define TypeAudio  @"audio"


//屏幕宽度,高度
#define Screen_W ((CGFloat)([UIScreen mainScreen].bounds.size.width))
#define Screen_H ((CGFloat)([UIScreen mainScreen].bounds.size.height))

#define LWImageBundle(obj)  ([NSBundle bundleWithPath:[[NSBundle bundleForClass:[obj class]] pathForResource:@"LWAudioPlayer" ofType:@"bundle"]] ?: ([NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LWAudioPlayer " ofType:@"bundle"]] ?: [NSBundle mainBundle]))
#define UIImageWithName(name,obj) ([UIImage imageNamed:name inBundle:LWImageBundle(obj) compatibleWithTraitCollection:nil])


#define Key_isSingleLoop @"Key_isSingleLoop"   //单曲循环

#define Key_EventSubtype @"Key_EventSubtype"

#endif
