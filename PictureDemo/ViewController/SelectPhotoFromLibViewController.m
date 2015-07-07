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

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataSourceArray;
@property(nonatomic, strong)NSMutableArray *dateArray;
@property(nonatomic, strong)ALAssetsLibrary *assetsLibrary;
@property(nonatomic, strong)NSMutableArray *fullScreenImageSourceArray;


@end

@implementation SelectPhotoFromLibViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.leftBtn = nil;
        self.rightBtn = nil;

        self.returnAction = @selector(backAction:);
        self.doneAction = @selector(doneAction:);
        
        self.dataSourceArray = [[NSMutableArray alloc]init];
        self.dateArray = [[NSMutableArray alloc]init];
        self.fullScreenImageSourceArray = [[NSMutableArray alloc]init];
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

- (void)dealloc
{
  
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.collectionView belowSubview:self.navBar];
    [self getPhotoFromLibByName:self.navTitle];
    [self.view setNeedsUpdateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.collectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navBar withOffset:0];
        [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
        [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];

        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark --getter--
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [layout setHeaderReferenceSize:CGSizeMake(DEVIECE_MAINFRAME.size.width, 40)];
        layout.itemSize = CGSizeMake((DEVIECE_MAINFRAME.size.width-30)/3, (DEVIECE_MAINFRAME.size.width-30)/3);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = YES;
        [_collectionView setScrollsToTop:YES];
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
        [_collectionView registerClass:[CollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderIdentifier"];
    }
    return _collectionView;
}

#pragma mark --CollectionView Delegate--

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DEVIECE_MAINFRAME.size.width-40)/3, (DEVIECE_MAINFRAME.size.width-40)/3);
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
//    return [[self.dataSourceArray objectAtIndex:section]count];
    return self.dataSourceArray.count;
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
    
    UIImage *image  = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.imageView.image = image;
    return cell;
}

#pragma mark -- CollectionView Delegate--
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShowPhotoViewController *showPhotoVC = [[ShowPhotoViewController alloc]initWithNibName:nil bundle:nil];
    [showPhotoVC.dataSourceArray setArray:self.fullScreenImageSourceArray];
    showPhotoVC.currectIndex = indexPath.row;
    if (self.navigationController) {
        [self.navigationController pushViewController:showPhotoVC animated:YES];
    }
    else{
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
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)doneAction:(id)sender
{
    
}

#pragma mark --help function--
- (void)getPhotoFromLibByName:(NSString *)groupName{
    [self.dateArray removeAllObjects];
    [self.dataSourceArray removeAllObjects];
    [self.fullScreenImageSourceArray removeAllObjects];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if (group.numberOfAssets > 0 && [[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:groupName]){
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [self.dataSourceArray addObject:[UIImage imageWithCGImage: result.thumbnail]];
                    NSString *date=[result valueForProperty:ALAssetPropertyDate];
                    [self.dateArray addObject:date];
                    [self.fullScreenImageSourceArray addObject:[UIImage imageWithCGImage:[result defaultRepresentation].fullScreenImage]];
                }
                else{
                 [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }
            }];
        }
    };
    
    NSUInteger groupTypes = ALAssetsGroupAll ;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        NSLog(@"Group not found!\n");
    }];
}


@end
