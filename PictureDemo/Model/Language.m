//
//  Language.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/6.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "Language.h"

@interface Language ()
{
    NSUInteger _languageID;
    NSArray *_languageArray;
}

@end


@implementation Language

static Language *sharedLanguageInstance = nil;


+ (instancetype)sharedLanguage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLanguageInstance = [[Language alloc]init];
        [sharedLanguageInstance setLanguageArray];
    });
    return sharedLanguageInstance;
}

- (void)setLanguageArray
{
    _languageID = 0;
    if (_languageArray == nil) {
        NSMutableDictionary *zh_cn = [[NSMutableDictionary alloc]init];
        [zh_cn setObject:@"选择" forKey:@"select"];
        [zh_cn setObject:@"返回" forKey:@"back"];
        [zh_cn setObject:@"保存" forKey:@"save"];
        [zh_cn setObject:@"剪切" forKey:@"shearPhotograph"];
        [zh_cn setObject:@"大头贴" forKey:@"stickerPhotograph"];
        [zh_cn setObject:@"编辑" forKey:@"edit"];
        [zh_cn setObject:@"我的相册" forKey:@"myPhotoLibrary"];
        [zh_cn setObject:@"其他相册" forKey:@"otherPhotoLibrary"];
        [zh_cn setObject:@"相册" forKey:@"photoLibrary"];
        [zh_cn setObject:@"取消" forKey:@"cancel"];
        [zh_cn setObject:@"确定" forKey:@"ok"];
        [zh_cn setObject:@"保存" forKey:@"save"];
        
        [zh_cn setObject:@"圆形" forKey:@"circle"];
        [zh_cn setObject:@"矩形" forKey:@"rectangle"];
        [zh_cn setObject:@"混合" forKey:@"circle_rectangle"];
        
        [zh_cn setObject:@"导出" forKey:@"export"];
        
        _languageArray = [[NSArray alloc]initWithObjects:zh_cn, nil];
    }
}

- (void)setLanguageID:(LanguageID)languageID
{
    if(languageID != Language_zh_cn
       && languageID != Language_zh_hk
       && languageID != Language_en_us)
        return;
    
    _languageID = languageID;
}

- (NSString *)stringForKey:(NSString *)key
{
    return [[_languageArray objectAtIndex:_languageID] objectForKey:key];
}

- (void)destroyLanguage
{
    if (_languageArray) {
        _languageArray = nil;
    }
    
    if (sharedLanguageInstance) {

        sharedLanguageInstance = nil;
    }
}

@end
