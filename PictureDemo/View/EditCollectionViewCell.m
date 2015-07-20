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

@property (assign, nonatomic)BOOL mDidSetupConstraints;

@end

@implementation EditCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.imageView];
        
        [self addSubview:self.titleLabel];
        
        self.isSelected = NO;
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)dealloc
{
    
}


- (void)updateConstraints
{
    if (!self.mDidSetupConstraints)
    {
        self.mDidSetupConstraints = YES;
        [self.imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        [self.imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
        [self.imageView autoSetDimensionsToSize:CGSizeMake(34, 34)];
        
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight  withInset:0];
        [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.imageView withOffset:5];
        [self.titleLabel autoSetDimension:ALDimensionHeight toSize:30];
        
    }
    [super updateConstraints];
}

#pragma mark --getter--

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc]initForAutoLayout];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        
    }
    return _titleLabel;
}

#pragma mark --touch event--
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.titleLabel.textColor = [UIColor clearColor];
    if (self.imageDic && [[self.imageDic allKeys] containsObject:@"EditTypeImagePress"])
    {
        self.imageView.image = [self.imageDic objectForKey:@"EditTypeImagePress"];
        self.titleLabel.textColor = [UIColor yellowColor];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    if (self.imageDic && [[self.imageDic allKeys] containsObject:@"EditTypeImageNormal"])
    {
        self.imageView.image = [self.imageDic objectForKey:@"EditTypeImageNormal"];
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

@end
