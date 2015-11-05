//
//  QueryAllEvaluationController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/9.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "QueryAllEvaluationController.h"
#import "ServiceTypeDatas.h"
#import "EvaluationItemCell.h"
#import "EvaluationHeadView.h"


@interface QueryAllEvaluationController ()
{
    NSMutableArray *dataProvider;
}

@end

@implementation QueryAllEvaluationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRefresh];
    
    [self getDataProvider];
}

-(void)initTableviewSkin
{
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"EvaluationHeadView" owner:nil options:nil];
    self.tableView.tableHeaderView = [nibs lastObject];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableHeaderView.backgroundColor = [UIColor redColor];
    self.title = @"所有评价";
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
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
    //    [self getDataProvider];
}

- (void)footerRereshing
{
    [self getDataProvider];
}

-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Typelist parameters: @{@"tid" : @1}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     ServiceTypeDatas *result = [ServiceTypeDatas objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     if (result.datas.count == 0)
                                     {
                                         [NoticeHelper AlertShow:@"暂无数据" view:self.view];
                                         return;
                                     }
                                     dataProvider = result.datas;
                                     [self.tableView reloadData];
                                     [HUD removeFromSuperview];
                                     [self initTableviewSkin];
                                     [self.tableView footerEndRefreshing];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"EvaluationHeadView" owner:nil options:nil];
////    self.tableView.tableHeaderView = [nibs lastObject];
//
//    return [nibs lastObject];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataProvider.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *listViewCellstr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listViewCellstr];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"EvaluationItemCell" owner:self options:nil];
        cell = [nib lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

@end
