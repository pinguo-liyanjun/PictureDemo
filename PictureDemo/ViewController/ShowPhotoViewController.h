//
//  ShowPhotoViewController.h
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/6.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "BaseViewController.h"

@interface ShowPhotoViewController : BaseViewController

@property (strong, nonatomic)NSMutableArray *dataSourceArray;
@property (assign, nonatomic)NSInteger currectIndex;
@property (strong, nonatomic)NSString *currectGroupName;
@property (assign, nonatomic)BOOL isAppSourceImage;
@end
