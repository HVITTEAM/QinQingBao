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
#import "HeartImageCell.h"


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
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataProvider];
    }];
}

//获取所有的数据
-(void)getDataProvider
{
    dataProvider = [[NSMutableArray alloc] init];
    if (self.familyVO.member_id == nil)
    {
        [self.tableView.header endRefreshing];
        return [NoticeHelper AlertShow:@"数据异常!" view:self.view];
    }
    [CommonRemoteHelper RemoteWithUrl:URL_GetMonitor parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                   @"client" : @"ios",
                                                                   @"count" : @"1",
                                                                   @"member_id" : self.familyVO.member_id}
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
    return 6;
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
        case 4:
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
        case 3:
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
        case 0:
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
        case 1:
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
        case 5:
        {
            HeartImageCell *heartImageCell = [tableView dequeueReusableCellWithIdentifier:@"MTHeartImageCell"];
            
            if(heartImageCell == nil)
                heartImageCell = [HeartImageCell heartImageCell];
            
            if(dataProvider && dataProvider.count > 0)
            {
                heartImageCell.item = dataProvider[0];
            }
            cell = heartImageCell;
        }
            break;
            
        default:
            break;
    }
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_background.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthBloodPressureViewController *bloodPressureVC = [[HealthBloodPressureViewController alloc] initWithNibName:@"HealthBloodPressureViewController" bundle:nil];
    //点击的分类1心率 2位置 3血压 4心电图 5体检 6血糖 7血痒 8看护宝
    NSString *vctype;
    
    switch (indexPath.section)
    {
        case 4:
        {
            bloodPressureVC.title = [NSString stringWithFormat:@"%@的血糖统计数据",self.familyVO.relation];
            bloodPressureVC.type = ChartTypeSugar;
            vctype = @"6";
            return  [NoticeHelper AlertShow:@"此功能暂尚未启用,敬请期待" view:self.view];
        }
            break;
        case 3:
        {
            bloodPressureVC.title = [NSString stringWithFormat:@"%@的血压统计数据",self.familyVO.relation];
            vctype = @"3";
            bloodPressureVC.type = ChartTypeBlood;
        }
            break;
        case 5:
        {
            if (dataProvider.count > 0)
            {
                HealthDataModel *item = dataProvider[0];
                if (item.ect_img.length > 0 && item.ect_time.length > 0)
                {
                    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,item.ect_img]];
                    SWYPhotoBrowserViewController *photoBrowser = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImageURls:@[iconUrl] currentIndex:0 placeholderImageNmae:@"placeholderImage"];
                    return [self.navigationController presentViewController:photoBrowser animated:YES completion:^{
                        [HUD removeFromSuperview];
                    }];
                }
                return [NoticeHelper AlertShow:@"暂无数据!" view:self.view];
            }
            else
            {
                return [NoticeHelper AlertShow:@"暂无数据!" view:self.view];
            }
        }
            break;
        case 2:
        {
            [self showVideo];
            return;
        }
            break;
        case 0:
        {
            if (dataProvider.count > 0)
            {
                bloodPressureVC.title = [NSString stringWithFormat:@"%@的心率统计数据",self.familyVO.relation];
                bloodPressureVC.type = ChartTypeHeart;
                vctype = @"1";
            }
            else
            {
                return [NoticeHelper AlertShow:@"暂无数据!" view:self.view];
            }
        }
            break;
        case 1:
        {
            [self showPosition];
            return;
        }
            break;
        default:
            break;
    }
    
    [CommonRemoteHelper RemoteWithUrl:URL_GetMonitor_one parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                       @"client" : @"ios",
                                                                       @"count" : @"50",
                                                                       @"member_id" : self.familyVO.member_id,
                                                                       @"type" : vctype,}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     HealthTotalDatas *result = [HealthTotalDatas objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     if (result.datas.count == 0)
                                     {
                                         [NoticeHelper AlertShow:@"暂无数据" view:self.view];
                                     }
                                     bloodPressureVC.dataProvider = result.datas;
                                     
                                     [self.navigationController pushViewController:bloodPressureVC animated:YES];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                 }];
    
}

/**
 * 显示地图
 */
- (void)showPosition
{
    MapViewController *map = [[MapViewController alloc] init];
    if (dataProvider.count == 0)
        return [NoticeHelper AlertShow:@"暂无数据" view:self.view];
    HealthDataModel *item = (HealthDataModel *)dataProvider[0];
    map.address = item.address;
    map.latitude = item.latitude;
    map.longitude = item.longitude;
    [self presentViewController:map animated:YES completion:nil];
}

/**
 * 显示视频设备
 */
-(void)showVideo
{
    VideoListViewController *videoList = [[VideoListViewController alloc] init];
    videoList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoList animated:YES];
}


@end
