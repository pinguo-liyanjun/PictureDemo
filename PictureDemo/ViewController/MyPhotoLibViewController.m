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
#import "TaskHelper.h"
#import "PadManager.h"
#import "UIImage+Custom.h"

@interface MyPhotoLibViewController()<UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, strong)UICollectionView *mCollectionView;
@property (nonatomic, strong)NSMutableArray *mDataSourceArray;
@property (nonatomic, strong)NSMutableArray *mDateArray;
@property (nonatomic, assign)BOOL mCanSelected;
@property (nonatomic, strong)UIView *mToolBar;
@property (nonatomic, strong)NSMutableArray *mSelectedImageArray;
@property (nonatomic ,strong)NSMutableArray *mSelectedIndexArray;
@property (nonatomic, copy)NSMutableString *exportTitle;

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
        [self getSourceImage];
        self.mDateArray = [NSMutableArray arrayWithObjects:@[[NSDate date]],[NSDate date], nil];
        self.mSelectedImageArray = [[NSMutableArray alloc]init];
        self.mSelectedIndexArray = [[NSMutableArray alloc]init];
        self.mCanSelected = NO;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelectorInBackground:@selector(getSourceImage) withObject:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.mCollectionView];
    [self.tabBarController.tabBar addSubview:self.mToolBar];
    
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

- (UIView *)mToolBar
{
    if (!_mToolBar)
    {
      
        _mToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tabBarController.tabBar.frame), CGRectGetHeight(self.tabBarController.tabBar.frame))];
        _mToolBar.hidden = YES;
        _mToolBar.backgroundColor = [UIColor blackColor] ;
        
        UIButton *cancelBtn = [[UIButton alloc]initForAutoLayout];
        [cancelBtn setTitle:[[Language sharedLanguage]stringForKey:@"cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_mToolBar addSubview:cancelBtn];
        [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [cancelBtn autoSetDimension:ALDimensionWidth toSize:60];
        
        UIButton *importBtn = [[UIButton alloc]initForAutoLayout];
        [importBtn setTitle:[[Language sharedLanguage]stringForKey:@"export"] forState:UIControlStateNormal];
        [importBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [importBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [importBtn addTarget:self action:@selector(exportImage:) forControlEvents:UIControlEventTouchUpInside];
        [_mToolBar addSubview:importBtn];
        [importBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [importBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [importBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [importBtn autoSetDimension:ALDimensionWidth toSize:60];
        
    }
    return _mToolBar;
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
    [cell updateCellWithImageSelected:NO];
    if ([self.mSelectedIndexArray containsObject:@(indexPath.row)]) {
        [cell updateCellWithImageSelected:YES];
    }
    
    [cell sizeToFit];
    
    UIImage *image  = [self.mDataSourceArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage getThumbnailImage:image withThumbnalSize:CGSizeMake((DEVIECE_MAINFRAME.size.width-45)/3, (DEVIECE_MAINFRAME.size.width-45)/3)];
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
    if (!self.mCanSelected)
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
    else
    {
        CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.isSeleceted)
        {
            [cell updateCellWithImageSelected:NO];
            if([self.mSelectedImageArray containsObject:[self.mDataSourceArray objectAtIndex:indexPath.row]])
            {
                [self.mSelectedImageArray removeObject:[self.mDataSourceArray objectAtIndex:indexPath.row]];
            }
            if ([self.mSelectedIndexArray containsObject:@(indexPath.row)]) {
                [self.mSelectedIndexArray removeObject:@(indexPath.row)];
            }
        }
        else
        {
            [cell updateCellWithImageSelected:YES];
            [self.mSelectedImageArray addObject:[self.mDataSourceArray objectAtIndex:indexPath.row]];
            [self.mSelectedIndexArray addObject:@(indexPath.row)];
        }
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
    self.mCanSelected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.tabBarController.tabBar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)+49, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.tabBarController.tabBar.frame))];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mToolBar.hidden = NO;
            [self.tabBarController.tabBar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.tabBarController.tabBar.frame))];
        }];
    }];
}

- (void)cancelSelect:(id)sender
{
    self.mCanSelected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.tabBarController.tabBar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)+49, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.tabBarController.tabBar.frame))];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mToolBar.hidden = YES;
            [self.tabBarController.tabBar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.tabBarController.tabBar.frame))];
        }];
    }];
    
    for (UIView *view in [self.mCollectionView subviews]) {
        if ([view isKindOfClass:[CollectionViewCell class]]) {
            CollectionViewCell *cell = (CollectionViewCell *)view;
            if (cell.isSeleceted) {
                [cell updateCellWithImageSelected:NO];
            }
        }
    }
}

- (void)exportImage:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PadManager sharedPadManagerInstance]setPadStatus:PadStatusType_Waiting withInDic:nil resultBlock:nil];
        [[TaskHelper sharedInstance]asyncTask:^(NSDictionary *result){
            for (NSInteger index = 0; index < [self.mSelectedImageArray count]; index++) {
                UIImageWriteToSavedPhotosAlbum([self.mSelectedImageArray objectAtIndex:index], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                self.exportTitle = [NSMutableString stringWithFormat:@"%ld/%ld",(long)index+1,(long)self.mSelectedImageArray.count];
                [[PadManager sharedPadManagerInstance]updateWaitingViewTitle:self.exportTitle];
                [NSThread sleepForTimeInterval:.1];
            }
            [self.mSelectedImageArray removeAllObjects];
        } withInDictionary:nil];
        [[PadManager sharedPadManagerInstance]setPadStatus:PadStatusType_Finish withInDic:nil resultBlock:nil];
    });
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.tabBarController.tabBar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)+49, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.tabBarController.tabBar.frame))];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mToolBar.hidden = YES;
            [self.tabBarController.tabBar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.tabBarController.tabBar.frame))];
        }];
    }];
    
    self.mCanSelected = NO;
    for (UIView *view in [self.mCollectionView subviews]) {
        if ([view isKindOfClass:[CollectionViewCell class]]) {
            CollectionViewCell *cell = (CollectionViewCell *)view;
            if (cell.isSeleceted) {
                [cell updateCellWithImageSelected:NO];
            }
        }
    }
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

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        NSLog(@"保存失败");
    }
    else
    {
        NSLog(@"保存成功");
    }
}

- (void)getSourceImage
{
    [self.mDataSourceArray removeAllObjects];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ImageSource"];
    NSError *error = nil;
    NSArray *fileNameArray = [[NSFileManager defaultManager]subpathsOfDirectoryAtPath:path error:&error];
    for (NSInteger i = 0; i < [fileNameArray count]; i++) {
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",path,[fileNameArray objectAtIndex:i]]];
        [self.mDataSourceArray addObject:image];
    }
    if (self.mCollectionView) {
        [self.mCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

@end
