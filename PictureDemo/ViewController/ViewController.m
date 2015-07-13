//
//  ViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/3.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "Default.h"
#import "PhotoLibSelectorViewController.h"
#import "EditPhotoViewController.h"
#import "ShearPhotographView.h"
#import "UIImage+Custom.h"

@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *bgImage = [UIImage imageNamed:@"Default"];
    
    UIImage *image = [UIImage rectangleImageWithName:bgImage andWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) borderWidth:0 borderColor:[UIColor greenColor]];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    bgImageView.image = image;
    [self.view addSubview:bgImageView];

    self.navigationController.navigationBar.hidden = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    //for test
    BOOL result = [self createAFilePathToSaveImage:@"ImageSource"];
    if (result) {
        NSArray *temImageArray =  @[[UIImage imageNamed:@"1.jpg"], [UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"4.jpg"],[UIImage imageNamed:@"5.jpg"],[UIImage imageNamed:@"6.jpg"],[UIImage imageNamed: @"7.jpg"],[UIImage imageNamed:@"8.jpg"],[UIImage imageNamed:@"9.jpg"],[UIImage imageNamed:@"10.jpg"],[UIImage imageNamed:@"11.jpg"],[UIImage imageNamed: @"12.jpg"],[UIImage imageNamed: @"13.jpg"]];
        BOOL haveWritten = [[[NSUserDefaults standardUserDefaults]objectForKey:@"HaveWritten"] boolValue];
        if (haveWritten) {
            return;
        }
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ImageSource"];
        for (NSInteger i = 0; i < 13; i++) {
            UIImage *image = [temImageArray objectAtIndex:i];
            NSData *imageData = UIImagePNGRepresentation(image);
            NSString *imagePath = [NSString stringWithFormat:@"%@/%ld.jpg",path,(long)i+1];
            BOOL flag = [imageData writeToFile:imagePath atomically:YES];
            NSLog(@"%ld",flag);
        }
        [[NSUserDefaults standardUserDefaults]setObject:@(1) forKey:@"HaveWritten"];
    }
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapAction:(id)sender
{
    PhotoLibSelectorViewController *photoSelectorVC = [[PhotoLibSelectorViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:photoSelectorVC animated:YES];

}

- (BOOL)createAFilePathToSaveImage:(NSString *)FilePathName
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:FilePathName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!result) {
            NSLog(@"创建文件夹失败");
            return NO;
        }
        return YES;
    }
    return YES;
}


@end
