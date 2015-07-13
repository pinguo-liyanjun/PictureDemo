//
//  StickerPhotographView.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/12.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StickerPhotographType)
{
    StickerPhotographType_Circle = 0,
    StickerPhotographType_Ractangle,
    StickerPhotographType_Circle_Ractangle
};

@interface StickerPhotographView : UIView

@property (strong, nonatomic)UIImage *originalImage;

@property (assign, nonatomic)StickerPhotographType stickerType;

- (void)setSourceImage:(UIImage *)sourceImage;

- (UIImage *)getStickerPhotographImage;

@end
