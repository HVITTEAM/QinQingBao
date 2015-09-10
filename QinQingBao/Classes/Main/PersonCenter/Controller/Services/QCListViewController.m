//
//  QCListViewController.m
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//

#import "QCListViewController.h"

@interface QCListViewController ()

@end

@implementation QCListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRefresh];
    
    [self initTableviewSkin];
}

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
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
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    [self.tableView headerBeginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //     2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if ([self.title isEqualToString:@"全部专题"])
    {
        [self getNearbyType:@"0" distence:Near_Distance];
    }
    else if ([self.title isEqualToString:@"避灾场所"])
    {
        [self getNearbyType:@"1" distence:Near_Distance];
    }
    else if ([self.title isEqualToString:@"物资仓库"])
    {
        [self getNearbyType:@"2" distence:Near_Distance];
    }
    else if ([self.title isEqualToString:@"救灾人员定位"])
    {
        [self getNearbyType:@"4" distence:Near_Distance];
    }
    else if ([self.title isEqualToString:@"视频探头"])
    {
        [self getNearbyType:@"0" distence:Near_Distance];
    }
    else if ([self.title isEqualToString:@"减灾示范社区"])
    {
        [self getNearbyType:@"3" distence:Near_Distance];
    }
}

-(void)getNearbyType:(NSString *)type distence:(NSString *)distence
{
    
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
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    [self.tableView reloadSections:<#(NSIndexSet *)#> withRowAnimation:<#(UITableViewRowAnimation)#>]
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"ListViewCellId";
    CommonOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CommonOrderCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.deleteClick = ^(UIButton *btn){
            [self deleteOrderClickHandler];
        };
        // 设置背景view
        //        cell.backgroundView = [[UIImageView alloc] init];
        //        cell.selectedBackgroundView = [[UIImageView alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.detailForm == nil)
        self.detailForm = [[OrderFormDetailController alloc] init];
    [self.nav pushViewController:self.detailForm animated:YES];
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
