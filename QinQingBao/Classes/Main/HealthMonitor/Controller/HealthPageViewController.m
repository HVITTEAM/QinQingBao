//
//  HealthPageViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/13.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  个人健康监测信息

#import "HealthPageViewController.h"
#import "HealthBloodPressureViewController.h"
#import "HealthTotalDatas.h"
#import "MapViewController.h"
#import "VideoListViewController.h"
#import "VideoCell.h"


@interface HealthPageViewController ()<UIScrollViewDelegate>

@end

@implementation HealthPageViewController
{
    NSMutableArray *dataProvider;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableViewSkin];
    
    [self setupRefresh];
    
    [self.tableView.header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)initTableViewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.contentInset = UIEdgeInsetsMake(66, 0, 0, 0);
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self headerRereshing];
        });
    }];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self getDataProvider];
}

- (void)footerRereshing
{
    [self getDataProvider];
    
}

-(void)getDataProvider
{
    dataProvider = [[NSMutableArray alloc] init];
    
    [CommonRemoteHelper RemoteWithUrl:URL_GetMonitor parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                   @"client" : @"ios",
                                                                   @"count" : @"5",
                                                                   @"oldid" : self.familyVO.oid}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     HealthTotalDatas *result = [HealthTotalDatas objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     if (result.datas.count == 0)
                                     {
                                         [NoticeHelper AlertShow:@"暂无数据" view:self.view];
                                     }
                                     dataProvider = result.datas;
                                     [self.tableView reloadData];
                                     [self.tableView.header endRefreshing];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                 }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if(arc4random_uniform(100)>90)
    //        exit(0);
    //    [NSThread sleepForTimeInterval:0.2f];
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            HeartCell *sugarCell = [tableView dequeueReusableCellWithIdentifier:@"MTSugarCell"];
            
            if(sugarCell == nil)
                sugarCell = [HeartCell heartCell];
            
            if(dataProvider && dataProvider.count > 0)
            {
                sugarCell.item = dataProvider[0];
            }
            
            cell = sugarCell;
        }
            break;
        case 1:
        {
            BloodPressureCell *bloodPressureCell = [tableView dequeueReusableCellWithIdentifier:@"MTBloodPressureCell"];
            
            if(bloodPressureCell == nil)
                bloodPressureCell = [BloodPressureCell bloodPressureCell];
            
            if(dataProvider && dataProvider.count > 0)
            {
                bloodPressureCell.item = dataProvider[0];
            }
            
            cell = bloodPressureCell;
            
        }
            break;
        case 2:
        {
            VideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"MTVideoCell"];
            
            if (videoCell == nil)
                videoCell = [VideoCell videoCell];
            
            cell = videoCell;
        }
            break;
        case 3:
        {
            HeartbeatCell *heartCell = [tableView dequeueReusableCellWithIdentifier:@"MTHeartBeatCell"];
            
            if(heartCell == nil)
                heartCell = [HeartbeatCell heartbeatCell];
            
            if(dataProvider && dataProvider.count > 0)
            {
                heartCell.item = dataProvider[0];
            }
            
            cell = heartCell;
        }
            break;
        case 4:
        {
            LocationCell *locationCell = [tableView dequeueReusableCellWithIdentifier:@"MTLocationCell"];
            
            if(locationCell == nil)
                locationCell = [LocationCell locationCell];
            
            if(dataProvider && dataProvider.count > 0)
            {
                locationCell.item = dataProvider[0];
            }
            
            cell = locationCell;
        }
            break;
        default:
            break;
    }
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthBloodPressureViewController *bloodPressureVC = [[HealthBloodPressureViewController alloc] initWithNibName:@"HealthBloodPressureViewController" bundle:nil];
    
    switch (indexPath.section)
    {
        case 0:
        {
            bloodPressureVC.title = [NSString stringWithFormat:@"%@的血糖统计数据",self.familyVO.oldname];
            bloodPressureVC.type = ChartTypeSugar;
        }
            break;
        case 1:
        {
            bloodPressureVC.title = [NSString stringWithFormat:@"%@的血压统计数据",self.familyVO.oldname];
            bloodPressureVC.type = ChartTypeBlood;
        }
            break;
        case 2:
        {
            [self showVideo];
            return;
        }
            break;
        case 3:
        {
            bloodPressureVC.title = [NSString stringWithFormat:@"%@的心率统计数据",self.familyVO.oldname];
            bloodPressureVC.type = ChartTypeHeart;
        }
            break;
        case 4:
        {
            [self showPosition];
            return;
        }
            break;
        default:
            break;
    }
    bloodPressureVC.dataProvider = dataProvider;
    [self.navigationController pushViewController:bloodPressureVC animated:YES];
}

/**
 * 显示地图
 */
- (void)showPosition
{
    MapViewController *map = [[MapViewController alloc] init];
    map.item = dataProvider[0];
    [self presentViewController:map animated:YES completion:nil];
}

/**
 * 显示视频设备
 */
-(void)showVideo
{
    VideoListViewController *videoList = [[VideoListViewController alloc] init];
    [self.navigationController pushViewController:videoList animated:YES];
}


@end
