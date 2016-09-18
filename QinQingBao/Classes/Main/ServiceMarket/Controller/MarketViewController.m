//
//  MarketViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketViewController.h"

#import "CommonMarketCell.h"

#import "MassageModel.h"

#import "MarketDeatilViewController.h"

#import "ChooseShopTableViewController.h"

#import "TypeinfoModel.h"

@interface MarketViewController ()
{
    NSMutableArray *dataProvider;
    NSInteger currentPageIdx;
}

@end

@implementation MarketViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRefresh];
    currentPageIdx = 1;
    dataProvider = [[NSMutableArray alloc] init];
    
    [self getDataProvider];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = HMGlobalBg;
    self.title = self.typeinfoModel.tname_app;
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 上拉刷新
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPageIdx ++ ;
        [self getDataProvider];
    }];
    
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        currentPageIdx = 1;
        [dataProvider removeAllObjects];
        [self getDataProvider];
    }];
}

/**
 *  获取数据源
 */
-(void)getDataProvider
{
    MBProgressHUD *HUD;
    if (currentPageIdx == 1)
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_get_iteminfo parameters:@{@"page" : @"10",
                                                                    @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                                                                    @"tid" : self.typeinfoModel.tid_app
                                                                    }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSArray *arr;
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         //                                         [alertView show];
                                     }
                                     else
                                     {
                                         arr = [MassageModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         [self.tableView reloadData];
                                     }
                                     
                                     [self.tableView removePlace];
                                     if (arr.count == 0 && currentPageIdx == 1)
                                     {
                                         [self.tableView initWithPlaceString:@"暂无数据!"];
                                     }
                                     else if (arr.count == 0 && currentPageIdx > 1)
                                     {
                                         NSLog(@"没有更多的数据了");
                                         currentPageIdx --;
                                         [self.view showNonedataTooltip];
                                     }
                                     [dataProvider addObjectsFromArray:arr];
                                     [self.tableView reloadData];
                                     [self.tableView.footer endRefreshing];
                                     [self.tableView.header endRefreshing];
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     [self.tableView.footer endRefreshing];
                                     [self.tableView.header endRefreshing];
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommonMarketCell *marketcell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonMarketCell"];
    
    if (marketcell == nil)
        marketcell = [CommonMarketCell commonMarketCell];
    
    if (self.tableView.header.state != MJRefreshStateRefreshing)
    {
        marketcell.item = dataProvider[indexPath.section];
    }
    return marketcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MassageModel *model = dataProvider[indexPath.row];
    //如果大于一就显示门店列表
    if (model.orgids.count > 1)
    {
        ChooseShopTableViewController *view = [[ChooseShopTableViewController alloc] init];
        view.iid = model.iid_num;
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        MarketDeatilViewController *view = [[MarketDeatilViewController alloc] init];
        MassageModel *model = dataProvider[indexPath.section];
        view.iid = model.iid;
        [self.navigationController pushViewController:view animated:YES];
    }
}
@end
