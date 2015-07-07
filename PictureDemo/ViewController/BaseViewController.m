//
//  BaseViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/3.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Custom.h"
#import "Default.h"
#import "Language.h"
#import "PureLayout.h"

@interface BaseViewController ()
{
    SEL _doneAction;
    SEL _returnAction;
}

@property(strong, nonatomic)UIButton *backBtn;
@property(strong, nonatomic)UIButton *doneBtn;


@end

@implementation BaseViewController

@synthesize doneAction = _doneAction;
@synthesize returnAction = _returnAction;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.didSetupConstraints = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (_returnAction) {
        if (self.leftBtn) {
            [self.navBar addSubview:self.leftBtn];
        }else{
            [self.navBar addSubview:self.backBtn];
        }
    }
    
    if (_doneAction){
        if (self.rightBtn) {
            [self.navBar addSubview:self.rightBtn];
        }else {
            [self.navBar addSubview:self.doneBtn];
        }
    }
    
    [self.view addSubview:self.navBar];
    
    [self.view setNeedsUpdateConstraints];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [self.navBar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.navBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.navBar autoSetDimensionsToSize:CGSizeMake(CGRectGetWidth(self.view.frame), NAVIGATIONBAR_HEIGHT)];
    
    if (self.returnAction && self.backBtn) {
        [self.backBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.backBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.backBtn autoSetDimensionsToSize:CGSizeMake(44, NAVIGATIONBAR_HEIGHT)];
    }
    
    if (self.doneAction && self.doneBtn) {
        [self.doneBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.doneBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.doneBtn autoSetDimensionsToSize:CGSizeMake(44, NAVIGATIONBAR_HEIGHT)];
    }
    
    [super updateViewConstraints];
}


#pragma mark --getter--
- (NavigationBar *)navBar
{
    if (!_navBar) {
        _navBar = [[NavigationBar alloc]initForAutoLayout];
        _navBar.titleLabel.text = self.navTitle;
    }
    return _navBar;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"image/return_normal"] forState:UIControlStateNormal];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"image/return_press"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(backAction:)
           forControlEvents:UIControlEventTouchUpInside];

    }
    return _backBtn;
}

- (UIButton *)doneBtn
{
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setTitle:[[Language sharedLanguage] stringForKey:@"select"] forState:UIControlStateNormal];
        [_doneBtn setTitle:[[Language sharedLanguage] stringForKey:@"select"] forState:UIControlStateHighlighted];
        [_doneBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [_doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _doneBtn;
}

#pragma mark --action funtion--
- (void)backAction:(id)sender
{
    if (self.returnAction) {
        [self performSelector:self.returnAction withObject:nil];
    }
}

- (void)doneAction:(id)sender
{
    if (self.doneAction) {
        [self performSelector:self.doneAction withObject:nil];
    }
}

#pragma <#arguments#>

@end
