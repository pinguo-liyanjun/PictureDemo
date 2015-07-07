//
//  BaseViewController.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/3.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"

@interface BaseViewController : UIViewController

@property(strong, nonatomic)NavigationBar *navBar;
@property(copy, nonatomic)NSString *navTitle;

//如果子类定制的按键，则使用定制按键 ，否则使用默认按键
@property(strong, nonatomic)UIButton *leftBtn;
@property(strong, nonatomic)UIButton *rightBtn;

@property(assign, nonatomic)SEL returnAction;
@property(assign, nonatomic)SEL doneAction;
@property(assign, nonatomic)BOOL didSetupConstraints;

@end
