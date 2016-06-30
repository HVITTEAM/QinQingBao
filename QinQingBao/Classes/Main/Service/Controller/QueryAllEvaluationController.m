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
#import "EvaluationTotal.h"


@interface QueryAllEvaluationController ()
{
    NSMutableArray *dataProvider;
    NSInteger currentPageIdx;

}

@end

@implementation QueryAllEvaluationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
    
    [self setupRefresh];
    
    [self getDataProvider];
}

-(void)initTableviewSkin
{
    self.title = @"所有评价";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = HMGlobalBg;
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    currentPageIdx = 1;
    dataProvider = [[NSMutableArray alloc] init];
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dataProvider = [[NSMutableArray alloc] init];
        [self headerRereshing];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPageIdx ++ ;
        [self footerRereshing];
    }];

}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self getDataProvider];
}

- (void)footerRereshing
{
    [self getDataProvider];
}

-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_dis_cont parameters: @{@"iid" : self.itemId,
                                                                     @"page" : @10,
                                                                     @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     EvaluationTotal *result = [EvaluationTotal objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     
                                     if (result.datas.count == 0 && currentPageIdx == 1)
                                     {
                                         [self.tableView initWithPlaceString:@"暂无数据!"];
                                     }
                                     else if (result.datas.count == 0 && currentPageIdx > 1)
                                     {
                                         [self.tableView removePlace];
                                         [self.view showNonedataTooltip];
                                         currentPageIdx --;
                                     }
                                     else
                                     {
                                         [self.tableView removePlace];
                                     }
                                     [dataProvider addObjectsFromArray:[result.datas copy]];
                                     [self.tableView reloadData];
                                     [self.tableView.header endRefreshing];
                                     [self.tableView.footer endRefreshing];

                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataProvider.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluationItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTEvaluationItemCell"];
    
    if (cell == nil)
        cell = [EvaluationItemCell evaluationItemCell];
    
    [cell setitemWithData:dataProvider[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

@end
