//
//  PadManager.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/14.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "PadManager.h"
#import "WaitingView.h"
#import "PureLayout.h"
#import "Default.h"


@interface PadManager ()

@property (strong, nonatomic)WaitingView *mWaitingView;

@end

static PadManager *sharedInstance = nil;

@implementation PadManager

+ (instancetype)sharedPadManagerInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PadManager alloc]init];
    });
    return sharedInstance;
}


- (void)destroyPadManagerInstance
{
    if (sharedInstance) {
        sharedInstance = nil;
    }
}


#pragma mark --getter--
- (WaitingView *)mWaitingView
{
    if (!_mWaitingView) {
        _mWaitingView = [[WaitingView alloc]initWithFrame:CGRectMake(0, 0, DEVIECE_MAINFRAME.size.width, DEVIECE_MAINFRAME.size.height+20)];
//        _mWaitingView.titleLabel.text = @"正在导出，请稍后...";
    }
    return _mWaitingView;
}

#pragma mark --public function--
- (void)setPadStatus:(PadStatusType)status withInDic:(NSDictionary *)inDic resultBlock:(Pad_result_block)resultBlock
{
    if (status == PadStatusType_Waiting) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow addSubview:self.mWaitingView];
            self.mWaitingView.titleLabel.text = @"";
        });
    }
    else if (status == PadStatusType_Finish)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mWaitingView removeFromSuperview];
            self.mWaitingView = nil;
        });
    }
}

- (void)updateWaitingViewTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.mWaitingView) {
            self.mWaitingView.titleLabel.text = title;
        }
    });
}

@end
