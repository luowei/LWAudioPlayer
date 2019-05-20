//
// Created by Luo Wei on 2018/4/18.
// Copyright (c) 2018 wodedata. All rights reserved.
//

#import "ListItem.h"
#import "Defines.h"


@implementation ListItem

- (instancetype)initWithName:(NSString *)name
                        type:(NSString *)type
                    itemPath:(NSString *)itemPath
                    itemList:(NSArray <ListItem *> *)itemList {
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
        self.itemPath = itemPath;
        self.itemList = itemList;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    ListItem *item = [[ListItem alloc] init];
    item.name = self.name;
    item.type = self.type;
    item.itemPath = self.itemPath;
    item.itemList = [self.itemList copy];
    return item;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    ListItem *item = [[ListItem alloc] init];
    item.name = self.name;
    item.type = self.type;
    item.itemPath = self.itemPath;
    item.itemList = [self.itemList mutableCopy];
    return item;
}


- (NSString *)uti {
    NSString *ext = [_name pathExtension].lowercaseString;
    if(!ext){
        return @"public.data";
    }

    if([_type isEqualToString:TypeFolder]){
        return @"public.folder";
    }else if([ext isEqualToString:@"zip"]){
        return @"com.pkware.zip-archive";
    }else if([ext isEqualToString:@"png"]){
        return @"public.png";
    }else if([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"]){
        return @"public.jpeg";
    }else if([ext isEqualToString:@"jp2"]){
        return @"public.jpeg-2000";
    }else if([ext isEqualToString:@"gif"]){
        return @"com.compuserve.gif";
    }else if([ext isEqualToString:@"ai"]){
        return @"com.adobe.illustrator.ai-image";
    }else if([ext isEqualToString:@"bmp"]){
        return @"com.microsoft.bmp";
    }else if([ext isEqualToString:@"tif"] || [ext isEqualToString:@"tiif"]){
        return @"public.tiff";
    }else if([ext isEqualToString:@"avi"] || [ext isEqualToString:@"vfw"]){
        return @"public.avi";
    }else if([ext isEqualToString:@"mpg"] || [ext isEqualToString:@"mpeg"]){
        return @"public.mpeg";
    }else if([ext isEqualToString:@"mp4"] || [ext isEqualToString:@"mpg4"]){
        return @"public.mpeg-4";
    }else if([ext isEqualToString:@"3gp"] || [ext isEqualToString:@"3gpp"]){
        return @"public.3gpp";
    }else if([ext isEqualToString:@"3g2"] || [ext isEqualToString:@"3gp2"]){
        return @"public.3gpp2";
    }else if([ext isEqualToString:@"wmv"]){
        return @"com.microsoft.windows-media-wmv";
    }else if([ext isEqualToString:@"mov"] || [ext isEqualToString:@"qt"]){
        return @"com.apple.quicktime-movie";
    }else if([ext isEqualToString:@"mp3"] || [ext isEqualToString:@"mpg3"]){
        return @"public.mp3";
    }else if([ext isEqualToString:@"m4a"]){
        return @"public.mpeg-4-audio";
    }else if([ext isEqualToString:@"wav"]){
        return @"com.microsoft.waveform-audio";
    }else if([ext isEqualToString:@"wma"]){
        return @"com.microsoft.windows-media-wma";
    }else if([ext isEqualToString:@"aif"] || [ext isEqualToString:@"aifc"]){
        return @"public.aifc-audio";
    }else if([ext isEqualToString:@"aiff"]){
        return @"public.aiff-audio";
    }else if([ext isEqualToString:@"html"] || [ext isEqualToString:@"htm"]){
        return @"public.html";
    }else if([ext isEqualToString:@"xml"]){
        return @"public.xml";
    }else if([ext isEqualToString:@"rtfd"]){
        return @"com.apple.rtfd";
    }else if([ext isEqualToString:@"c"]
            || [ext isEqualToString:@"m"]
            || [ext isEqualToString:@"cpp"]
            || [ext isEqualToString:@"mm"]
            || [ext isEqualToString:@"h"]
            || [ext isEqualToString:@"hpp"]
            || [ext isEqualToString:@"java"]
            || [ext isEqualToString:@"s"]
            || [ext isEqualToString:@"r"]
            || [ext isEqualToString:@"js"]
            || [ext isEqualToString:@"json"]
            || [ext isEqualToString:@"sh"]
            || [ext isEqualToString:@"pl"]
            || [ext isEqualToString:@"py"]
            || [ext isEqualToString:@"rb"]
            || [ext isEqualToString:@"php"]
            ){
        return @"public.source-code";
    }else if([ext isEqualToString:@"txt"]){
        return @"public.plain-text";
    }else if([ext isEqualToString:@"rtf"]){
        return @"public.rtf";
    }else if([ext isEqualToString:@"pdf"]){
        return @"com.adobe.pdf";
    }else if([ext isEqualToString:@"doc"]){
        return @"com.microsoft.word.doc";
    }else if([ext isEqualToString:@"xls"]){
        return @"com.microsoft.excel.xls";
    }else if([ext isEqualToString:@"ppt"]){
        return @"com.microsoft.powerpoint.ppt";
    }
    return @"public.data";
}

- (void)encodeWithCoder:(NSCoder *)coder {

}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return nil;
}


@end