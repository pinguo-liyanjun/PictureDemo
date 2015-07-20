//
//  ShearPhotographViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/10.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "ShearPhotographViewController.h"
#import "PureLayout.h"
#import "Language.h"

@interface ShearPhotographViewController ()

@property (strong, nonatomic)UIView *mToolBar;
@property (assign, nonatomic)BOOL mDidSetupConstraints;

@end


@implementation ShearPhotographViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.shearPhotoView];
    [self.view addSubview:self.mToolBar];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.mDidSetupConstraints)
    {
        
        self.mDidSetupConstraints = YES;
        [self.mToolBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.mToolBar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.mToolBar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.mToolBar autoSetDimension:ALDimensionHeight toSize:45];
      
    }
    
    [super updateViewConstraints];
}

#pragma mark --getter--

- (ShearPhotographView *)shearPhotoView
{
    if (!_shearPhotoView)
    {
        _shearPhotoView = [[ShearPhotographView alloc]initWithFrame:CGRectMake(5, 25, CGRectGetWidth(self.view.frame)-10, CGRectGetHeight(self.view.frame)-75)];
        if (self.origainImage)
        {
            [_shearPhotoView setSourceImage:self.origainImage];
        }
    }
    return _shearPhotoView;
}

- (UIView *)mToolBar
{
    if (!_mToolBar)
    {
        _mToolBar = [[UIView alloc]initForAutoLayout];
        _mToolBar.backgroundColor = [UIColor blackColor];
        
        UIButton *cancelBtn = [[UIButton alloc]initForAutoLayout];
        [cancelBtn setTitle:[[Language sharedLanguage]stringForKey:@"cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_mToolBar addSubview:cancelBtn];
        [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [cancelBtn autoSetDimension:ALDimensionWidth toSize:60];
        
        
        UIButton *okBtn = [[UIButton alloc]initForAutoLayout];
        [okBtn setTitle:[[Language sharedLanguage]stringForKey:@"ok"] forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [okBtn addTarget:self action:@selector(okBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_mToolBar addSubview:okBtn];
        [okBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [okBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [okBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [okBtn autoSetDimension:ALDimensionWidth toSize:60];
        
    }
    return _mToolBar;
}

#pragma mark --action function--
- (void)cancelBtnPressed:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)okBtnPressed:(id)sender
{
    UIImage *shearedImage = [self.shearPhotoView getShearedImage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getShearedImage:)]) {
        [self.delegate getShearedImage:shearedImage];
    }
   
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
