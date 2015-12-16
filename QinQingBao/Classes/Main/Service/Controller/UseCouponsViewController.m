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
        self.selectedClick(selectedModel);
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
                                                                   @"client" : @"ios",
                                                                   @"key" : [SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         CouponsTotal *result = [CouponsTotal objectWithKeyValues:dict];
                                         dataProvider = result.datas;
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
    return 10;
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
    return 130;
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
    if (lastSelectedIndex && lastSelectedIndex != indexPath)
    {
        CouponsCell *cell = [tableView cellForRowAtIndexPath:lastSelectedIndex];
        [cell setBtnSelected:NO];
    }
    CouponsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBtnSelected:!cell.selectBtn.selected];
    if (cell.selectBtn.selected)
        selectedModel = cell.couponsModel;
    else
        selectedModel = nil;
    lastSelectedIndex = indexPath;
}

@end
