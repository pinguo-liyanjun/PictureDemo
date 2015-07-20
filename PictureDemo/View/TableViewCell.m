//
//  TableViewCell.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/5.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "TableViewCell.h"
#import "PureLayout.h"
@interface TableViewCell()

@property (assign, nonatomic)BOOL mDidSetupConstraints;

@end

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.posterImageView];
        
//        [self addSubview:self.accessImageView];
        
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.photoCountLabel];
        
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
        [self.posterImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        [self.posterImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.posterImageView autoSetDimensionsToSize:CGSizeMake(60,60)];
        
        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.posterImageView withOffset:10];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        [self.titleLabel  autoSetDimension:ALDimensionHeight toSize:36];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:70];
        
        [self.photoCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.posterImageView withOffset:10];
        [self.photoCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel];
        [self.photoCountLabel autoSetDimension:ALDimensionHeight toSize:24];
        [self.photoCountLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:70];
//        
//        [self.accessImageView autoSetDimensionsToSize:CGSizeMake(14, 14)];
//        [self.accessImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0];
//        [self.accessImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(CGRectGetHeight(self.frame)-14)/2];
//
    }

    [super updateConstraints];
}

#pragma mark --getter--
- (UIImageView *)posterImageView
{
    if (!_posterImageView)
    {
        _posterImageView = [[UIImageView alloc]initForAutoLayout];
        _posterImageView.backgroundColor = [UIColor clearColor];
    }
    return _posterImageView;
}

- (UIImageView *)accessImageView
{
    if (!_accessImageView)
    {
        _accessImageView = [[UIImageView alloc]initForAutoLayout];
        _accessImageView.backgroundColor = [UIColor clearColor];
        _accessImageView.image = [UIImage imageNamed:@"access_normal"];
    }
    return _accessImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initForAutoLayout];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)photoCountLabel
{
    if (!_photoCountLabel)
    {
        _photoCountLabel = [[UILabel alloc]initForAutoLayout];
        _photoCountLabel.font = [UIFont systemFontOfSize:14];
        _photoCountLabel.textColor = [UIColor lightGrayColor];
        _photoCountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _photoCountLabel;
}

@end
