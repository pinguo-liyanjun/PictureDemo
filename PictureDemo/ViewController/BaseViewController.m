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

@property (strong, nonatomic)UIButton *mBackBtn;
@property (strong, nonatomic)UIButton *mDoneBtn;


@end

@implementation BaseViewController

@synthesize doneAction = _doneAction;
@synthesize returnAction = _returnAction;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.needSpeciallyLeftBtn = NO;
        self.needSpeciallyLeftBtn = NO;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (_returnAction)
    {
        if (self.leftBtn)
        {
            [self.navBar addSubview:self.leftBtn];
        }
        else
        {
            [self.navBar addSubview:self.mBackBtn];
        }
    }
    
    if (_doneAction)
    {
        if (self.rightBtn)
        {
            [self.navBar addSubview:self.rightBtn];
        }
        else
        {
            [self.navBar addSubview:self.mDoneBtn];
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
    [self.navBar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [self.navBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.navBar autoSetDimensionsToSize:CGSizeMake(CGRectGetWidth(self.view.frame), NAVIGATIONBAR_HEIGHT)];
    
    if (self.returnAction && self.mBackBtn &&!self.needSpeciallyLeftBtn)
    {
        [self.mBackBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.mBackBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.mBackBtn autoSetDimensionsToSize:CGSizeMake(44, NAVIGATIONBAR_HEIGHT)];
    }
    
    if (self.doneAction && self.mDoneBtn && !self.needSpeciallyRightBtn)
    {
        [self.mDoneBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.mDoneBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.mDoneBtn autoSetDimensionsToSize:CGSizeMake(44, NAVIGATIONBAR_HEIGHT)];
    }
    
    [super updateViewConstraints];
}


#pragma mark --getter--
- (NavigationBar *)navBar
{
    if (!_navBar)
    {
        _navBar = [[NavigationBar alloc]initForAutoLayout];
        _navBar.backgroundColor = [UIColor blackColor];
        _navBar.titleLabel.text = self.navTitle;
    }
    return _navBar;
}

- (UIButton *)mBackBtn
{
    if (!_mBackBtn)
    {
        _mBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mBackBtn setBackgroundImage:[UIImage imageNamed:@"return_normal"] forState:UIControlStateNormal];
        [_mBackBtn setBackgroundImage:[UIImage imageNamed:@"return_press"] forState:UIControlStateHighlighted];
        [_mBackBtn addTarget:self action:@selector(backAction:)
           forControlEvents:UIControlEventTouchUpInside];

    }
    return _mBackBtn;
}

- (UIButton *)mDoneBtn
{
    if (!_mDoneBtn)
    {
        _mDoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mDoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mDoneBtn setTitle:[[Language sharedLanguage] stringForKey:@"select"] forState:UIControlStateNormal];
        [_mDoneBtn setTitle:[[Language sharedLanguage] stringForKey:@"select"] forState:UIControlStateHighlighted];
        [_mDoneBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [_mDoneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _mDoneBtn;
}


#pragma mark --action funtion--
- (void)backAction:(id)sender
{

}

- (void)doneAction:(id)sender
{
   
}

#pragma <#arguments#>

@end
