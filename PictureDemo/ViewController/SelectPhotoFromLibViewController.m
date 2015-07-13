//
//  SelectPhotoFromLibViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/5.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "SelectPhotoFromLibViewController.h"
#import "CollectionViewCell.h"
#import "Default.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ShowPhotoViewController.h"
#import "PureLayout.h"

@interface SelectPhotoFromLibViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *mCollectionView;
@property (nonatomic, strong)NSMutableArray *mDataSourceArray;
@property (nonatomic, strong)NSMutableArray *mDateArray;
@property (nonatomic, strong)ALAssetsLibrary *mAssetsLibrary;
@property (nonatomic, strong)NSMutableArray *mFullScreenImageSourceArray;


@end

@implementation SelectPhotoFromLibViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.leftBtn = nil;
        self.rightBtn = nil;

        self.returnAction = @selector(backAction:);
        self.doneAction = @selector(doneAction:);
        
        self.mDataSourceArray = [[NSMutableArray alloc]init];
        self.mDateArray = [[NSMutableArray alloc]init];
        self.mFullScreenImageSourceArray = [[NSMutableArray alloc]init];
        self.mAssetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

- (void)dealloc
{
  
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mCollectionView];
    
    [self getPhotoFromLibByName:self.navTitle];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints)
    {
        [self.mCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navBar withOffset:0];
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];

        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark --getter--
- (UICollectionView *)mCollectionView
{
    if (!_mCollectionView)
    {
         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [layout setHeaderReferenceSize:CGSizeMake(DEVIECE_MAINFRAME.size.width, 40)];
        layout.itemSize = CGSizeMake((DEVIECE_MAINFRAME.size.width-45)/3, (DEVIECE_MAINFRAME.size.width-45)/3);
        _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _mCollectionView.dataSource = self;
        _mCollectionView.delegate = self;
        _mCollectionView.backgroundColor = [UIColor whiteColor];
        _mCollectionView.scrollEnabled = YES;
        [_mCollectionView setScrollsToTop:YES];
        [_mCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
        [_mCollectionView registerClass:[CollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderIdentifier"];
    }
    return _mCollectionView;
}

#pragma mark --CollectionView Delegate--

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DEVIECE_MAINFRAME.size.width-45)/3, (DEVIECE_MAINFRAME.size.width-45)/3);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


#pragma mark --CollectionView DataSource --

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mDataSourceArray.count;
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
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    [cell sizeToFit];
    
    UIImage *image  = [self.mDataSourceArray objectAtIndex:indexPath.row];
    cell.imageView.image = image;
    return cell;
}

#pragma mark -- CollectionView Delegate--
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowPhotoViewController *showPhotoVC = [[ShowPhotoViewController alloc]initWithNibName:nil bundle:nil];
    [showPhotoVC.dataSourceArray setArray:self.mDataSourceArray];
    showPhotoVC.currectIndex = indexPath.row;
    showPhotoVC.currectGroupName = self.navTitle;
    showPhotoVC.isAppSourceImage = NO;
    if (self.navigationController)
    {
        [self.navigationController pushViewController:showPhotoVC animated:YES];
    }
    else
    {
        [self presentViewController:showPhotoVC animated:YES completion:nil];
    }
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
    
}

#pragma mark --help function--
- (void)getPhotoFromLibByName:(NSString *)groupName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.mDateArray removeAllObjects];
        [self.mDataSourceArray removeAllObjects];
        [self.mFullScreenImageSourceArray removeAllObjects];
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            if (group.numberOfAssets > 0 && [[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:groupName]){
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        [self.mDataSourceArray addObject:[UIImage imageWithCGImage: result.thumbnail]];
                        NSString *date=[result valueForProperty:ALAssetPropertyDate];
                        [self.mDateArray addObject:date];
                    }
                    else{
                        [self.mCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                    }
                }];
            }
        };
        
        NSUInteger groupTypes = ALAssetsGroupAll ;
        [self.mAssetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
            NSLog(@"Group not found!\n");
        }];
    });
}


@end
