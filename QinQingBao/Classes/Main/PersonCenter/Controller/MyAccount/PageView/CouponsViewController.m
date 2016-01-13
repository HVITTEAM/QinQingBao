//
//  CouponsTableViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CouponsViewController.h"
#import "CouponsModel.h"
#import "CouponsTotal.h"


@interface CouponsViewController ()
{
    NSMutableArray *dataProvider;
}

@end

@implementation CouponsViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self getDataProvider];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)initTableSkin
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = HMGlobalBg;
}

-(void)getDataProvider
{
    dataProvider = [[NSMutableArray alloc] init];

    NSDictionary *dict = [[NSDictionary alloc] init];
    
    if ([self.title isEqualToString:@"全部"])
    {
        dict =  @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"page" : @100,
                  @"curpage" : @1};
    }
    else if ([self.title isEqualToString:@"已使用"])
    {
        dict =  @{@"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"voucher_state" : @"2",
                  @"page" : @100,
                  @"curpage" : @1};
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CommonRemoteHelper RemoteWithUrl:URL_Youhuicard parameters: dict
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataProvider.count;
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
    
    [cell setCouponsModel:dataProvider[indexPath.section]];
    
    cell.left.constant = 0;
    cell.selectBtn.hidden = YES;
    return  cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
