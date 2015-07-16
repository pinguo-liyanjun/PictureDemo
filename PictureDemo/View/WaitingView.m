//
//  WaitingView.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/14.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "WaitingView.h"
#import "PureLayout.h"
#import "GTMBase64.h"
#import "Default.h"

#define  COMMUNICATING_IMAGE_BASE64 @"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"

@interface WaitingView()

@property (strong, nonatomic)UIImageView *mBgImageView;
@property (strong, nonatomic)UIView *mContainerView;
@property (assign, nonatomic)BOOL mDidSetupConstraints;
@property (assign, nonatomic)CGFloat angle;
@property (assign, nonatomic)BOOL runLoop;

@end

@implementation WaitingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.mBgImageView];
        [self addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.waitingImageView];
        [self.mContainerView addSubview:self.titleLabel];
        
        self.angle = 0;
        self.runLoop = YES;
    }
    
    [self startAnimation];
    [self setNeedsUpdateConstraints];
    
    return self;
}

- (void)dealloc
{
    [self stopAnimation];
}

- (void)updateConstraints
{
    if (!_mDidSetupConstraints)
    {
        [self.mBgImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [self.mContainerView autoSetDimensionsToSize:CGSizeMake(180, 120)];
        [self.mContainerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(DEVIECE_MAINFRAME.size.width - 180)/2];
        [self.mContainerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(DEVIECE_MAINFRAME.size.height - 120)/2];
        
//        [self.waitingImageView autoSetDimensionsToSize:CGSizeMake(50, 50)];
//        [self.waitingImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
//        [self.waitingImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:65];
       
//        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft ];
//        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
//        [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.waitingImageView withOffset:10];
//        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        _mDidSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark --getter--
- (UIImageView *)mBgImageView
{
    if (!_mBgImageView)
    {
        _mBgImageView = [[UIImageView alloc]initForAutoLayout];
        _mBgImageView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:.5];
    }
    return _mBgImageView;
}

- (UIView *)mContainerView
{
    if (!_mContainerView) {
        _mContainerView = [[UIView alloc]initForAutoLayout];
        _mContainerView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.8];
    }
    return _mContainerView;
}

- (UIImageView *)waitingImageView
{
    if (!_waitingImageView) {
        _waitingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 60, 60)];
        _waitingImageView.backgroundColor = [UIColor clearColor];
        _waitingImageView.image = [UIImage imageWithData:[GTMBase64 decodeString:COMMUNICATING_IMAGE_BASE64]];
    }
    return _waitingImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 180, 40)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.minimumScaleFactor = 0.5;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

#pragma mark --Animation--

- (void)startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(continueAnimation)];
    self.waitingImageView.transform = CGAffineTransformMakeRotation(self.angle*(M_PI/180.0));
    [UIView commitAnimations];
}

- (void)continueAnimation
{
    if (self.runLoop) {
        self.angle += 15;
        [self startAnimation];
    }
}

- (void)stopAnimation
{
    self.runLoop = NO;
}

@end
