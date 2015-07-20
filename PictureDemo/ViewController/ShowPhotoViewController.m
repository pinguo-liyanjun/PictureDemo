//
//  ShowPhotoViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/6.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Default.h"
#import "CollectionViewCell.h"
#import "EditPhotoViewController.h"
#import "Language.h"
#import "PureLayout.h"
#import "UIImage+Custom.h"
#import "ImageTap.h"

@interface ShowPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *mCollectionView;
@property (strong, nonatomic) ALAssetsLibrary *mAssetLibrary;
@property (strong, nonatomic) UIImage *mCurrectImage;
@end

@implementation ShowPhotoViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftBtn setTitle:[[Language sharedLanguage] stringForKey:@"photoLibrary"] forState:UIControlStateNormal];
        [self.leftBtn setTitle:[[Language sharedLanguage] stringForKey:@"photoLibrary"] forState:UIControlStateHighlighted];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[[UIColor yellowColor]colorWithAlphaComponent:.8] forState:UIControlStateHighlighted];
        [self.leftBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn setTitle:[[Language sharedLanguage] stringForKey:@"edit"] forState:UIControlStateNormal];
        [self.rightBtn setTitle:[[Language sharedLanguage] stringForKey:@"edit"] forState:UIControlStateHighlighted];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[[UIColor yellowColor]colorWithAlphaComponent:.8] forState:UIControlStateHighlighted];
        [self.rightBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.dataSourceArray = [[NSMutableArray alloc]init];
        
        self.returnAction = @selector(backAction:);
        self.doneAction = @selector(doneAction:);
        self.mAssetLibrary = [[ALAssetsLibrary alloc]init];
        self.needSpeciallyLeftBtn = YES;
        self.needSpeciallyRightBtn = YES;
    }
    return self;
}

- (void)dealloc
{

}


- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.isAppSourceImage){
        [self getPhotographImageByGroupName:self.currectGroupName currectImageIndex:self.currectIndex];
    }
    
    [self.view addSubview:self.mCollectionView];
    [self.view setNeedsUpdateConstraints];
    
    NSString *navTitle = [NSString stringWithFormat:@"%ld/%ld",(long)self.currectIndex+1,(unsigned long)[self.dataSourceArray count]];
    [self updateNavTitle:navTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelectorOnMainThread:@selector(collectionViewScrollToIndexPath:) withObject:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] waitUntilDone:NO];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints)
    {
        self.didSetupConstraints = YES;
        [self.leftBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.leftBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.leftBtn autoSetDimensionsToSize:CGSizeMake(44, NAVIGATIONBAR_HEIGHT)];
        
        [self.rightBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.rightBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.rightBtn autoSetDimensionsToSize:CGSizeMake(44, NAVIGATIONBAR_HEIGHT)];
        
        [self.mCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navBar withOffset:0];
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.mCollectionView autoSetDimension:ALDimensionHeight toSize:DEVIECE_MAINFRAME.size.height-NAVIGATIONBAR_HEIGHT];

    
    }
    [super updateViewConstraints];
}

