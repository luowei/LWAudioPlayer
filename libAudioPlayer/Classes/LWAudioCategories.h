//
//  LWAudioCategories.h
//  libAudioPlayer
//
//  Created by luowei on 05/20/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

@import UIKit;

@interface UIView (LWAudio)

- (void)lwaudio_rotationToInterfaceOrientation:(UIInterfaceOrientation)orientation;

//获得指class类型的父视图
- (id)lwaudio_superViewWithClass:(Class)clazz;

@end


@interface UIImage (LWAudio)

// 给指定的图片染色
- (UIImage *)lwaudio_imageWithOverlayColor:(UIColor *)color;

@end

