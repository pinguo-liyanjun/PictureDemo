//
//  ShearPhotographView.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/9.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShearPhotographView : UIView

@property (strong, nonatomic)UIImage *originalImage;

- (void)setSourceImage:(UIImage *)sourceImage;

- (UIImage *)getShearedImage;

@end
