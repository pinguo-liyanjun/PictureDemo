//
//  CollectionViewCell.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/5.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "CollectionViewCell.h"
#import "PureLayout.h"

@interface CollectionViewCell ()

@property (assign, nonatomic)BOOL mDidSetupConstraints;

@end

@implementation CollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.imageView];
        
        [self addSubview:self.selecetImageView];
        
        self.isSeleceted = NO;
        
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
        [self.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [self.selecetImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
        [self.selecetImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [self.selecetImageView autoSetDimensionsToSize:CGSizeMake(20, 20)];
        
        self.mDidSetupConstraints = YES;
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

- (UIImageView *)selecetImageView
{
    if (!_selecetImageView)
    {
        _selecetImageView = [[UIImageView alloc]initForAutoLayout];
        _selecetImageView.backgroundColor = [UIColor clearColor];
    }
    return _selecetImageView;
}

#pragma mark --public function--

- (void)updateCellWithImageSelected:(BOOL)selected
{
    if (selected)
    {
        self.selecetImageView.backgroundColor = [UIColor greenColor];
        self.isSeleceted = YES;
    }
    else
    {
        self.selecetImageView.backgroundColor = [UIColor clearColor];
        self.isSeleceted = NO;
    }
}

@end
