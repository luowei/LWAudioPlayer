# LWAudioPlayer

[![CI Status](https://img.shields.io/travis/luowei/LWAudioPlayer.svg?style=flat)](https://travis-ci.org/luowei/LWAudioPlayer)
[![Version](https://img.shields.io/cocoapods/v/LWAudioPlayer.svg?style=flat)](https://cocoapods.org/pods/LWAudioPlayer)
[![License](https://img.shields.io/cocoapods/l/LWAudioPlayer.svg?style=flat)](https://cocoapods.org/pods/LWAudioPlayer)
[![Platform](https://img.shields.io/cocoapods/p/LWAudioPlayer.svg?style=flat)](https://cocoapods.org/pods/LWAudioPlayer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LWAudioPlayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LWAudioPlayer'
```

**Carthage**
```ruby
github "luowei/LWAudioPlayer"
```

## Usage

```OC
    self.audioPlayerView = [LWAudioPlayerView new];
    self.audioPlayerView.dataSource = self;
    [self.view addSubview:self.audioPlayerView];
    [self.audioPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(75);
    }];


#pragma mark - LWAudioPlayerDataSource

//获得播放列表，扁平化的ItemList
-(NSArray <ListItem *>*)flatItemList:(NSArray <ListItem *>*)itemList withType:(NSString *)type {
    //todo: 列表数据
    return nil;
}
```

## Author

luowei, luowei@wodedata.com

## License

LWAudioPlayer is available under the MIT license. See the LICENSE file for more info.
