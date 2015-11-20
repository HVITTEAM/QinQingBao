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
@interface UseCouponsViewController ()
{
    NSMutableArray *dataProvider;

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
}

-(void)initTableSkin
{
    self.title = @"使用优惠券";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Youhuicard parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *listViewCellId = @"couponsCell";
    CommonCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:listViewCellId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CommonCouponsCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
}
@end
