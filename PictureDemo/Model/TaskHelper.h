//
//  TaskHelper.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/14.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Task_block_t)(NSDictionary *dic);

@interface TaskHelper : NSObject

+ (TaskHelper *)sharedInstance;

+ (void)destoryInstance;

- (void)asyncTask:(Task_block_t)block withInDictionary:(NSDictionary *)inDic;

@end
