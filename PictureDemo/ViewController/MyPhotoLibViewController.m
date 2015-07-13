//
//  MyPhotoLibViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/5.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "MyPhotoLibViewController.h"
#import "CollectionViewCell.h"
#import "Default.h"
#import "ShowPhotoViewController.h"
#import "PureLayout.h"
#import "Language.h"

@interface MyPhotoLibViewController()<UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, strong)UICollectionView *mCollectionView;
@property (nonatomic, strong)NSMutableArray *mDataSourceArray;
@property (nonatomic, strong)NSMutableArray *mDateArray;

@end

@implementation MyPhotoLibViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.returnAction = @selector(backAction:);
        self.doneAction = @selector(doneAction:);
        self.navTitle = [[Language sharedLanguage]stringForKey:@"myPhotoLibrary"];
        self.mDataSourceArray = [[NSMutableArray alloc]init];
        
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ImageSource"];
        NSError *error = nil;
        NSArray *fileNameArray = [[NSFileManager defaultManager]subpathsOfDirectoryAtPath:path error:&error];
        for (NSInteger i = 0; i < [fileNameArray count]; i++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",path,[fileNameArray objectAtIndex:i]]];
            [self.mDataSourceArray addObject:image];
        }
        self.mDateArray = [NSMutableArray arrayWithObjects:@[[NSDate date]],[NSDate date], nil];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.mCollectionView];
    
    [self.view setNeedsUpdateConstraints];
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
        layout.itemSize = CGSizeMake((DEVIECE_MAINFRAME.size.width-45)/3 , (DEVIECE_MAINFRAME.size.width-45)/3 );
        _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _mCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
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


#pragma mark --Collection View Data Source --

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.mDataSourceArray count];
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
    dateLabel.text = [MyPhotoLibViewController getDateFromDate:[self.mDateArray objectAtIndex:indexPath.section]];
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DEVIECE_MAINFRAME.size.width-45)/3, (DEVIECE_MAINFRAME.size.width-45)/3);
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
    ShowPhotoViewController *showPhotoVC = [[ShowPhotoViewController alloc]initWithNibName:nil bundle:nil];
    [showPhotoVC.dataSourceArray setArray:self.mDataSourceArray];
    showPhotoVC.currectIndex = indexPath.row;
    showPhotoVC.currectGroupName = self.navTitle;
    showPhotoVC.isAppSourceImage = YES;
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
+ (NSString *)getDateFromDate:(NSDate *)date
{
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString * nsDateString= [NSString stringWithFormat:@"%ld年-%ld月-%ld日",(long)year,(long)month,(long)day];
    return nsDateString;
}


@end
