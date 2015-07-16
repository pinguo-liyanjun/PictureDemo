//
//  CollectionViewCell.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/5.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UIImageView *selecetImageView;
@property (assign, nonatomic)BOOL isSeleceted;

- (void)updateCellWithImageSelected:(BOOL)selected;

@end
