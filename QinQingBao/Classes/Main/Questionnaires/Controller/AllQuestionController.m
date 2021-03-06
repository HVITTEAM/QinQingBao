//
//  AllQuestionController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AllQuestionController.h"
#import "ExamCell.h"
#import "ExamModel.h"
#import "LifeHealthViewController.h"
#import "SexViewController.h"

@interface AllQuestionController ()
{
    NSMutableArray *dataProvider;
    NSInteger currentPageIdx;
}

@end

@implementation AllQuestionController

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
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = HMGlobalBg;
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
    [CommonRemoteHelper RemoteWithUrl:URL_Get_examlist parameters:@{@"page" : @"10",
                                                                    @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                                                                    @"c_id":self.c_id
                                                                    }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSArray *arr;
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         //                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                     }
                                     else
                                     {
                                         arr = [ExamModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         [self.tableView reloadData];
                                     }
                                     
                                     [self.tableView removePlace];
                                     if (arr.count == 0 && currentPageIdx == 1)
                                     {
                                         [self.tableView initWithPlaceString:@"暂无数据!" imgPath:nil];
                                     }
                                     else if (arr.count == 0 && currentPageIdx > 1)
                                     {
//                                         NSLog(@"没有更多的数据了");
                                         currentPageIdx --;
                                         [self.view showNonedataTooltip];
                                     }
                                     [dataProvider addObjectsFromArray:arr];
                                     [self.tableView reloadData];
                                     [self.tableView.footer endRefreshing];
                                     [self.tableView.header endRefreshing];
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                     NSLog(@"发生错误！%@",error);
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExamCell *marketcell = [ExamCell createCellWithTableView:tableView];
    
    if (self.tableView.header.state != MJRefreshStateRefreshing)
    {
        [marketcell setModelWith:dataProvider[indexPath.section]];
    }
    return marketcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamModel *item = dataProvider[indexPath.section];

    if ([item.e_id integerValue] == 43)
    {
        SexViewController *vc = [[SexViewController alloc] init];
        ExamModel *item = dataProvider[indexPath.section];
        vc.exam_id = item.e_id;
        vc.e_title = item.e_title;
        vc.calculatype = item.e_calculatype;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    LifeHealthViewController *vc = [[LifeHealthViewController alloc] init];
    vc.eq_id = 1;
    vc.exam_id = item.e_id;
    vc.e_title = item.e_title;
    vc.calculatype = item.e_calculatype;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
