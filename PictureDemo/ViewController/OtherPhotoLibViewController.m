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

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataSourceArray;
@property(nonatomic, strong)NSMutableArray *photoLibNameArray;
@property(nonatomic, strong)ALAssetsLibrary *assetsLibrary;


@end


@implementation OtherPhotoLibViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.leftBtn = nil;
        self.rightBtn = nil;
        
        self.returnAction = @selector(backAction:);
        self.doneAction = nil;
        
        self.navTitle = [[Language sharedLanguage]stringForKey:@"otherPhotoLibrary"];
        
        self.dataSourceArray = [[NSMutableArray alloc]init];
        self.photoLibNameArray = [[NSMutableArray alloc]init];
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
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
    
   
    [self.view addSubview:self.tableView];
    
    [self getPhotoLibInfo];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navBar withOffset:5];
        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

#pragma mark --getter--
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tableView setScrollEnabled:YES];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.delegate = self;
        _tableView.dataSource = self;

    }
    return _tableView;
}


#pragma mark --TableViewDataSource function--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArray count];
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
    if (!cell) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIdentifier];
    }
    
    ALAssetsGroup *group = (ALAssetsGroup *)[self.dataSourceArray objectAtIndex:indexPath.row];
    cell.posterImageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.titleLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.photoCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[group numberOfAssets]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SelectPhotoFromLibViewController *selectPhotoVC = [[SelectPhotoFromLibViewController alloc]initWithNibName:nil bundle:nil];
    ALAssetsGroup *group = (ALAssetsGroup *)[self.dataSourceArray objectAtIndex:indexPath.row];
    selectPhotoVC.navTitle = [group valueForProperty:ALAssetsGroupPropertyName];
    if (self.navigationController) {
        [self.navigationController pushViewController:selectPhotoVC animated:YES];
    }
    else{
        [self presentViewController:selectPhotoVC animated:YES completion:nil];
    }
}

#pragma mark --action funtion--
- (void)backAction:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark --help function--
- (void)getPhotoLibInfo{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.photoLibNameArray removeAllObjects];
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            if ([group numberOfAssets] > 0)
            {
                [self.dataSourceArray addObject:group];
            }
            else
            {
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        };
        
        NSUInteger groupTypes = ALAssetsGroupAll ;
        
        [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:^(NSError *error) {
            NSLog(@"Group not found!\n");
        }];

    });
}

@end
