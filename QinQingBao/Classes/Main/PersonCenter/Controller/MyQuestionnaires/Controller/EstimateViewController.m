//
//  EstimateViewController.m
//  QinQingBao
//
//  Created by shi on 16/7/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EstimateViewController.h"
#import "EstimateListCell.h"
#import "ReportListModel.h"
#import "QuestionResultController.h"
#import "QuestionResultController2.h"

@interface EstimateViewController ()

@property(strong,nonatomic)NSMutableArray *dataProvider;

@property(assign,nonatomic)NSUInteger p;

@property(assign,nonatomic)NSUInteger page;

@end

@implementation EstimateViewController

-(instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.p = 1;
    self.page = 10;
    
    self.navigationItem.title = @"我的评估";
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataProvider = [[NSMutableArray alloc] init];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    
    [self getDatasFormServices];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataProvider.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EstimateListCell *cell = [EstimateListCell createCellWithTableView:tableView];
    cell.item = self.dataProvider[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportListModel *reportListModel = self.dataProvider[indexPath.row];
    
    //如果reid = 1 就是疾病风险
    if ([reportListModel.r_eid isEqualToString:@"1"])
    {
        QuestionResultController *vc = [[QuestionResultController alloc] init];
        vc.reportListModel = reportListModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        QuestionResultController2 *vc = [[QuestionResultController2 alloc] init];
        vc.reportListModel = reportListModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 网络相关
/**
 *  获取数据
 */
-(void)getDatasFormServices
{
    MBProgressHUD *hud = nil;
    if (self.p == 1) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    NSDictionary *params = @{
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                             @"p":@(self.p),
                             @"page":@(self.page)
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_get_report_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.footer endRefreshing];
        
        if([dict[@"code"] integerValue] == 17001 && self.dataProvider.count == 0){
            [self.view initWithPlaceString:@"暂无数据"];
            return;
        }
        
        if([dict[@"code"] integerValue] == 17001){
            [self.view showNonedataTooltip];
            return;
        }
        
        if([dict[@"code"] integerValue] != 0){
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            return;
        }
        
        self.p++;
        
        NSMutableArray *datas = [[ReportListModel objectArrayWithKeyValuesArray:dict[@"datas"]] mutableCopy];
        [self.dataProvider addObjectsFromArray:[datas copy]];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.footer endRefreshing];
        [NoticeHelper AlertShow:@"请求出错" view:nil];
    }];
}

-(void)loadMoreDatas
{
    [self getDatasFormServices];
}

@end
