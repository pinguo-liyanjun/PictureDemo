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
#import "PureLayout.h"
#import "ShearPhotographViewController.h"
#import "StickerPhotographViewController.h"
#import "TaskHelper.h"
#import "PadManager.h"
#import "UIImage+Custom.h"
#import <CommonCrypto/CommonDigest.h>

typedef NS_ENUM(NSInteger, EditType) {
    EditType_ShearPhotograph = 0,
    EditType_StickerPhotograph,
};

@interface EditPhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,ShearPhotographViewControllerDelegate,StickerPhotographViewControllerDelegate>

@property (strong, nonatomic)ALAssetsLibrary *mAssetLibrary;
@property (strong, nonatomic)UICollectionView *mCollectionView;
@property (strong, nonatomic)NSMutableArray *mEditTypeArray;



@property (strong, nonatomic)UIView *mContainerView;

@property (assign, nonatomic)EditType mCurrectEditType;

@end

@implementation EditPhotoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.leftBtn setTitle:[[Language sharedLanguage] stringForKey:@"back"] forState:UIControlStateNormal];
        [self.leftBtn setTitle:[[Language sharedLanguage] stringForKey:@"back"] forState:UIControlStateHighlighted];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[[UIColor yellowColor]colorWithAlphaComponent:.8] forState:UIControlStateHighlighted];
        [self.leftBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.rightBtn setTitle:[[Language sharedLanguage] stringForKey:@"save"] forState:UIControlStateNormal];
        [self.rightBtn setTitle:[[Language sharedLanguage] stringForKey:@"save"] forState:UIControlStateHighlighted];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[[UIColor yellowColor]colorWithAlphaComponent:.8] forState:UIControlStateHighlighted];
        [self.rightBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navTitle = [[Language sharedLanguage]stringForKey:@"edit"];
        self.returnAction = @selector(backAction:);
        self.doneAction = @selector(doneAction:);
        self.mAssetLibrary = [[ALAssetsLibrary alloc]init];
        self.mEditTypeArray = [NSMutableArray arrayWithObjects:@{@"EditType":@(0),@"EditTypeImageNormal":[UIImage imageNamed:@"shearPhotograph_normal"],@"EditTypeImagePress":[UIImage imageNamed:@"shearPhotograph_press"]},@{@"EditType":@(1),@"EditTypeImageNormal":[UIImage imageNamed:@"stickerPhotograph_normal"],@"EditTypeImagePress":[UIImage imageNamed:@"stickerPhotograph_press"]}, nil];
        
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
    
    [self.view setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.7]];
    
    [self.view addSubview:self.imageView];

    [self.view addSubview:self.mCollectionView];
    
    [self updateNavTitle:self.navTitle];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints)
    {
        [self.leftBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.leftBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.leftBtn autoSetDimensionsToSize:CGSizeMake(44, NAVIGATIONBAR_HEIGHT)];
        
        [self.rightBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.rightBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.rightBtn autoSetDimensionsToSize:CGSizeMake(44, NAVIGATIONBAR_HEIGHT)];
        
        [self.imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navBar withOffset:5];
        [self.imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [self.imageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
        [self.imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:100];
       
        
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.mCollectionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.mCollectionView autoSetDimension:ALDimensionHeight toSize:95];
        self.didSetupConstraints = YES;
        
    }
    [super updateViewConstraints];
}


#pragma mark --getter--
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc]initForAutoLayout];
        _imageView.contentMode = UIViewContentModeCenter;
        if (self.currectImage)
        {
            _imageView.image = [UIImage image:self.currectImage ScaleToSize:CGSizeMake(DEVIECE_MAINFRAME.size.width - 10, DEVIECE_MAINFRAME.size.height - 100 - NAVIGATIONBAR_HEIGHT)];
        }
    }
    return _imageView;
}

