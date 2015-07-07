//
//  TableViewCell.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/5.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property(strong, nonatomic)UIImageView *posterImageView;
@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)UILabel *photoCountLabel;
@property(strong, nonatomic)UIImageView *accessImageView;

@end
