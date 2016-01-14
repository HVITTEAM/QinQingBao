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

#import "CouponsCell.h"


@interface UseCouponsViewController ()
{
    NSMutableArray *dataProvider;
    
    //上一个选择的cell
    NSIndexPath *lastSelectedIndex;
    
    CouponsModel *selectedModel;
}

@end

@implementation UseCouponsViewController


- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
}

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

-(void)sureClickHandler
{
    [self.navigationController popViewControllerAnimated:YES];
    if (selectedModel)
    {
        self.selectedClick(selectedModel);
    }
}

-(void)initTableSkin
{
    self.title = @"使用优惠券";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = HMGlobalBg;
}

-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Youhuicard parameters: @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                   @"voucher_state" : @"1",
                                                                   @"page" : @1000,
                                                                   @"curpage" : @1}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         [self.tableView initWithPlaceString:@"暂无数据!"];
                                     }
                                     else
                                     {
                                         CouponsTotal *result = [CouponsTotal objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         dataProvider = result.voucher_list;
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
    
    if (lastSelectedIndex == indexPath)
        [cell setBtnSelected:YES];
    
    [cell setCouponsModel:dataProvider[indexPath.section]];
    
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
        selectedModel = cell.couponsModel;
    else
        selectedModel = nil;
    lastSelectedIndex = indexPath;
}

@end
