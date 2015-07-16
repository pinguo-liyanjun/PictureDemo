//
//  ImageTap.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/16.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "ImageTap.h"
#import "UIImage+Custom.h"

static CGRect oldFrame;

@implementation ImageTap

+ (void)image:(UIImage *)image TapShowFullScreen:(UIImageView *)imageView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    oldFrame = imageView.frame;
    UIImageView *temImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, oldFrame.size.width, oldFrame.size.height)];
    temImageView.contentMode = UIViewContentModeCenter;
    temImageView.image = [UIImage image:image ScaleToSize:backgroundView.frame.size];
    temImageView.tag = 1;
    [temImageView setCenter:backgroundView.center];
    [backgroundView addSubview:temImageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.5 animations:^{
        backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)hideImage:(UITapGestureRecognizer *)tap
{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [imageView setCenter:backgroundView.center];
    [UIView animateWithDuration:0.5 animations:^{
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}


@end
