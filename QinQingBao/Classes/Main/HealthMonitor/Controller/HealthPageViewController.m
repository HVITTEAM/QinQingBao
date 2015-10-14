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


@interface HealthPageViewController ()

@property (nonatomic, retain) MapViewController *map;

@end

@implementation HealthPageViewController
{
    NSMutableArray *dataProvider;
    
    VideoListViewController *videoList;
}


- (MapViewController *)map
{
    if (_map == nil) {
        self.map = [[MapViewController alloc] init];
    }
    return _map;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableViewSkin];
    
    [self setupRefresh];
    
    [self.tableView headerBeginRefreshing];
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
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在帮你刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在帮你加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self getDataProvider];
}

- (void)footerRereshing
{
    
}

-(void)getDataProvider
{
    dataProvider = [[NSMutableArray alloc] init];
    
    [CommonRemoteHelper RemoteWithUrl:URL_GetMonitor parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                   @"client" : @"ios",
                                                                   @"count" : @"3"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     HealthTotalDatas *result = [HealthTotalDatas objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     if (result.datas.count == 0)
                                     {
                                         [NoticeHelper AlertShow:@"暂无数据" view:self.view];
                                         [self.tableView headerEndRefreshing];
                                         return;
                                     }
                                     dataProvider = result.datas;
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView headerEndRefreshing];
                                 }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sugarCellIdentifier = @"sugarCell";
    static NSString *bloodPressureIdentifier = @"bloodPressureCell";
    static NSString *locationIdentifier = @"locationCell";
    static NSString *videoIdentifier = @"videoCell";
    
    HeartCell *sugarCell = [tableView dequeueReusableCellWithIdentifier:sugarCellIdentifier];
    BloodPressureCell *bloodPressureCell = [tableView dequeueReusableCellWithIdentifier:bloodPressureIdentifier];
    LocationCell *locationCell = [tableView dequeueReusableCellWithIdentifier:locationIdentifier];
    VideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:videoIdentifier];
    
    
    if (indexPath.row == 0)
    {
        if (!sugarCell)
        {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HeartCell" owner:nil options:nil];
            sugarCell = (HeartCell*)[nibs lastObject];
            sugarCell.backgroundColor = [UIColor clearColor];
            //        cell.selectedBackgroundView = [[UIImageView alloc] init];
            sugarCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(dataProvider && dataProvider.count > 0)
        {
            sugarCell.item = dataProvider[0];
        }
        return sugarCell;
    }
    else if(indexPath.row == 1)
    {
        if (!bloodPressureCell)
        {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"BloodPressureCell" owner:nil options:nil];
            bloodPressureCell = (BloodPressureCell*)[nibs lastObject];
            bloodPressureCell.backgroundColor = [UIColor clearColor];
            bloodPressureCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(dataProvider && dataProvider.count > 0)
        {
            bloodPressureCell.item = dataProvider[0];
        }
        return bloodPressureCell;
    }
    else if(indexPath.row == 2)
    {
        if (!locationCell)
        {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:nil options:nil];
            locationCell = (LocationCell*)[nibs lastObject];
            locationCell.backgroundColor = [UIColor clearColor];
            locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(dataProvider && dataProvider.count > 0)
        {
            locationCell.item = dataProvider[0];
        }
        return locationCell;
    }
    else
    {
        if (!videoCell)
        {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"VideoCell" owner:nil options:nil];
            videoCell = (VideoCell*)[nibs lastObject];
            videoCell.backgroundColor = [UIColor clearColor];
            videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return videoCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        [self showPosition];
        return;
    }
    else if (indexPath.row == 3)
    {
        [self showVideo];
        return;
    }
    HealthBloodPressureViewController *bloodPressureVC = [[HealthBloodPressureViewController alloc] initWithNibName:@"HealthBloodPressureViewController" bundle:nil];
    [self.navigationController pushViewController:bloodPressureVC animated:YES];
}

/**
 * 显示地图
 */
- (void)showPosition
{
    [self presentViewController:self.map animated:YES completion:nil];
}

/**
 * 显示视频设备
 */
-(void)showVideo
{
    //    if([EzvizDemoGlobalKit sharedKit].token)
    //    {
    //        [[YSDemoDataModel sharedInstance] saveUserAccessToken:[EzvizDemoGlobalKit sharedKit].token];
    //        [[YSHTTPClient sharedInstance] setClientAccessToken:[EzvizDemoGlobalKit sharedKit].token];
    //    }
    
    if (!videoList)
        videoList = [[VideoListViewController alloc] init];
    [self.navigationController pushViewController:videoList animated:YES];
}


@end
