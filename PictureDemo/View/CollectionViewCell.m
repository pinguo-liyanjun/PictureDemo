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

@property(assign, nonatomic)BOOL didSetupConstraits;

@end

@implementation CollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self addSubview:self.imageView];
        
        [self addSubview:self.selecetImageView];
        
        self.isSeleceted = NO;
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)dealloc
{
    self.isSeleceted = nil;
    self.didSetupConstraits = nil;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraits) {
        [self.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [self.selecetImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
        [self.selecetImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [self.selecetImageView autoSetDimensionsToSize:CGSizeMake(20, 20)];
        
        self.didSetupConstraits = YES;
    }
    [super updateConstraints];
}


#pragma mark --getter--
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initForAutoLayout];
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}

- (UIImageView *)selecetImageView
{
    if (!_selecetImageView) {
        _selecetImageView = [[UIImageView alloc]initForAutoLayout];
    }
    return _selecetImageView;
}

@end
