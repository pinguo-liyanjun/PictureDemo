//
//  Default.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/3.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#ifndef PictureDemo_Default_h
#define PictureDemo_Default_h

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//
#define DEVIECE_MAINFRAME   [[UIScreen mainScreen]applicationFrame]


//状态栏高度
#define STATUSBAR_HEIGHT            20

//导航条高度
#define NAVIGATIONBAR_HEIGHT        44

//window
#define FIRSTWINDOW ((UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0])

#endif
