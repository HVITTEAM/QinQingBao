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
    NSArray *dataProvider;
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
    
    [self initTableSkin];
    
    [self getDataProvider];
}

- (void)initTableSkin
{
    self.title = @"推拿理疗";
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_get_iteminfo parameters:@{@"page" : @"100",
                                                                    @"p" : @"1",
                                                                    @"tid" : @43}
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
