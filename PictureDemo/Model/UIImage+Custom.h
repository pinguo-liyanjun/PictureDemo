//
//  UIImage+Custom.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/3.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Custom)

+ (UIImage *)circleImageWithName:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)circleImageWithName:(UIImage *)image circleCenter:(CGPoint)center circleRadius:(CGFloat)radius  borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)rectangleImageWithName:(UIImage *)image andWithFrame:(CGRect)rect borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)circleAndRectangleImageWithName:(UIImage *)image circleCenter:(CGPoint)center circleRadius:(CGFloat)radius frame:(CGRect)rect borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)image:(UIImage *)image ScaleToSize:(CGSize)size;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
