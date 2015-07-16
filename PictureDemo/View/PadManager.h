//
//  PadManager.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/14.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PadStatusType)
{
    PadStatusType_Waiting = 0,
    PadStatusType_Finish
};

typedef void(^Pad_result_block)(NSDictionary *);

@interface PadManager : NSObject

+ (instancetype)sharedPadManagerInstance;

- (void)destroyPadManagerInstance;

- (void)setPadStatus:(PadStatusType)status withInDic:(NSDictionary *)inDic resultBlock:(Pad_result_block)resultBlock;

- (void)updateWaitingViewTitle:(NSString *)title;

@end
