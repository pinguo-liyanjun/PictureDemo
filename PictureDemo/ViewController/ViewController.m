//
//  ViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/3.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"

#import "PhotoLibSelectorViewController.h"

@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bgImage = [UIImage imageNamed:@"image/Default-800-667h"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
    self.navigationController.navigationBar.hidden = YES;
  
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
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

@end