- (UICollectionView *)mCollectionView
{
    if (!_mCollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setHeaderReferenceSize:CGSizeMake(0, 0)];
        [layout setFooterReferenceSize:CGSizeMake(0, 0)];
        layout.itemSize = CGSizeMake(70, 94);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _mCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _mCollectionView.dataSource = self;
        _mCollectionView.delegate = self;
        _mCollectionView.backgroundColor = [UIColor blackColor];
        _mCollectionView.scrollEnabled = YES;
        [_mCollectionView setScrollsToTop:YES];
        [_mCollectionView registerClass:[EditCollectionViewCell class] forCellWithReuseIdentifier:@"EditCollectionCellIdentifier"];
        [_mCollectionView registerClass:[EditCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EditCollectionHeaderIdentifier"];
    }
    return _mCollectionView;
}



#pragma mark --Collection View Data Source --
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70,94);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 1, 0);
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
    return self.mEditTypeArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID = @"EditCollectionCellIdentifier";
    EditCollectionViewCell *cell = (EditCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    [cell sizeToFit];
    
    UIImage *image  = [[self.mEditTypeArray objectAtIndex:indexPath.row] objectForKey:@"EditTypeImageNormal"];
    cell.imageDic = [self.mEditTypeArray objectAtIndex:indexPath.row];
    cell.imageView.image = image;
    NSInteger editType = [[[self.mEditTypeArray objectAtIndex:indexPath.row] objectForKey:@"EditType"] integerValue];
    if (editType == EditType_ShearPhotograph)
    {
        cell.titleLabel.text = [[Language sharedLanguage]stringForKey:@"shearPhotograph"];
    }
    else if (editType == EditType_StickerPhotograph)
    {
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.titleLabel.text = [[Language sharedLanguage]stringForKey:@"stickerPhotograph"];
    }
    else
    {
        //...
    }
    return cell;
}

#pragma mark -- CollectionView Delegate--

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        ShearPhotographViewController *shearPhotoVC = [[ShearPhotographViewController alloc]initWithNibName:nil bundle:nil];
        shearPhotoVC.origainImage = self.currectImage;
        shearPhotoVC.delegate = self;
        [self presentViewController:shearPhotoVC animated:YES completion:nil];
    }
    else
    {
        StickerPhotographViewController *stickerPhotoVC = [[StickerPhotographViewController alloc]initWithNibName:nil bundle:nil];
        stickerPhotoVC.origainImage = self.currectImage;
        stickerPhotoVC.delegate = self;
        [self presentViewController:stickerPhotoVC animated:YES completion:nil];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark --ShearPhotographViewControllerDelegate--
- (void)getShearedImage:(UIImage *)shearedImage;
{
    self.currectImage = shearedImage;
    self.imageView.image = [UIImage image:self.currectImage ScaleToSize:CGSizeMake(DEVIECE_MAINFRAME.size.width - 10, DEVIECE_MAINFRAME.size.height - 100 - NAVIGATIONBAR_HEIGHT)];
}

#pragma mark --StickerPhotographViewControllerDelegate--
- (void)getStickerPhotographImage:(UIImage *)stickerPhotographImage
{
    self.currectImage = stickerPhotographImage;
    self.imageView.image = [UIImage image:self.currectImage ScaleToSize:CGSizeMake(DEVIECE_MAINFRAME.size.width - 10, DEVIECE_MAINFRAME.size.height - 100 - NAVIGATIONBAR_HEIGHT)];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[PadManager sharedPadManagerInstance]setPadStatus:PadStatusType_Waiting withInDic:nil resultBlock:nil];
        [[TaskHelper sharedInstance]asyncTask:^(NSDictionary *result){
            NSString *dirPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ImageSource"];
            [[PadManager sharedPadManagerInstance]updateWaitingViewTitle:@"保存中。。。"];
            NSData *imageData = UIImagePNGRepresentation(self.currectImage);
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png",dirPath,[self getMD5HexString:imageData]];
            BOOL flag = [imageData writeToFile:imagePath atomically:YES];
            NSLog(@"%d",flag);
            [NSThread sleepForTimeInterval:.1];
        } withInDictionary:nil];
        [[PadManager sharedPadManagerInstance]setPadStatus:PadStatusType_Finish withInDic:nil resultBlock:nil];
    });
}

#pragma mark --help function--

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
