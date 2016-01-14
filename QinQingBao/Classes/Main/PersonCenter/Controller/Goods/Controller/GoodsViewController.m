//
//  GoodsViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsViewController.h"
#import "CommonGoodsTotal.h"
#import "GoodsOrderDetailViewController.h"


#import "CommonGoodsCellHead.h"
#import "CommonGoodsCellBottom.h"


#import "CommonGoodsCellMiddle.h"

@interface GoodsViewController ()<UIAlertViewDelegate>
{
    NSMutableArray *dataProvideer;
    
    //当前第一页
    NSInteger currentPageIdx;
    
    //总共多少页
    NSInteger totalPage;
    
    //选择的要取消的订单
    CommonGoodsModel *selectedCanceOrder;
    
    //选择的的序号
    NSIndexPath *selectedIndexPath;
}

@end

@implementation GoodsViewController

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
    
    [self initTableViewSkin];
    
    [self setupRefresh];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getDataProvider];
}

-(void)initTableViewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    currentPageIdx = 1;
    dataProvideer = [[NSMutableArray alloc] init];
    // 上拉刷新
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPageIdx ++ ;
        [self getDataProvider];
    }];
}

-(void)getDataProvider
{
    if (totalPage && currentPageIdx > totalPage)
    {
        [self.tableView.footer endRefreshing];
        [self.tableView showNonedataTooltip];
        currentPageIdx --;
        return;
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Order_list parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                   @"client" : @"ios",
                                                                   @"page" : @10,
                                                                   @"curpage" : @1,
                                                                   @"getpayment" : @"true"}
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
                                         NSString *str = [dict objectForKey:@"page_total"];
                                         totalPage = [str integerValue];
                                         
                                         NSDictionary *dict1 =  [dict objectForKey:@"datas"];
                                         CommonGoodsTotal *result = [CommonGoodsTotal objectWithKeyValues:dict1];
                                         
                                         if (result.order_group_list.count == 0 && currentPageIdx == 1)
                                         {
                                             [self.tableView initWithPlaceString:@"暂无数据!"];
                                         }
                                         else if (result.order_group_list.count == 0 && currentPageIdx > 1)
                                         {
                                             [self.tableView removePlace];
                                             NSLog(@"没有更多的数据了");
                                             currentPageIdx --;
                                         }
                                         else
                                         {
                                             [self.tableView removePlace];
                                         }
                                         [dataProvideer addObjectsFromArray:[result.order_group_list copy]];
                                         [self.tableView reloadData];
                                         [self.tableView.footer endRefreshing];
                                     }
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}


