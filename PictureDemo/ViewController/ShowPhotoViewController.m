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

@interface ShowPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong, nonatomic) UICollectionView *collectionView;
@property(strong, nonatomic) ALAssetsLibrary *assetLibrary;

@end

@implementation ShowPhotoViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.leftBtn setFrame:CGRectMake(0, 0, 50, NAVIGATIONBAR_HEIGHT)];
        [self.leftBtn setTitle:@"相册" forState:UIControlStateNormal];
        [self.leftBtn setTitle:@"相册" forState:UIControlStateHighlighted];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[[UIColor yellowColor]colorWithAlphaComponent:.8] forState:UIControlStateHighlighted];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn setFrame:CGRectMake(0, 0, 50, NAVIGATIONBAR_HEIGHT)];
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateHighlighted];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[[UIColor yellowColor]colorWithAlphaComponent:.8] forState:UIControlStateHighlighted];
        
        self.dataSourceArray = [[NSMutableArray alloc]init];
        
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setHeaderReferenceSize:CGSizeMake(DEVIECE_MAINFRAME.size.width, 40)];
    layout.itemSize = CGSizeMake(DEVIECE_MAINFRAME.size.width-10, DEVIECE_MAINFRAME.size.width-10);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.navBar.frame), DEVIECE_MAINFRAME.size.width-10, DEVIECE_MAINFRAME.size.height-CGRectGetHeight(self.navBar.frame)-60) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = NO;
    [self.collectionView setScrollsToTop:YES];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCellIdentifier"];
    [self.collectionView registerClass:[CollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderIdentifier"];

    [self.view insertSubview:self.collectionView belowSubview:self.navBar];
    
    self.assetLibrary = [[ALAssetsLibrary alloc]init];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.collectionView addGestureRecognizer:swipeLeft];

    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.collectionView addGestureRecognizer:swipeRight];
    
    NSString *navTitle = [NSString stringWithFormat:@"%ld/%ld",self.currectIndex+1,[self.dataSourceArray count]];
    [self updateNavTitle:navTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --getter--



#pragma mark --Collection View Data Source --

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
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
    
//    UIImage *image  = [self.dataSourceArray objectAtIndex:indexPath.row];
//    cell.imageView.image = image;
    cell.imageView.image = [self addImage:self.dataSourceArray[0] toImage:self.dataSourceArray[5]];
    
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
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)doneAction:(id)sender
{
    EditPhotoViewController *editVC = [[EditPhotoViewController alloc]initWithNibName:nil bundle:nil];
    editVC.currectImage = [self.dataSourceArray objectAtIndex:self.currectIndex];
    [self presentViewController:editVC animated:YES completion:nil];
}

- (void)swipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.currectIndex == [self.dataSourceArray count] - 1) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }else{
            self.currectIndex += 1;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (self.currectIndex == 0) {
             [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }else{
            self.currectIndex -= 1;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
    
    NSString *navTitle = [NSString stringWithFormat:@"%ld/%ld",self.currectIndex+1,[self.dataSourceArray count]];
    [self updateNavTitle:navTitle];
}

#pragma mark --help function--

- (void)updateNavTitle:(NSString *)navtitle
{
    if (self.navBar) {
        for (UIView *view in [self.navBar subviews]) {
            if ([view isKindOfClass:[UILabel class]] && view.tag == 999) {
                UILabel *titleLabel = (UILabel *)view;
                titleLabel.text = navtitle;
            }
        }
    }
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    
    
    UIGraphicsBeginImageContext(image1.size);
    
//    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rectangle = CGRectMake(0,0,self.collectionView.frame.size.width,self.collectionView.frame.size.height);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rectangle);
    
    UIColor *color = [UIColor redColor];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 0);
    CGContextAddArc(context, 200, 150, 150, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);

   
//    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
