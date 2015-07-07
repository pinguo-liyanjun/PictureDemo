//
//  EditCollectionViewCell.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/6.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCollectionViewCell : UICollectionViewCell

@property(strong, nonatomic)UIImageView *imageView;
@property(strong, nonatomic)UILabel *titleLabel;
@property(assign, nonatomic)BOOL isSelected;

@end
