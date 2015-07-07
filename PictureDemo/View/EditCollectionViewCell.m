//
//  EditCollectionViewCell.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/6.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "EditCollectionViewCell.h"
#import "PureLayout.h"

@interface EditCollectionViewCell ()

@property(assign, nonatomic)BOOL didSetupConstraits;

@end

@implementation EditCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [UIImageView newAutoLayoutView];
        self.imageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self addSubview:self.titleLabel];
        
        self.isSelected = NO;
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)dealloc
{
    self.isSelected = nil;
    self.didSetupConstraits = nil;
}


- (void)updateConstraints
{
    if (!self.didSetupConstraits) {
        [self.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight  withInset:0];
        [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.imageView withOffset:0];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        self.didSetupConstraits = YES;
    }
    [super updateConstraints];
}

#pragma mark --getter--

@end