#pragma mark --getter--
- (UICollectionView *)mCollectionView
{
    if (!_mCollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setHeaderReferenceSize:CGSizeMake(0, 0)];
        layout.itemSize = CGSizeMake(DEVIECE_MAINFRAME.size.width-10,DEVIECE_MAINFRAME.size.height-NAVIGATIONBAR_HEIGHT-10);
        _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _mCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _mCollectionView.dataSource = self;
        _mCollectionView.delegate = self;
        _mCollectionView.backgroundColor = [UIColor lightGrayColor];
        _mCollectionView.scrollEnabled = NO;
        [_mCollectionView setScrollsToTop:YES];
        [_mCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
        [_mCollectionView registerClass:[CollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderIdentifier"];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [_mCollectionView addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [_mCollectionView addGestureRecognizer:swipeRight];
    }
    return _mCollectionView;
}


#pragma mark --Collection View Data Source --

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID = @"CollectionCellIdentifier";
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [cell addGestureRecognizer:tap];
    
    cell.imageView.contentMode = UIViewContentModeCenter;
    [cell sizeToFit];
    if (self.isAppSourceImage)
    {
        self.mCurrectImage = [self.dataSourceArray objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage image:[self.dataSourceArray objectAtIndex:indexPath.row] ScaleToSize:CGSizeMake(DEVIECE_MAINFRAME.size.width-10,DEVIECE_MAINFRAME.size.height-NAVIGATIONBAR_HEIGHT-10)];
    }
    else{
        cell.imageView.image = [UIImage image:self.mCurrectImage ScaleToSize:CGSizeMake(DEVIECE_MAINFRAME.size.width-10,DEVIECE_MAINFRAME.size.height-NAVIGATIONBAR_HEIGHT-10)];
    }
   
    return cell;
}

#pragma mark -- CollectionView Delegate--

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DEVIECE_MAINFRAME.size.width-10,DEVIECE_MAINFRAME.size.height-NAVIGATIONBAR_HEIGHT-10);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

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
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)doneAction:(id)sender
{
    EditPhotoViewController *editVC = [[EditPhotoViewController alloc]initWithNibName:nil bundle:nil];
    if (self.isAppSourceImage)
    {
         editVC.currectImage = [self.dataSourceArray objectAtIndex:self.currectIndex];
    }
    else
    {
        editVC.currectImage = self.mCurrectImage;
    }
    
    [self presentViewController:editVC animated:YES completion:nil];
}

- (void)swipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (self.currectIndex == [self.dataSourceArray count] - 1)
        {
            [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            if (!self.isAppSourceImage)
            {
                [self getPhotographImageByGroupName:self.currectGroupName currectImageIndex:(self.currectIndex)];
            }
        }
        else
        {
            self.currectIndex += 1;
            [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            if (!self.isAppSourceImage)
            {
                [self getPhotographImageByGroupName:self.currectGroupName currectImageIndex:(self.currectIndex)];
            }
        }
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (self.currectIndex == 0)
        {
             [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            if (!self.isAppSourceImage)
            {
                [self getPhotographImageByGroupName:self.currectGroupName currectImageIndex:(self.currectIndex)];
            }
        }
        else
        {
            self.currectIndex -= 1;
            [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            if (!self.isAppSourceImage)
            {
                [self getPhotographImageByGroupName:self.currectGroupName currectImageIndex:(self.currectIndex)];
            }
        }
    }
    
    NSString *navTitle = [NSString stringWithFormat:@"%ld/%ld",(long)self.currectIndex+1,(unsigned long)[self.dataSourceArray count]];
    [self updateNavTitle:navTitle];
}

#pragma mark --help function--
- (void)magnifyImage:(UITapGestureRecognizer *)tap
{
    CollectionViewCell *cell = (CollectionViewCell *)tap.view;
    [ImageTap image:self.mCurrectImage TapShowFullScreen:cell.imageView];
}

- (void)collectionViewScrollToIndexPath:(NSIndexPath *)indexPath
{
     [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}


- (void)updateNavTitle:(NSString *)navtitle
{
    if (self.navBar)
    {
        for (UIView *view in [self.navBar subviews])
        {
            if ([view isKindOfClass:[UILabel class]] && view.tag == 999)
            {
                UILabel *titleLabel = (UILabel *)view;
                titleLabel.text = navtitle;
            }
        }
    }
}

- (void)getPhotographImageByGroupName:(NSString *)groupName currectImageIndex:(NSInteger)currectImageIndex
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            if (group.numberOfAssets > 0 && [[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:groupName]){
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result && index == currectImageIndex) {
                        self.mCurrectImage = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                       [self.mCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                        return;
                    }
                }];
            }
        };
        
        NSUInteger groupTypes = ALAssetsGroupAll ;
        [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
            NSLog(@"Group not found!\n");
        }];
        
    });
}


@end
