//
//  NavigationBar.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/7.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "NavigationBar.h"
#import "PureLayout.h"

@interface NavigationBar ()

@property(assign ,nonatomic)BOOL didSetupConstraints;

@end

@implementation NavigationBar

- (id)initForAutoLayout
{
    self = [super initForAutoLayout];
    if (self) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.titleLabel];
        
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}


- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.backgroundView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.backgroundView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.backgroundView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.backgroundView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        
        NSLayoutConstraint *layout =  [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:70];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}

#pragma mark --getter--
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [UIImageView newAutoLayoutView];
        _backgroundView.backgroundColor = [UIColor redColor];
        _backgroundView.image = [UIImage imageNamed:@"image/nav_bg"];
    }
    return _backgroundView;
}

@end
