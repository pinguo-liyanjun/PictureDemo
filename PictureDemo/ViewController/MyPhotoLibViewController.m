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


@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataSourceArray;
@property(nonatomic, strong)NSMutableArray *dateArray;

@end

@implementation MyPhotoLibViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.returnAction = @selector(backAction:);
        self.doneAction = @selector(doneAction:);
        self.navTitle = [[Language sharedLanguage]stringForKey:@"myPhotoLibrary"];
        
        self.dataSourceArray =  [NSMutableArray arrayWithObjects:@[[UIImage imageNamed:@"imageSource/1.jpg"], [UIImage imageNamed:@"imageSource/2.jpg"],[UIImage imageNamed:@"imageSource/3.jpg"],[UIImage imageNamed:@"imageSource/4.jpg"],[UIImage imageNamed:@"imageSource/5.jpg"],[UIImage imageNamed:@"imageSource/6.jpg"],[UIImage imageNamed:@"imageSource/7.jpg"],[UIImage imageNamed:@"imageSource/8.jpg"],[UIImage imageNamed:@"imageSource/9.jpg"],[UIImage imageNamed:@"imageSource/10.jpg"],[UIImage imageNamed:@"imageSource/11.jpg"],[UIImage imageNamed:@"imageSource/12.jpg"],[UIImage imageNamed:@"imageSource/13.jpg"]],@[[UIImage imageNamed:@"imageSource/1.jpg"], [UIImage imageNamed:@"imageSource/2.jpg"],[UIImage imageNamed:@"imageSource/3.jpg"],[UIImage imageNamed:@"imageSource/4.jpg"],[UIImage imageNamed:@"imageSource/5.jpg"],[UIImage imageNamed:@"imageSource/6.jpg"],[UIImage imageNamed:@"imageSource/7.jpg"],[UIImage imageNamed:@"imageSource/8.jpg"],[UIImage imageNamed:@"imageSource/9.jpg"],[UIImage imageNamed:@"imageSource/10.jpg"],[UIImage imageNamed:@"imageSource/11.jpg"],[UIImage imageNamed:@"imageSource/12.jpg"],[UIImage imageNamed:@"imageSource/13.jpg"]],nil];
        self.dateArray = [NSMutableArray arrayWithObjects:@[[NSDate date]],[NSDate date], nil];
    }
    return self;
}

- (void)dealloc
{
    self.didSetupConstraints = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view insertSubview:self.collectionView belowSubview:self.navBar];
    
    [self.view setNeedsUpdateConstraints];
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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
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


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DEVIECE_MAINFRAME.size.width-40)/3, (DEVIECE_MAINFRAME.size.width-40)/3);
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


#pragma mark --Collection View Data Source --

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.dataSourceArray objectAtIndex:section]count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSourceArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVIECE_MAINFRAME.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, DEVIECE_MAINFRAME.size.width/3, 40)];
    dateLabel.text = [MyPhotoLibViewController getDateFromDate:[self.dateArray objectAtIndex:indexPath.section]];
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
    
    UIImage *image  = [self.dataSourceArray[indexPath.section] objectAtIndex:indexPath.row];
    cell.imageView.image = image;
    return cell;
}

#pragma mark -- CollectionView Delegate--
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    ShowPhotoViewController *showPhotoVC = [[ShowPhotoViewController alloc]initWithNibName:nil bundle:nil];
//    [showPhotoVC.dataSourceArray setArray:self.dataSourceArray[indexPath.section]];
//    showPhotoVC.currectIndex = indexPath.row;
//    if (self.navigationController) {
//        [self.navigationController pushViewController:showPhotoVC animated:YES];
//    }
//    else{
//        [self presentViewController:showPhotoVC animated:YES completion:nil];
//    }
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
+ (NSString *)getDateFromDate:(NSDate *)date
{
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString * nsDateString= [NSString stringWithFormat:@"%ld年-%ld月-%ld日",year,month,day];
    return nsDateString;
}


@end
