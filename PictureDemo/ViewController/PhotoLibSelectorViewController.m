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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        MyPhotoLibViewController *myPhotoLibVC = [[MyPhotoLibViewController alloc]initWithNibName:nil bundle:nil];
        myPhotoLibVC.tabBarItem.title = [[Language sharedLanguage]stringForKey:@"myPhotoLibrary"];
        myPhotoLibVC.tabBarItem.image = [UIImage imageNamed:@"camera_normal"];
        myPhotoLibVC.tabBarItem.selectedImage = [UIImage imageNamed:@"camera_press"];
        
        OtherPhotoLibViewController *otherPhotoLibVC = [[OtherPhotoLibViewController alloc]initWithNibName:nil bundle:nil];
        otherPhotoLibVC.tabBarItem.title = [[Language sharedLanguage]stringForKey:@"otherPhotoLibrary"];
        otherPhotoLibVC.tabBarItem.image = [UIImage imageNamed:@"homepage_normal"];
        otherPhotoLibVC.tabBarItem.selectedImage = [UIImage imageNamed:@"homepage_press"];
        
        self.viewControllers = @[myPhotoLibVC,otherPhotoLibVC];
        UIImage *image = [UIImage imageNamed:@"nav_bg"];
        [self.tabBar setBackgroundImage:image];
    }
    return self;
}

@end
