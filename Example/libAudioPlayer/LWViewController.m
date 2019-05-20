//
//  LWViewController.m
//  libAudioPlayer
//
//  Created by luowei on 05/20/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import "LWViewController.h"
#import <libAudioPlayer/LWAudioPlayerView.h>
#import <Masonry/Masonry.h>

@interface LWViewController ()

@property(nonatomic, strong) LWAudioPlayerView *audioPlayerView;
@end

@implementation LWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    self.audioPlayerView = [LWAudioPlayerView new];
    [self.view addSubview:self.audioPlayerView];
    [self.audioPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(75);
    }];

    
}


@end
