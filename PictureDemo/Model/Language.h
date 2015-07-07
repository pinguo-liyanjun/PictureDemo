//
//  Language.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/6.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LanguageID){
    Language_zh_cn = 0,
    Language_zh_hk ,
    Language_en_us
};

@interface Language : NSObject

+ (instancetype)sharedLanguage;

- (void)setLanguageID:(LanguageID)languageID;

- (NSString *)stringForKey:(NSString *)key;

- (void)destroyLanguage;


@end
