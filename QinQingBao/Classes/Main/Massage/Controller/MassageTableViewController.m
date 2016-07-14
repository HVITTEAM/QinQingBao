//
//  MassageTableViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MassageTableViewController.h"
#import "MassageServiceCell.h"
#import "MassageModel.h"
#import "ShopDetailViewController.h"

#import "ChooseShopTableViewController.h"

@interface MassageTableViewController ()

@end

@implementation MassageTableViewController
{
    NSMutableArray *dataProvider;
    NSInteger currentPageIdx;
}

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRefresh];
    currentPageIdx = 1;
    dataProvider = [[NSMutableArray alloc] init];
    
    [self initTableSkin];
    
    [self getDataProvider];
}

- (void)initTableSkin
{
    self.title = @"超声理疗";
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
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
                                                                    @"tid" : @43}
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataProvider.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MassageServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTMassageServiceCell"];
    if (cell == nil)
        cell = [MassageServiceCell massageServiceCell];
    
    [cell setItem:dataProvider[indexPath.row]];
    
    return cell;
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
        ShopDetailViewController *view = [[ShopDetailViewController alloc] init];
        view.iid = model.iid;
        view.iidnum = model.iid_num;
        [self.navigationController pushViewController:view animated:YES];
    }
}

@end
