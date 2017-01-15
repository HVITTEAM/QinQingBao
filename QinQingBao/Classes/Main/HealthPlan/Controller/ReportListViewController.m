//
//  ReportListViewController.m
//  QinQingBao
//
//  Created by shi on 2016/10/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ReportListViewController.h"
#import "ArchivesPersonCell.h"
#import "ReportDetailViewController.h"
#import "ReportInterventionModel.h"

#import "PersonReportListViewController.h"

@interface ReportListViewController ()

@property (strong, nonatomic) NSMutableArray *dataProvider;

@property (assign, nonatomic) BOOL isfirst;   //是否第一次加载网络数据

@end

@implementation ReportListViewController

- (instancetype)init
{
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"检测报告";
    self.isfirst = YES;
    
    self.tableView.backgroundColor = [UIColor colorWithRGB:@"f5f5f5"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getReportListData];
    }];
    [self getReportListData];
}

- (NSMutableArray *)dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[NSMutableArray alloc] init];
    }
    return _dataProvider;
}

#pragma mark - UITableViewDataSource

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
    cell.subTitleLb.text = item.wp_read_time;
    cell.badgeIcon.hidden = item.wp_read != nil && item.wp_read.count >0? NO : YES;
    NSString *str = [item.basics objectForKey:@"avatar"];
    
    if (![str isKindOfClass:[NSNull class]] && str && str.length != 0)
    {
        NSURL *iconUrl = [NSURL URLWithString:[item.basics objectForKey:@"avatar"]];
        [cell.imgView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
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
    PersonReportListViewController *VC =[[PersonReportListViewController alloc] init];
    ReportInterventionModel *item = self.dataProvider[indexPath.section];
    VC.fmno = item.fmno;
    VC.wp_read = item.wp_read;
    VC.title = [item.basics objectForKey:@"truename"];
    [self.navigationController pushViewController:VC animated:YES];
    
}

/**
 * 加载检测报告
 */
- (void)getReportListData
{
    [self.dataProvider removeAllObjects];
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
        [self.tableView.header endRefreshing];
        
        if ([dict[@"code"] integerValue] == 17001 && self.dataProvider.count > 0)
        {
            return [self.tableView showNonedataTooltip];
        }
        else  if ([dict[@"code"] integerValue] != 0)
        {
            return [self.tableView initWithPlaceString:@"您当前没有检测报告" imgPath:@"placeholder-1"];
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
        [NoticeHelper AlertShow:MTServiceError view:nil];
    }];
}

@end
