//
//  ChooseShopTableViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/4/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ChooseShopTableViewController.h"
#import "ShopTableViewCell.h"
#import "ServiceItemModel.h"
#import "ShopOrderViewController.h"
#import "ShopDetailViewController.h"

@interface ChooseShopTableViewController ()
{
    NSMutableArray *dataProvider;
}

@end

@implementation ChooseShopTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
}

-(void)initTableSkin
{
    self.title = @"店面选择";
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)setIid:(NSString *)iid
{
    _iid = iid;
    [self getDataProvider];
}

-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_get_orginfo_by_iidnum parameters:@{@"iidnum" : self.iid}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         dataProvider = [ServiceItemModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTShopTableViewCell"];
    if (cell == nil)
        cell = [ShopTableViewCell shopTableViewCell];
    [cell setItem:dataProvider[indexPath.section]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopDetailViewController *view = [[ShopDetailViewController alloc] init];
    ServiceItemModel *item = dataProvider[indexPath.section];
    view.iid = item.iid;
    view.shopItem = item;
    [self.navigationController pushViewController:view animated:YES];
}

@end
