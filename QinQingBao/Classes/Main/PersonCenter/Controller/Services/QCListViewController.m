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

@interface QCListViewController ()
{
    NSMutableArray *dataProvider;
}

@end

@implementation QCListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
}


- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    [self headerRereshing];
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
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
//- (void)setupRefresh
//{
//    // 下拉刷新
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [self headerRereshing];
//        });
//    }];
//    self.tableView.tableFooterView = [[UIView alloc] init];
//    if ([self.title isEqualToString:@"全部"]) {
//        [self.tableView.header beginRefreshing];
//    }
//}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_workinfo parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios",
                                                                     @"p" : @"1",
                                                                     @"oldid" : [SharedAppUtil defaultCommonUtil].userVO.old_id,
                                                                     @"page" : @"10"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     OrderTotals *result = [OrderTotals objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     if (result.datas.count == 0)
                                     {
                                         [self.tableView initWithPlaceString:@"暂无数据"];
//                                         [NoticeHelper AlertShow:@"暂无数据" view:self.view];
                                     }
                                     dataProvider  = result.datas;
                                     [self.tableView reloadData];
                                     [self.tableView.header endRefreshing];
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                     [HUD removeFromSuperview];
                                 }];
}


#pragma mark - 表格视图数据源代理方法

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"ddd1";
//}


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
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    if (cell == nil)
        cell = [CommonOrderCell commonOrderCell];
    
    cell.deleteClick = ^(UIButton *btn){
        [self deleteOrderClickHandler];
    };
    
    [cell setItem:dataProvider[indexPath.section]];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderFormDetailController *detailForm = [[OrderFormDetailController alloc] init];
    [self.nav pushViewController:detailForm animated:YES];
}

-(void)deleteOrderClickHandler
{
    if (!self.evaluaView)
        self.evaluaView  = [[EvaluationController alloc]init];
    [self.nav pushViewController:self.evaluaView animated:YES];
    //    if (!self.cancelView)
    //        self.cancelView  = [[CancelOrderController alloc]init];
    //    [self.nav pushViewController:self.cancelView animated:YES];
}

-(NSString *)kilometre2meter:(float)meter
{
    if (meter < 1000)
        return [NSString stringWithFormat:@"%.02f米",meter];
    else
    {
        float km = meter/1000;
        return [NSString stringWithFormat:@"%.02f千米",km];
    }
}

@end
