//
//  OtherPhotoLibViewController.m
//  PictureDemo
//
//  Created by C360_liyanjun on 15/7/5.
//  Copyright (c) 2015年 C360_liyanjun. All rights reserved.
//

#import "OtherPhotoLibViewController.h"
#import "TableViewCell.h"
#import "Default.h"
#import "SelectPhotoFromLibViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Language.h"
#import "PureLayout.h"

@interface OtherPhotoLibViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *mTableView;
@property (nonatomic, strong)NSMutableArray *mDataSourceArray;
@property (nonatomic, strong)NSMutableArray *mPhotoLibNameArray;
@property (nonatomic, strong)ALAssetsLibrary *mAssetsLibrary;


@end


@implementation OtherPhotoLibViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.leftBtn = nil;
        self.rightBtn = nil;
        
        self.returnAction = @selector(backAction:);
        self.doneAction = nil;
        
        self.navTitle = [[Language sharedLanguage]stringForKey:@"otherPhotoLibrary"];
        
        self.mDataSourceArray = [[NSMutableArray alloc]init];
        self.mPhotoLibNameArray = [[NSMutableArray alloc]init];
        self.mAssetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return self;
}


- (void)dealloc
{
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getPhotoLibInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.mTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints)
    {
         self.didSetupConstraints = YES;
        [self.mTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navBar withOffset:5];
        [self.mTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [self.mTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
        [self.mTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    
    }
    
    [super updateViewConstraints];
}

#pragma mark --getter--
- (UITableView *)mTableView
{
    if (!_mTableView)
    {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_mTableView setScrollEnabled:YES];
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.backgroundView = nil;
        _mTableView.delegate = self;
        _mTableView.dataSource = self;

    }
    return _mTableView;
}


#pragma mark --TableViewDataSource function--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mDataSourceArray count];
}

#pragma mark --TableView Delegate funtion--
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reusedIdentifier = [NSString stringWithFormat:@"CellReusedIdentifier"];
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
    if (!cell)
    {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ALAssetsGroup *group = (ALAssetsGroup *)[self.mDataSourceArray objectAtIndex:indexPath.row];
    cell.posterImageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.titleLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.photoCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[group numberOfAssets]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SelectPhotoFromLibViewController *selectPhotoVC = [[SelectPhotoFromLibViewController alloc]initWithNibName:nil bundle:nil];
    ALAssetsGroup *group = (ALAssetsGroup *)[self.mDataSourceArray objectAtIndex:indexPath.row];
    selectPhotoVC.navTitle = [group valueForProperty:ALAssetsGroupPropertyName];
    if (self.navigationController)
    {
        [self.navigationController pushViewController:selectPhotoVC animated:YES];
    }
    else
    {
        [self presentViewController:selectPhotoVC animated:YES completion:nil];
    }
}

#pragma mark --action funtion--
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

#pragma mark --help function--
- (void)getPhotoLibInfo
{
    [self.mDataSourceArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.mPhotoLibNameArray removeAllObjects];
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            if ([group numberOfAssets] > 0)
            {
                [self.mDataSourceArray addObject:group];
            }
            else
            {
                [self.mTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        };
        
        NSUInteger groupTypes = ALAssetsGroupAll ;
        
        [self.mAssetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
            NSLog(@"Group not found!\n");
        }];

    });
}

@end
