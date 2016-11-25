//
//  HealthPlanController.m
//  QinQingBao
//
//  Created by shi on 2016/11/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "InterventionPlanController.h"
#import "ArchivesPersonCell.h"
#import "InterveneController.h"
#import "InterveneModel.h"

#import "ReportInterventionModel.h"

@interface InterventionPlanController ()

@property (strong, nonatomic) NSMutableArray *dataProvider;

@property (assign, nonatomic) BOOL isfirst;   //是否第一次加载网络数据

@end

@implementation InterventionPlanController

- (instancetype)init
{
    self = [self initWithStyle:UITableViewStylePlain];
    self.hidesBottomBarWhenPushed = YES;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isfirst = YES;
    
    self.navigationItem.title = @"干预方案";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRGB:@"f5f5f5"];
    self.tableView.footer= [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    [self.tableView initWithPlaceString:@"暂无相关数据" imgPath:@"placeholder-1"];
    
    [self getInterventionPlanList];
}

- (NSArray *)dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[NSMutableArray alloc] init];
    }
    
    return _dataProvider;
}

#pragma mark - 协议方法
#pragma mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArchivesPersonCell *cell = [ArchivesPersonCell createCellWithTableView:tableView];
    ReportInterventionModel *item = self.dataProvider[indexPath.section];
    cell.titleLb.text = [item.basics objectForKey:@"truename"];
    cell.subTitleLb.text = item.wi_read_time;
    NSURL *iconUrl = [NSURL URLWithString:[item.basics objectForKey:@"avatar"]];
    [cell.imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    cell.badgeIcon.hidden = item.wi_read == nil ? YES : NO;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InterveneController *interveneVC = [[InterveneController alloc] init];
    ReportInterventionModel *item = self.dataProvider[indexPath.section];
    interveneVC.fmno = item.fmno;
    [self.navigationController pushViewController:interveneVC animated:YES];
}

#pragma mark - 服务器相关
- (void)loadMoreDatas
{
    [self getInterventionPlanList];
}

/**
 *  加载干预方案
 */
- (void)getInterventionPlanList
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates])
        return;
    
    NSMutableDictionary *params = [@{@"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"client":@"ios"
                                     }mutableCopy];
    
    if (self.isfirst) {
        self.isfirst = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_work_read parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView.footer endRefreshing];
        
        if ([dict[@"code"] integerValue] == 17001 && self.dataProvider.count > 0)
        {
            return [self.tableView showNonedataTooltip];
        }
        else  if ([dict[@"code"] integerValue] != 0)
        {
            return [self.tableView initWithPlaceString:@"您当前没有干预方案" imgPath:@"placeholder-1"];
        }
        
        NSArray *datas = [ReportInterventionModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        if (datas.count > 0)
        {
            [self.dataProvider addObjectsFromArray:datas];
            //设置数据
            [self.tableView reloadData];
        }
        
        if (self.dataProvider.count > 0)
        {
            [self.tableView removePlace];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView.footer endRefreshing];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}


@end
