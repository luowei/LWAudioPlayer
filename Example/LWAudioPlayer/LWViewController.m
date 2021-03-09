//
//  LWViewController.m
//  LWAudioPlayer
//
//  Created by luowei on 05/20/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import "LWViewController.h"
#import <LWAudioPlayer/LWAudioPlayerView.h>
#import <Masonry/Masonry.h>

@interface LWViewController ()<LWAudioPlayerDataSource>

@property(nonatomic, strong) LWAudioPlayerView *audioPlayerView;
@end

@implementation LWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    self.audioPlayerView = [LWAudioPlayerView new];
    self.audioPlayerView.dataSource = self;
    [self.view addSubview:self.audioPlayerView];
    [self.audioPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(75);
    }];

    
}

#pragma mark - LWAudioPlayerDataSource

//获得播放列表，扁平化的ItemList
-(NSArray <ListItem *>*)flatItemList:(NSArray <ListItem *>*)itemList withType:(NSString *)type {
    //todo: 列表数据
    return nil;
}

@end
