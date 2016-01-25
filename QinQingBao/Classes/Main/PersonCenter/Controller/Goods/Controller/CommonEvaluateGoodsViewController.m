//
//  CommonEvaluateGoodsViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonEvaluateGoodsViewController.h"
#import "CommonOrderGoodsEvaCell.h"
#import "EvaFootView.h"

@interface CommonEvaluateGoodsViewController ()

@end

@implementation CommonEvaluateGoodsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"评价";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交评价" style:UIBarButtonItemStylePlain target:self action:@selector(submitEva)];
    
    self.tableView.tableFooterView = [EvaFootView evaFootView];
    
    self.tableView.backgroundColor = HMGlobalBg;
}

-(void)setItem:(CommonGoodsModel *)item
{
    _item = item;
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CommonOrderModel *itemInfo = self.item.order_list[0];
    NSMutableArray *arr = itemInfo.extend_order_goods;
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    CommonOrderGoodsEvaCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonOrderGoodsEvaCell"];
    
    //获取这个订单有多少个商品
    CommonOrderModel *itemInfo = self.item.order_list[0];
    NSMutableArray *arr = itemInfo.extend_order_goods;
    
    if(commoncell == nil)
        commoncell = [CommonOrderGoodsEvaCell commonOrderGoodsEvaCell];
    
    [commoncell setitemWithData:arr[indexPath.row]];
    cell = commoncell;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**提交评价**/
-(void)submitEva
{
    CommonOrderModel *itemInfo = self.item.order_list[0];
    NSMutableArray *arr = itemInfo.extend_order_goods;
    
    //获取综合评价
    NSString *str = [(EvaFootView *)self.tableView.tableFooterView getEva];
    NSArray *arr0 = [str componentsSeparatedByString:@"-"];
    NSString *store_desccredit = arr0[0];
    NSString *store_servicecredit = arr0[1];
    NSString *store_deliverycredit = arr0[2];
    
    if ([store_desccredit floatValue] < 1 || [store_servicecredit floatValue] < 1 || [store_deliverycredit floatValue] < 1)
    {
        return [NoticeHelper AlertShow:@"请对综合评价评分" view:self.view.window.rootViewController.view];
    }
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
              @"client" : @"ios",
              @"order_id" : itemInfo.order_id,
              @"store_desccredit" : store_desccredit,
              @"store_servicecredit" : store_servicecredit,
              @"store_deliverycredit" : store_deliverycredit};
    
    NSMutableDictionary *dict1 = [dict mutableCopy];
    
    //获取物品评价
    for (int i = 0; i < arr.count; i++)
    {
        CommonOrderGoodsEvaCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString *str = [cell getEvaContent];
        NSArray *arr = [str componentsSeparatedByString:@"-"];
        NSString *idStr = arr[0];
        NSString *scoreStr = arr[1];
        
        if ([scoreStr floatValue] < 1)
        {
            return [NoticeHelper AlertShow:@"请选择评论星级" view:self.view.window.rootViewController.view];
        }

        NSString *contentStr = arr[2];
        
        [dict1 setObject:[NSString stringWithFormat:@"%@",scoreStr] forKey:[NSString stringWithFormat:@"goods[%@][score]",idStr]];
        [dict1 setObject:[NSString stringWithFormat:@"%@",contentStr] forKey:[NSString stringWithFormat:@"goods[%@][comment]",idStr]];
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Dis_add parameters: dict1
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
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}

@end
