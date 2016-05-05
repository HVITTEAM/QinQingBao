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

#import "DeviceInfoModel.h"

#import "HealthModel.h"
@interface HealthPageViewController ()<UIScrollViewDelegate>

@end

@implementation HealthPageViewController
{
    HealthModel *dataModel;
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
    //没有设备 结束刷新
    if (self.familyVO.device.count == 0)
    {
        [self.tableView.header endRefreshing];
        return;
    }
    
    NSString *str = @"";
    for (int i = 0 ; i < self.familyVO.device.count ;i++)
    {
        DeviceInfoModel *item = self.familyVO.device[i];
        str = [NSString stringWithFormat:@"%@{'imei':'%@'},",str,item.device_code];
    }
    NSString *strData = [str substringWithRange:NSMakeRange(0, str.length - 1)];
    
    [CommonRemoteHelper RemoteWithUrl:URL_getMonitor_bycode parameters: @{@"datas" : [NSString stringWithFormat:@"[%@]",strData]}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     NSArray *arr = [dict objectForKey:@"datas"];
                                     [self.tableView.header endRefreshing];
                                     if (arr.count == 0)
                                         return ;
                                     dataModel = [HealthModel objectWithKeyValues:arr[0]];
                                     [self.tableView reloadData];
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
            
            sugarCell.item = dataModel;
            
            cell = sugarCell;
        }
            break;
        case 3:
        {
            BloodPressureCell *bloodPressureCell = [tableView dequeueReusableCellWithIdentifier:@"MTBloodPressureCell"];
            
            if(bloodPressureCell == nil)
                bloodPressureCell = [BloodPressureCell bloodPressureCell];
            
            bloodPressureCell.item = dataModel;
            
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
            
            heartCell.item = dataModel;
            
            cell = heartCell;
        }
            break;
        case 1:
        {
            LocationCell *locationCell = [tableView dequeueReusableCellWithIdentifier:@"MTLocationCell"];
            
            if(locationCell == nil)
                locationCell = [LocationCell locationCell];
            
            locationCell.item = dataModel;
            cell = locationCell;
        }
            
            break;
        case 5:
        {
            HeartImageCell *heartImageCell = [tableView dequeueReusableCellWithIdentifier:@"MTHeartImageCell"];
            
            if(heartImageCell == nil)
                heartImageCell = [HeartImageCell heartImageCell];
            
            heartImageCell.item = dataModel;
            
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
            bloodPressureVC.title = [NSString stringWithFormat:@"%@的血糖统计数据",self.familyVO.rel_name];
            bloodPressureVC.type = ChartTypeSugar;
            vctype = @"6";
        }
            break;
        case 3:
        {
            bloodPressureVC.title = [NSString stringWithFormat:@"%@的血压统计数据",self.familyVO.rel_name];
            vctype = @"3";
            bloodPressureVC.type = ChartTypeBlood;
        }
            break;
        case 5:
        {
            if (dataModel)
            {
                if (dataModel.ect_img.length > 0 && dataModel.ect_time.length > 0)
                {
                    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,dataModel.ect_img]];
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
            if (dataModel)
            {
                bloodPressureVC.title = [NSString stringWithFormat:@"%@的心率统计数据",self.familyVO.ud_name];
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
    
    NSString *str = @"";
    for (int i = 0 ; i < self.familyVO.device.count ;i++)
    {
        DeviceInfoModel *item = self.familyVO.device[i];
        str = [NSString stringWithFormat:@"%@{'imei':'%@'},",str,item.device_code];
    }
    NSString *strData = [str substringWithRange:NSMakeRange(0, str.length - 1)];
    [CommonRemoteHelper RemoteWithUrl:URL_monitor_one_bycode parameters: @{@"datas" :[NSString stringWithFormat:@"[%@]",strData],
                                                                           @"page" : @"1",
                                                                           @"rows" : @"50",
                                                                           @"type" : vctype}
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
    if (!dataModel.longitude)
        return [NoticeHelper AlertShow:@"暂无数据" view:self.view];
    map.address = dataModel.address;
    map.latitude = dataModel.latitude;
    map.longitude = dataModel.longitude;
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