#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataProvideer.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //获取这个订单有多少个商品
    CommonGoodsModel *item = dataProvideer[section];
    CommonOrderModel *itemInfo = item.order_list[0];
    NSMutableArray *arr = itemInfo.extend_order_goods;
    return   arr.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    CommonGoodsCellMiddle *goodscell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonGoodsCellMiddle"];
    
    CommonGoodsCellHead *headcell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonGoodsCellHead"];
    
    CommonGoodsCellBottom *bottomcell = [tableView dequeueReusableCellWithIdentifier:@"CommonGoodsCellBottom"];
    
    //获取这个订单有多少个商品
    CommonGoodsModel *item = dataProvideer[indexPath.section];
    CommonOrderModel *itemInfo = item.order_list[0];
    NSMutableArray *arr = itemInfo.extend_order_goods;
    
    if (indexPath.row == 0)
    {
        if(headcell == nil)
            headcell = [CommonGoodsCellHead commonGoodsCellHead];
        
        [headcell setitemWithData:dataProvideer[indexPath.section]];
        cell = headcell;
    }
    else if (indexPath.row == arr.count + 1)
    {
        if(bottomcell == nil)
            bottomcell = [CommonGoodsCellBottom commonGoodsCellBottom];
        bottomcell.buttonClick = ^(UIButton *btn)
        {
            [self buttonClickHandler:btn item:item indexPath:indexPath];
        };
        [bottomcell setitemWithData:dataProvideer[indexPath.section]];
        cell = bottomcell;
    }
    else
    {
        if(goodscell == nil)
            goodscell = [CommonGoodsCellMiddle commonGoodsCellMiddle];
        
        [goodscell setitemWithData:dataProvideer[indexPath.section]];
        
        cell = goodscell;
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsOrderDetailViewController *detailVC = [[GoodsOrderDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

/**操作按钮对应点击事件**/
-(void)buttonClickHandler:(UIButton *)btn item:(CommonGoodsModel*)item indexPath:(NSIndexPath *)indexPath
{
    if ([btn.titleLabel.text isEqualToString:@"支付"])
    {
        [self pay:item indexPath:indexPath];
    }
    else if ([btn.titleLabel.text isEqualToString:@"取消订单"])
    {
        [self canceOrder:item indexPath:indexPath];
    }
    else if ([btn.titleLabel.text isEqualToString:@"删除订单"])
    {
        [NoticeHelper AlertShow:@"此功能尚未开通!" view:self.view.window.rootViewController.view];
        //TODO
    }
    else if ([btn.titleLabel.text isEqualToString:@"确认收货"])
    {
        [self recive:item indexPath:indexPath];
        
    }
    else if ([btn.titleLabel.text isEqualToString:@"查看物流"])
    {
        //TODO
        [NoticeHelper AlertShow:@"此功能尚未开通!" view:self.view.window.rootViewController.view];
    }
}

#pragma mark  订单操作模块

//取消订单
-(void)canceOrder:(CommonGoodsModel*)item indexPath:(NSIndexPath *)indexPath
{
    selectedCanceOrder = item;
    UIAlertView *canceAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认取消订单？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    [canceAlertView show];
}

//确认收货
-(void)recive:(CommonGoodsModel*)item indexPath:(NSIndexPath *)indexPath
{
    CommonOrderModel *orderModel = item.order_list[0];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view.window.rootViewController.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Order_receive parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                      @"client" : @"ios",
                                                                      @"order_id" : orderModel.order_id}
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
                                         orderModel.order_state = @"40";
                                         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}

//支付
-(void)pay:(CommonGoodsModel*)item indexPath:(NSIndexPath *)indexPath
{
    [MTPayHelper payWithAliPayWitTradeNO:item.pay_sn productName:@"百货" amount:item.pay_amount productDescription:@"海予孝心商城" success:^(NSDictionary *dict,NSString *signedString) {
        NSLog(@"支付成功");
        NSString *out_trade_no;
        NSString *sign;
        NSString *html = [dict objectForKey:@"result"];
        NSArray *resultStringArray =[html componentsSeparatedByString:NSLocalizedString(@"&", nil)];
        for (NSString *str in resultStringArray)
        {
            NSString *newstring = nil;
            newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
            for (int i = 0 ; i < [strArray count] ; i++)
            {
                NSString *st = [strArray objectAtIndex:i];
                if ([st isEqualToString:@"out_trade_no"])
                {
                    NSLog(@"%@",[strArray objectAtIndex:1]);
                    out_trade_no = [strArray objectAtIndex:1];
                }
                else if ([st isEqualToString:@"sign"])
                {
                    NSLog(@"%@",[strArray objectAtIndex:1]);
                    sign = [strArray objectAtIndex:1];
                    [self api_alipay:out_trade_no pay_sn:item.pay_sn signedString:sign];
                }
            }
        }
        CommonOrderModel *orderModel = item.order_list[0];
        orderModel.order_state = @"20";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];    } failure:^(NSDictionary *dict) {
            NSLog(@"支付失败");
            //用户中途取消
            if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"6001"])
            {
                
            }
        }];
    
}


/**订单 - 支付付款 订单状态修改**/
-(void)api_alipay:(NSString *)out_trade_no pay_sn:(NSString *)pay_sn signedString:(NSString *)signedString
{
    [CommonRemoteHelper RemoteWithUrl:URL_Alipay parameters: @{@"out_trade_no" : pay_sn,
                                                               @"request_token" : @"requestToken",
                                                               @"result" : @"success",
                                                               @"trade_no" : out_trade_no,
                                                               @"sign" : signedString,
                                                               @"sign_type" : @"MD5"}
                                 type:CommonRemoteTypeGet success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSLog(@"支付结果验证成功");
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                 }];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        CommonOrderModel *orderModel = selectedCanceOrder.order_list[0];
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view.window.rootViewController.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_Order_cancel parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                         @"client" : @"ios",
                                                                         @"order_id" : orderModel.order_id}
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
                                             orderModel.order_state = @"0";
                                             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                     }];

    }
}


@end
