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

#import "QuestionResultController3.h"

#import "ResultModel.h"

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

- (void)loadView
{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.p = 1;
    self.page = 10;
    
    self.navigationItem.title = @"我的评估";
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataProvider = [[NSMutableArray alloc] init];
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.p = 1;
        [self.dataProvider removeAllObjects];
        [self getDatasFormServices];
    }];
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
    if (self.dataProvider && self.dataProvider.count >0) {
        cell.item = self.dataProvider[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 157;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportListModel *reportListModel = self.dataProvider[indexPath.row];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDictionary *params = @{ @"client":@"ios",
                              @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                              @"rid":reportListModel.r_id
                              };
    [CommonRemoteHelper RemoteWithUrl:URL_Get_report_detail parameters:params
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         
                                     }
                                     else
                                     {
                                         ResultModel *model = [ResultModel objectWithKeyValues:dict1];
                                         QuestionResultController3 *questionResultVC = [[QuestionResultController3 alloc] init];
                                         questionResultVC.r_ids = @[model.r_id];
                                         questionResultVC.r_dangercoefficient = model.r_dangercoefficient;
                                         questionResultVC.hmd_advise = model.r_result.hmd_advise;
                                         questionResultVC.truename = reportListModel.truename;
                                         [self.navigationController pushViewController:questionResultVC animated:YES];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 }];
}

#pragma mark - 网络相关
/**
 *  获取数据
 */
-(void)getDatasFormServices
{
    if (![SharedAppUtil defaultCommonUtil].userVO)
        return [self.tableView initWithPlaceString:PlaceholderStr_Login imgPath:@"placeholder-1"];
    
    
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
        [self.tableView.header endRefreshing];

        if([dict[@"code"] integerValue] == 17001 && self.dataProvider.count == 0){
            [self.view initWithPlaceString:@"暂无数据" imgPath:nil];
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
