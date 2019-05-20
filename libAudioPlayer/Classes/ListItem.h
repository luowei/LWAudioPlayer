//
// Created by Luo Wei on 2018/4/18.
// Copyright (c) 2018 wodedata. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ListItem : NSObject<NSCopying,NSMutableCopying,NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSString *type;
@property (nonatomic, strong) NSString *itemPath;
@property (nonatomic, strong) NSArray <ListItem *>*itemList;

@property(nonatomic, strong) id artist;

@property(nonatomic, strong) id albumTitle;

- (instancetype)initWithName:(NSString *)name
                        type:(NSString *)type
                    itemPath:(NSString *)itemPath
                    itemList:(NSArray <ListItem *> *)itemList;

- (NSString *)uti;

@end