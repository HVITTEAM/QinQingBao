//
//  AddressManagerTableViewController.m
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AddressManagerTableViewController.h"
#import "AddressManagerCell.h"
#import "AddaddressInfoViewController.h"

#import "AddressListTotal.h"
#import "MallAddressModel.h"

@interface AddressManagerTableViewController ()<UIAlertViewDelegate>
{
    //选中要删除的item
    MallAddressModel *selectedDelateItem;
    
    NSIndexPath *selectedIndexPath;

    
    NSMutableArray *dataProvider;
}

@end

@implementation AddressManagerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getDataProvider];
}

-(void)initNavgation
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.title = @"管理收货地址";
    UIBarButtonItem *manager = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStyleDone target:self action:@selector(addAddress)];
    self.navigationItem.rightBarButtonItem = manager;
}

- (void)addAddress
{
    AddaddressInfoViewController *addAddress = [AddaddressInfoViewController new];
    addAddress.title = @"新增收货地址";
    [self.navigationController pushViewController:addAddress animated:YES];
}

#pragma mark --- Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return dataProvider.count;
}

#pragma mark --- Table view delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
        cell = [AddressManagerCell addressManagerCell];
    if (indexPath.row == 0)
        cell.chooseLable.alpha = 1;
    
    [cell setItem:dataProvider[indexPath.section]];
    
    cell.clickDelete = ^(MallAddressModel *item)
    {
        [self deleteAddress:item indexPath:indexPath];
    };
    
    cell.clickEdit = ^(MallAddressModel *item)
    {
        [self editAddress:item];
    };
    
    cell.clickSetDefault = ^(MallAddressModel *item)
    {
        [self setDefaultaddress:item];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark --- cell block

- (void)deleteAddress:(MallAddressModel *)item indexPath:(NSIndexPath *)indexPath
{
    selectedDelateItem = item;
    selectedIndexPath = indexPath;
    [self sureDelate];
}

- (void)editAddress:(MallAddressModel *)item
{
    AddaddressInfoViewController *editAddress = [AddaddressInfoViewController new];
    editAddress.title = @"更改收货地址";
    editAddress.item = item;
    [self.navigationController pushViewController:editAddress animated:YES];
}

//设置默认地址
-(void)setDefaultaddress:(MallAddressModel *)item
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Address_edit parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios",
                                                                     @"address_id" : item.address_id,
                                                                     @"is_default" : @1,}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [HUD removeFromSuperview];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         [self getDataProvider];
                                     }
                                 }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"出错了....");
                                  [HUD removeFromSuperview];
                              }];
}

/**重新获取数据**/
-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_Address_list parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios",
                                                                     @"page" : @100}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     AddressListTotal *result = [AddressListTotal objectWithKeyValues:dict];
                                     dataProvider = result.datas;
                                     if (dataProvider.count == 0)
                                         [self.tableView initWithPlaceString:@"暂无数据!" imgPath:nil];
                                     else
                                         [self.tableView removePlace];
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                 }];
}

# pragma  mark 确认删除
-(void)sureDelate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"确定要删除此地址？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_Address_del parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                        @"client" : @"ios",
                                                                        @"address_id" : selectedDelateItem.address_id}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                         [HUD removeFromSuperview];
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             [dataProvider removeObject:selectedDelateItem];
                                             [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                             
                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                 [self getDataProvider];
                                             });
                                             [HUD removeFromSuperview];
                                         }
                                     }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"出错了....");
                                      [HUD removeFromSuperview];
                                  }];
    }
}


@end
