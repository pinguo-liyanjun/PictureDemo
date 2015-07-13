//
//  StickerPhotographViewController.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/12.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerPhotographView.h"

@protocol StickerPhotographViewControllerDelegate <NSObject>

@required

- (void)getStickerPhotographImage:(UIImage *)stickerPhotographImage;

@end

@interface StickerPhotographViewController : UIViewController

@property (strong, nonatomic)StickerPhotographView *stickerPhotoView;
@property (strong, nonatomic)UIImage *origainImage;
@property (weak, nonatomic)id<StickerPhotographViewControllerDelegate>delegate;

@end
