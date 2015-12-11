//
//  QCListViewController.m
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//

#import "QCListViewController.h"
#import "OrderModel.h"
#import "OrderTotals.h"
#import "OrderDetailController.h"

@interface QCListViewController ()
{
    NSMutableArray *dataProvider;
    NSInteger currentPageIdx;
}

@end

@implementation QCListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
    
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    currentPageIdx = 1;
    dataProvider = [[NSMutableArray alloc] init];
    [self dataRereshing];
}


/** 屏蔽tableView的样式 */
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 10;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, -25, 0);
 
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
        [self dataRereshing];
    }];
}

#pragma mark 开始进入刷新状态
- (void)dataRereshing
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    if ([self.title isEqualToString:@"全部订单"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"oldid" : [SharedAppUtil defaultCommonUtil].userVO.old_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"page" : @"10",
                  @"get_type" : @"0"};
    }
    else if ([self.title isEqualToString:@"待付款"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"oldid" : [SharedAppUtil defaultCommonUtil].userVO.old_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"pay_staus" : @"0",
                  @"page" : @"10",
                  @"get_type" : @"0"};
    }
    else if ([self.title isEqualToString:@"受理中"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"oldid" : [SharedAppUtil defaultCommonUtil].userVO.old_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"status" : @"2,5,8,12,15,22,25",
                  @"page" : @"10",
                  @"get_type" : @"1"};
    }
    else if ([self.title isEqualToString:@"待评价"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"oldid" : [SharedAppUtil defaultCommonUtil].userVO.old_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"status" : @"32",
                  @"page" : @"10",
                  @"get_type" : @"1"};
    }
    else if ([self.title isEqualToString:@"取消/售后"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"oldid" : [SharedAppUtil defaultCommonUtil].userVO.old_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"status" : @"[50,59]",
                  @"page" : @"10",
                  @"get_type" : @"2"};
    }
    [CommonRemoteHelper RemoteWithUrl:URL_Get_workinfo_bystatus parameters: dict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     OrderTotals *result = [OrderTotals objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     if (result.datas.count == 0 && currentPageIdx == 1)
                                     {
                                         [self.tableView initWithPlaceString:@"暂无数据"];
                                     }
                                     else if (result.datas.count == 0 && currentPageIdx > 1)
                                     {
//                                         [NoticeHelper AlertShow:@"没有更多的数据了" view:self.view];
                                         NSLog(@"没有更多的数据了");
                                         currentPageIdx --;
                                         self.noneResultHandler();
                                     }
                                     [dataProvider addObjectsFromArray:[result.datas copy]];
                                     [self.tableView reloadData];
                                     [self.tableView.footer endRefreshing];
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.footer endRefreshing];
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark - 表格视图数据源代理方法

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    if (cell == nil)
        cell = [CommonOrderCell commonOrderCell];
    
    cell.deleteClick = ^(UIButton *btn){
        [self deleteOrderClickHandler:indexPath btn:btn];
    };
    
    [cell setItem:dataProvider[indexPath.section]];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailController *detailForm = [[OrderDetailController alloc] init];
    detailForm.orderItem = dataProvider[indexPath.section];
    [self.nav pushViewController:detailForm animated:YES];
}

/**
 *  //取消工单
 *
 *  @param indexPath <#indexPath description#>
 */
-(void)deleteOrderClickHandler:(NSIndexPath *)indexPath btn:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"取消订单"])
    {
        CancelOrderController *cancelView  = [[CancelOrderController alloc]init];
        cancelView.orderItem = dataProvider[indexPath.section];
        [self.nav pushViewController:cancelView animated:YES];
    }
    else if ([btn.titleLabel.text isEqualToString:@"评价"])
    {
        EvaluationController *evaluaView = [[EvaluationController alloc]init];
        evaluaView.orderItem = dataProvider[indexPath.section];
        [self.nav pushViewController:evaluaView animated:YES];
    }
    else if ([btn.titleLabel.text isEqualToString:@"联系商家"])
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%d",96345]];
        [[UIApplication sharedApplication] openURL:url];;
    }
}

@end
