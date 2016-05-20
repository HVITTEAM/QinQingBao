//
//  CouponsViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/20.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "UseCouponsViewController.h"
#import "CouponsModel.h"
#import "CouponsTotal.h"
#import "OrderModel.h"
#import "StoreModel.h"

#import "CouponsCell.h"


@interface UseCouponsViewController ()
{
    NSMutableArray *dataProvider;
    
    //上一个选择的cell
    NSIndexPath *lastSelectedIndex;
    
    CouponsModel *selectedCouModel;
}

@end

@implementation UseCouponsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
    
    [self initTableSkin];
    
    [self getDataProvider];
    
}

-(void)initNavgation
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureClickHandler)];
}

-(void)setSelectedModel:(CouponsModel *)selectedModel
{
    _selectedModel = selectedModel;
    [self.tableView reloadData];
}

-(void)sureClickHandler
{
    [self.navigationController popViewControllerAnimated:YES];
    self.selectedClick(selectedCouModel);
}

-(void)initTableSkin
{
    self.title = @"使用优惠券";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = HMGlobalBg;
}

-(void)getDataProvider
{
#warning   storeid写死为14 因为我们的商城店铺就只有一个
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Youhuicard parameters: @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                   @"voucher_state" : @"1",
                                                                   @"page" : @1000,
                                                                   @"curpage" : @1,
                                                                   @"voucher_store_id" : self.store_id?:@14,
                                                                   @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                   @"client" : @"ios",
                                                                   @"price" : self.totalPrice ?: @""}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         if ([codeNum integerValue] == 17001)
                                             [self.tableView initWithPlaceString:@"暂无数据!"];
                                         else
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                     }
                                     else
                                     {
                                         CouponsTotal *result = [CouponsTotal objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         dataProvider = result.voucher_list;
                                         if (dataProvider.count == 0)
                                             [self.tableView initWithPlaceString:@"暂无数据!"];
                                         [self.tableView reloadData];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
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
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponsCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CouponsCell"];
    
    if (cell == nil)
        cell = [CouponsCell couponsCell];
    
    CouponsModel *item = dataProvider[indexPath.section];
    
    if ([item.voucher_id isEqualToString:self.selectedModel.voucher_id])
        lastSelectedIndex = indexPath;
    
    if (lastSelectedIndex == indexPath)
        [cell setBtnSelected:YES];
    
    [cell setCouponsModel:item];
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.couponsModel.voucher_limit floatValue] > [self.totalPrice floatValue])
        return [NoticeHelper AlertShow:@"订单总额没有达到使用该优惠券的最低额度！" view:self.view];
    if (lastSelectedIndex && lastSelectedIndex != indexPath)
    {
        CouponsCell *cell = [tableView cellForRowAtIndexPath:lastSelectedIndex];
        [cell setBtnSelected:NO];
    }
    [cell setBtnSelected:!cell.selectBtn.selected];
    if (cell.selectBtn.selected)
        selectedCouModel = cell.couponsModel;
    else
        selectedCouModel = nil;
    lastSelectedIndex = indexPath;
}

@end
