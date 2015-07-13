//
//  ShearPhotographViewController.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/10.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShearPhotographView.h"

@protocol ShearPhotographViewControllerDelegate <NSObject>

@required

- (void)getShearedImage:(UIImage *)shearedImage;

@end

@interface ShearPhotographViewController : UIViewController

@property (strong, nonatomic)ShearPhotographView *shearPhotoView;

@property (strong, nonatomic)UIImage *origainImage;

@property (weak, nonatomic)id<ShearPhotographViewControllerDelegate> delegate;

@end

