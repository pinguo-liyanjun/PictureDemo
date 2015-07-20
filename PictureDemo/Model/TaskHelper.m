//
//  TaskHelper.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/14.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "TaskHelper.h"


@interface TaskHelper ()

@property (strong, nonatomic)dispatch_queue_t mTaskQueue;

@end

static TaskHelper *taskHelperInstance = nil;

@implementation TaskHelper

+ (TaskHelper *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        taskHelperInstance = [[TaskHelper alloc] init];
    });
    
    return taskHelperInstance;
}

+ (void)destoryInstance
{
    if(taskHelperInstance)
    {
        taskHelperInstance = nil;
    }
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _mTaskQueue = dispatch_queue_create("com.camera360.queue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}


- (void)asyncTask:(Task_block_t)block withInDictionary:(NSDictionary *)inDic
{
    @autoreleasepool {
        NSCondition *taskLock = [[NSCondition alloc] init];
        __block BOOL taskDoneFlag = NO;
        __block BOOL isMainThreadFlag = [[NSThread currentThread] isMainThread];
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(weakSelf.mTaskQueue, ^{
            block(inDic);
            taskDoneFlag = YES;
            if(!isMainThreadFlag)
            {
                [taskLock signal];
            }
        });
        
        [taskLock lock];
        
        while (!taskDoneFlag)
        {
            if(isMainThreadFlag)
                @autoreleasepool{
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
                }
            else
                [taskLock wait];
        }
        [taskLock unlock];
        
    }
}

@end
