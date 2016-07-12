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

@interface MarketViewController ()
{
    NSArray *dataProvider;
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
    
    [self getDataProvider];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = HMGlobalBg;
    self.title = @"服务市场";
}

/**
 *  获取数据源
 */
-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_get_iteminfo parameters:@{@"page" : @"100",
                                                                    @"p" : @"1",
                                                                    @"tid" : @44}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         dataProvider = [MassageModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         [self.tableView reloadData];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
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
    return 130;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommonMarketCell *marketcell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonMarketCell"];
    
    if (marketcell == nil)
        marketcell = [CommonMarketCell commonMarketCell];
    
    marketcell.item = dataProvider[indexPath.section];
    
    return marketcell;
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
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
        view.iidnum = model.iid_num;
        [self.navigationController pushViewController:view animated:YES];
    }
}
@end
