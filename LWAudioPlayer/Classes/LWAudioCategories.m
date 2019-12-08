//
//  LWAudioCategories.m
//  LWAudioPlayer
//
//  Created by luowei on 05/20/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import "LWAudioCategories.h"

@implementation UIView (LWAudio)

//递归的向子视图发送屏幕发生旋转了的消息
- (void)lwaudio_rotationToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    for (UIView *v in self.subviews) {
        [v lwaudio_rotationToInterfaceOrientation:orientation];
    }
}

//获得指class类型的父视图
- (id)lwaudio_superViewWithClass:(Class)clazz {
    UIResponder *responder = self;
    while (![responder isKindOfClass:clazz]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return responder;
}

@end


@implementation UIImage (LWAudio)


// 给指定的图片染色
- (UIImage *)lwaudio_imageWithOverlayColor:(UIColor *)color{

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);

    [self drawInRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height)];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height));

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end

