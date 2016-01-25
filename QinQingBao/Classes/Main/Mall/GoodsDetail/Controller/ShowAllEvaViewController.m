//
//  ShowAllEvaViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ShowAllEvaViewController.h"
#import "GevalModelTotal.h"
#import "EvaluationItemCell.h"

@interface ShowAllEvaViewController ()
{
    NSMutableArray * evaArr;
}

@end

@implementation ShowAllEvaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =  @"全部评价";
    [self getAlleva];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

/**
 *  获取服务评价
 */
-(void)getAlleva
{
    evaArr = [[NSMutableArray alloc] init];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Shop_dis parameters: @{@"goods_id" : self.goodsID,
                                                                 @"type" : @0,
                                                                 @"page" : @1000,
                                                                 @"curpage" : @1}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     GevalModelTotal *result = [GevalModelTotal objectWithKeyValues:[dict objectForKey:@"datas"]];
                                     evaArr = result.message;
                                     [self.tableView reloadData];
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
    return evaArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluationItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTEvaluationItemCell"];
    
    if (cell == nil)
        cell = [EvaluationItemCell evaluationItemCell];
    
    [cell setitemWithShopData:evaArr[indexPath.row]];
    
    return cell;
}



@end
