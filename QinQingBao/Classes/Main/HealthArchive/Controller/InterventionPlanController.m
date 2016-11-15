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

@interface InterventionPlanController ()

@property (strong, nonatomic) NSMutableArray *dataProvider;

@property (assign, nonatomic) NSInteger p;   //分页号

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
    
    self.p = 1;
    self.isfirst = YES;
    
    self.navigationItem.title = @"干预方案";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRGB:@"f5f5f5"];
    self.tableView.footer= [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    [self.tableView initWithPlaceString:@"暂无相关数据" imgPath:@"placeholder-1"];
    
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
    cell.titleLb.text = @"王大爷";
    cell.subTitleLb.text = @"2016-11-16";
    cell.badgeIcon.hidden = NO;
    
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
//    InterveneController *interveneVC = [[InterveneController alloc] init];
//    view.wid = model.wid;
//    [self.navigationController pushViewController:interveneVC animated:YES];
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
    
    NSMutableDictionary *params = nil;
    MBProgressHUD *hud = nil;
    if (self.isfirst) {
        self.isfirst = NO;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [CommonRemoteHelper RemoteWithUrl:@"www.baidu.com" parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [hud removeFromSuperview];
        [self.tableView.footer endRefreshing];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [self.tableView.footer endRefreshing];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}


@end
