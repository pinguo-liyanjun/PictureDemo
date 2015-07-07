//
//  EditPhotoViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/6.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "EditPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Default.h"
#import "Language.h"
#import "EditCollectionViewCell.h"

typedef NS_ENUM(NSInteger, EditType) {
    EditType_ShearPhotograph = 0,
    EditType_StickerPhotograph,
};

@interface EditPhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(strong, nonatomic)ALAssetsLibrary *assetsLibrary;
@property(strong, nonatomic)UICollectionView *collectionView;
@property(strong, nonatomic)NSMutableArray *editTypeArray;

@property(strong, nonatomic)UIView *topLineView;
@property(strong, nonatomic)UIView *leftLineView;
@property(strong, nonatomic)UIView *rightLineView;
@property(strong, nonatomic)UIView *bottomLineView;

@property(strong, nonatomic)UIImageView *topLeftCorner;
@property(strong, nonatomic)UIImageView *topRightCorner;
@property(strong, nonatomic)UIImageView *bottomLeftCorner;
@property(strong, nonatomic)UIImageView *bottomRightCorner;

@property(assign, nonatomic)EditType currectEditType;

@end

@implementation EditPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftBtn setFrame:CGRectMake(0, 0, 50, NAVIGATIONBAR_HEIGHT)];
        [self.leftBtn setTitle:[[Language sharedLanguage] stringForKey:@"back"] forState:UIControlStateNormal];
        [self.leftBtn setTitle:[[Language sharedLanguage] stringForKey:@"back"] forState:UIControlStateHighlighted];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[[UIColor yellowColor]colorWithAlphaComponent:.8] forState:UIControlStateHighlighted];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn setFrame:CGRectMake(0, 0, 50, NAVIGATIONBAR_HEIGHT)];
        [self.rightBtn setTitle:[[Language sharedLanguage] stringForKey:@"save"] forState:UIControlStateNormal];
        [self.rightBtn setTitle:[[Language sharedLanguage] stringForKey:@"save"] forState:UIControlStateHighlighted];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[[UIColor yellowColor]colorWithAlphaComponent:.8] forState:UIControlStateHighlighted];

        self.navTitle = [[Language sharedLanguage]stringForKey:@"edit"];
        self.returnAction = @selector(backAction:);
        self.doneAction = @selector(doneAction:);
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), DEVIECE_MAINFRAME.size.width, DEVIECE_MAINFRAME.size.height-CGRectGetHeight(self.navBar.frame)-60)];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.imageView belowSubview:self.navBar];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setHeaderReferenceSize:CGSizeMake(DEVIECE_MAINFRAME.size.width, 0)];
    layout.itemSize = CGSizeMake(45, 60);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imageView.frame), DEVIECE_MAINFRAME.size.width-10, 60) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor greenColor];
    self.collectionView.scrollEnabled = YES;
    [self.collectionView setScrollsToTop:YES];
    
    [self.collectionView registerClass:[EditCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
    [self.collectionView registerClass:[EditCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderIdentifier"];
    
    [self.view insertSubview:self.collectionView belowSubview:self.imageView];
    
    self.editTypeArray = [NSMutableArray arrayWithObjects:@{@"EditType":@(0),@"EditTypeImage":[UIImage imageNamed:@"image/shearPhotograph_normal"]},@{@"EditType":@(1),@"EditTypeImage":[UIImage imageNamed:@"image/stickerPhotograph_normal"]}, nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --Collection View Data Source --
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(45,60);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.editTypeArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVIECE_MAINFRAME.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, DEVIECE_MAINFRAME.size.width/3, 40)];
    dateLabel.text = @"";
    [headerView addSubview:dateLabel];
    
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderIdentifier" forIndexPath:indexPath];
    [reusableView addSubview:headerView];
    return reusableView;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID = @"CollectionCellIdentifier";
    EditCollectionViewCell *cell = (EditCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    [cell sizeToFit];
    
    UIImage *image  = [[self.editTypeArray objectAtIndex:indexPath.section] objectForKey:@"EditTypeImage"];
    cell.imageView.image = image;
    NSInteger editType = [[[self.editTypeArray objectAtIndex:indexPath.section] objectForKey:@"EditType"] integerValue];
    if (editType == EditType_ShearPhotograph) {
        cell.titleLabel.text = [[Language sharedLanguage]stringForKey:@"shearPhotograph"];
    }
    else if (editType == EditType_StickerPhotograph){
        cell.titleLabel.text = [[Language sharedLanguage]stringForKey:@"stickerPhotograph"];
    }
    else{
        //...
    }
    return cell;
}

#pragma mark -- CollectionView Delegate--
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark --Action funtion--
- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction:(id)sender
{
    
    
}

#pragma mark --help function--
//
//- (void)updateNavTitle:(NSString *)navtitle
//{
//    if (self.navBar) {
//        for (UIView *view in [self.navBar subviews]) {
//            if ([view isKindOfClass:[UILabel class]] && view.tag == 999) {
//                UILabel *titleLabel = (UILabel *)view;
//                titleLabel.text = navtitle;
//            }
//        }
//    }
//}


@end
