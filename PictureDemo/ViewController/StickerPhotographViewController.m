//
//  StickerPhotographViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/12.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "StickerPhotographViewController.h"
#import "PureLayout.h"
#import "StickerPhotographTypeCell.h"
#import "Language.h"

@interface StickerPhotographViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic)UIView *mToolBar;
@property (assign, nonatomic)BOOL mDidSetupConstraints;
@property (strong, nonatomic)UICollectionView *mStickerPhotographTypeCollectionView;
@property (strong, nonatomic)NSMutableArray *mStickerPhotographTypeArray;
@property (strong, nonatomic)NSIndexPath *mSelectedIndexPath;

@end

@implementation StickerPhotographViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.mStickerPhotographTypeArray = [NSMutableArray arrayWithObjects:@{@"StickerPhotographType":@(StickerPhotographType_Circle),@"StickerPhotographTypeImageNormal":[UIImage imageNamed:@"circle_normal"],@"StickerPhotographTypeImagePress":[UIImage imageNamed:@"circle_press"]},@{@"StickerPhotographType":@(StickerPhotographType_Ractangle),@"StickerPhotographTypeImageNormal":[UIImage imageNamed:@"rectangle_normal"],@"StickerPhotographTypeImagePress":[UIImage imageNamed:@"rectangle_press"]}/*,@{@"StickerPhotographType":@(StickerPhotographType_Circle_Ractangle),@"StickerPhotographTypeImageNormal":[UIImage imageNamed:@"circle_rectangle_normal"],@"StickerPhotographTypeImagePress":[UIImage imageNamed:@"circle_rectangle_press"]}*/, nil];
        self.mSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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
    
    [self.view addSubview:self.stickerPhotoView];
    [self.view addSubview:self.mToolBar];
    [self.view addSubview:self.mStickerPhotographTypeCollectionView];
    
    
    
    [self.view setNeedsUpdateConstraints];

}

- (void)updateViewConstraints
{
    if (!self.mDidSetupConstraints)
    {
        [self.mStickerPhotographTypeCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.stickerPhotoView];
        [self.mStickerPhotographTypeCollectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.mStickerPhotographTypeCollectionView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.mStickerPhotographTypeCollectionView autoSetDimension:ALDimensionHeight toSize:75];
        
        [self.mToolBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.mToolBar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.mToolBar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.mToolBar autoSetDimension:ALDimensionHeight toSize:44];
        
        self.mDidSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark --getter--
- (StickerPhotographView *)stickerPhotoView
{
    if (!_stickerPhotoView) {
        _stickerPhotoView = [[StickerPhotographView alloc]initWithFrame:CGRectMake(5, 25, CGRectGetWidth(self.view.frame)-10, CGRectGetHeight(self.view.frame)-140)];
        if (self.origainImage) {
            [_stickerPhotoView setSourceImage:self.origainImage];
        }
    }
    
    return _stickerPhotoView;
}

- (UICollectionView *)mStickerPhotographTypeCollectionView
{
    if (!_mStickerPhotographTypeCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setHeaderReferenceSize:CGSizeMake(0, 0)];
        [flowLayout setFooterReferenceSize:CGSizeMake(0, 0)];
        flowLayout.itemSize = CGSizeMake(70, 74);
        _mStickerPhotographTypeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _mStickerPhotographTypeCollectionView.delegate = self;
        _mStickerPhotographTypeCollectionView.dataSource = self;
        _mStickerPhotographTypeCollectionView.backgroundColor = [UIColor lightGrayColor];
        _mStickerPhotographTypeCollectionView.scrollEnabled = NO;
        [_mStickerPhotographTypeCollectionView setScrollsToTop:YES];
        [_mStickerPhotographTypeCollectionView registerClass:[StickerPhotographTypeCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
        [_mStickerPhotographTypeCollectionView registerClass:[StickerPhotographTypeCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderIdentifier"];
    }
    return  _mStickerPhotographTypeCollectionView;
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
    UIImage *stickerPhotographImage = [self.stickerPhotoView getStickerPhotographImage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getStickerPhotographImage:)]) {
        [self.delegate getStickerPhotographImage:stickerPhotographImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --Collection View Data Source --
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70,74);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mStickerPhotographTypeArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID = @"CollectionCellIdentifier";
    StickerPhotographTypeCell *cell = (StickerPhotographTypeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    [cell sizeToFit];
    
    UIImage *image  = [[self.mStickerPhotographTypeArray objectAtIndex:indexPath.row] objectForKey:@"StickerPhotographTypeImageNormal"];
    cell.imageDic = [self.mStickerPhotographTypeArray objectAtIndex:indexPath.row];
    cell.imageView.image = image;
    NSInteger stickerPhotographType = [[[self.mStickerPhotographTypeArray objectAtIndex:indexPath.row] objectForKey:@"StickerPhotographType"] integerValue];
    if (indexPath.row == 0) {
        cell.imageView.image = [[self.mStickerPhotographTypeArray objectAtIndex:indexPath.row] objectForKey:@"StickerPhotographTypeImagePress"];
        cell.titleLabel.textColor = [UIColor yellowColor];
    }
    
    
    if (stickerPhotographType == StickerPhotographType_Circle)
    {
        cell.titleLabel.text = [[Language sharedLanguage]stringForKey:@"circle"];
    }
    else if(stickerPhotographType == StickerPhotographType_Ractangle)
    {
        cell.titleLabel.text = [[Language sharedLanguage]stringForKey:@"rectangle"];
    }
    else if(stickerPhotographType == StickerPhotographType_Circle_Ractangle)
    {
        cell.titleLabel.text = [[Language sharedLanguage]stringForKey:@"circle_rectangle"];
    }
    
    return cell;
}

#pragma mark -- CollectionView Delegate--

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.mSelectedIndexPath.row != indexPath.row)
    {
        StickerPhotographTypeCell *cell = (StickerPhotographTypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.imageView.image = [[self.mStickerPhotographTypeArray objectAtIndex:indexPath.row] objectForKey:@"StickerPhotographTypeImagePress"];
        cell.titleLabel.textColor = [UIColor yellowColor];
        
        StickerPhotographTypeCell *pre_Cell = (StickerPhotographTypeCell *)[collectionView cellForItemAtIndexPath:self.mSelectedIndexPath];
        pre_Cell.imageView.image = [[self.mStickerPhotographTypeArray objectAtIndex:self.mSelectedIndexPath.row] objectForKey:@"StickerPhotographTypeImageNormal"];
        pre_Cell.titleLabel.textColor = [UIColor whiteColor];
        
        self.mSelectedIndexPath = indexPath;
    }
    
    if (indexPath.row == 0)
    {
        self.stickerPhotoView.stickerType = StickerPhotographType_Circle;
    }
    else if(indexPath.row == 1)
    {
        self.stickerPhotoView.stickerType = StickerPhotographType_Ractangle;
    }
    else if (indexPath.row == 2)
    {
        self.stickerPhotoView.stickerType = StickerPhotographType_Circle_Ractangle;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
