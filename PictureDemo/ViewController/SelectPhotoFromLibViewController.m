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
#import "Language.h"
#import "TaskHelper.h"
#import "PadManager.h"
#import "UIImage+Custom.h"
#import <CommonCrypto/CommonDigest.h>

@interface SelectPhotoFromLibViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *mCollectionView;
@property (nonatomic, strong)NSMutableArray *mDataSourceArray;
@property (nonatomic, strong)NSMutableArray *mDateArray;
@property (nonatomic, strong)ALAssetsLibrary *mAssetsLibrary;
@property (nonatomic, strong)NSMutableArray *mFullScreenImageSourceArray;
@property (nonatomic, assign)BOOL mCanSelected;
@property (nonatomic, strong)UIView *mToolBar;
@property (nonatomic ,strong)NSMutableArray *mSelectedIndexArray;
@property (nonatomic, copy)NSMutableString *mExportTitle;
@property (nonatomic, strong)UIImage *mCurrectSelectFullImage;
@property (nonatomic, assign)BOOL mFinishReadImage;

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
        self.mSelectedIndexArray = [[NSMutableArray alloc]init];
        self.mCanSelected = NO;
    }
    return self;
}

- (void)dealloc
{
  
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mCollectionView];
    
    [self.view addSubview:self.mToolBar];
    
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
        self.didSetupConstraints = YES;
        
        [self.mCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navBar withOffset:0];
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
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

- (UIView *)mToolBar
{
    if (!_mToolBar)
    {
        
        _mToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 49)];
        _mToolBar.backgroundColor = [UIColor blackColor];
        
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.mCanSelected)
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
    else
    {
        CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.isSeleceted)
        {
            [cell updateCellWithImageSelected:NO];
            if ([self.mSelectedIndexArray containsObject:@(indexPath.row)]) {
                [self.mSelectedIndexArray removeObject:@(indexPath.row)];
            }
        }
        else
        {
            [cell updateCellWithImageSelected:YES];
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
    [UIView animateWithDuration:.3 animations:^{
        [self.mToolBar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-49, CGRectGetWidth(self.view.frame), 49)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancelSelect:(id)sender
{
    self.mCanSelected = NO;
    [UIView animateWithDuration:.3 animations:^{
        [self.mToolBar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 49)];
    } completion:^(BOOL finished) {
        
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
             NSString *dirPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ImageSource"];
            for (NSInteger index = 0; index < [self.mSelectedIndexArray count]; index++)
            {
                self.mExportTitle = [NSMutableString stringWithFormat:@"%ld/%ld",(long)index+1,(long)self.mSelectedIndexArray.count];
                [[PadManager sharedPadManagerInstance]updateWaitingViewTitle:self.mExportTitle];
                
                [self getPhotographImageByGroupName:self.navTitle currectImageIndex:[[self.mSelectedIndexArray objectAtIndex:index] integerValue]];
                if (self.mCurrectSelectFullImage) {
                    NSData *imageData = UIImagePNGRepresentation(self.mCurrectSelectFullImage);
                    NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png",dirPath,[self getMD5HexString:imageData]];
                    BOOL flag = [imageData writeToFile:imagePath atomically:YES];
                    NSLog(@"%d",flag);
                }
               
                [NSThread sleepForTimeInterval:.1];
            }
            [self.mSelectedIndexArray removeAllObjects];
        } withInDictionary:nil];
        [[PadManager sharedPadManagerInstance]setPadStatus:PadStatusType_Finish withInDic:nil resultBlock:nil];
    });

    [UIView animateWithDuration:.3 animations:^{
        [self.mToolBar setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 49)];
    } completion:^(BOOL finished) {
        
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

- (void)getPhotographImageByGroupName:(NSString *)groupName currectImageIndex:(NSInteger)currectImageIndex
{
    self.mCurrectSelectFullImage = nil;
    __block BOOL finishFlag = NO;
    __block BOOL mainThread = [[NSThread currentThread]isMainThread];
    __block NSCondition *conditionLock = [[NSCondition alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            if (group.numberOfAssets > 0 && [[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:groupName]){
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result && index == currectImageIndex) {
                        self.mCurrectSelectFullImage = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                        finishFlag = YES;
                        if (!mainThread) {
                            [conditionLock signal];
                        }
                    }
                }];
            }
        };
        
        NSUInteger groupTypes = ALAssetsGroupAll ;
        [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
            NSLog(@"Group not found!\n");
        }];
    });
    
    [conditionLock lock];
    
    if (!finishFlag) {
        if (mainThread) {
            @autoreleasepool{
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
            }
        }
        else{
            [conditionLock wait];
        }
    }
    [conditionLock unlock];
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

- (NSString *)getMD5HexString:(NSData *)data
{
    const char *originalData = [data bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(originalData,(CC_LONG)[data length],result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
