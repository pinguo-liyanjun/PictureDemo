//
//  PhotoLibSelectorViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/5.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "PhotoLibSelectorViewController.h"
#import "Language.h"

@implementation PhotoLibSelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        MyPhotoLibViewController *myPhotoLibVC = [[MyPhotoLibViewController alloc]initWithNibName:nil bundle:nil];
        myPhotoLibVC.tabBarItem.title = [[Language sharedLanguage]stringForKey:@"myPhotoLibrary"];
        myPhotoLibVC.tabBarItem.image = [UIImage imageNamed:@"image/camera_normal"];
        myPhotoLibVC.tabBarItem.selectedImage = [UIImage imageNamed:@"image/camera_press"];
        
        OtherPhotoLibViewController *otherPhotoLibVC = [[OtherPhotoLibViewController alloc]initWithNibName:nil bundle:nil];
        otherPhotoLibVC.tabBarItem.title = [[Language sharedLanguage]stringForKey:@"otherPhotoLibrary"];
        otherPhotoLibVC.tabBarItem.image = [UIImage imageNamed:@"image/homepage_normal"];
        otherPhotoLibVC.tabBarItem.selectedImage = [UIImage imageNamed:@"iamge/homepage_press"];
        
        self.viewControllers = @[myPhotoLibVC,otherPhotoLibVC];
        UIImage *image = [UIImage imageNamed:@"image/nav_bg"];
        [self.tabBar setBackgroundImage:image];
    }
    return self;
}

@end
