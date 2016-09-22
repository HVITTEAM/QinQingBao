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

#import "CommonEvaluateGoodsViewController.h"

#import "CommonGoodsCellHead.h"
#import "CommonGoodsCellBottom.h"

#import "DeliverViewController.h"

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
}

-(void)initTableViewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
}

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    currentPageIdx = 1;
    dataProvideer = [[NSMutableArray alloc] init];
    [self getDataProvider];
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
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    if ([self.title isEqualToString:@"全部"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"page" : @10,
                  @"curpage" : @1,
                  @"getpayment" : @"true"};
    }
    else if ([self.title isEqualToString:@"待付款"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"page" : @10,
                  @"curpage" : @1,
                  @"getpayment" : @"true",
                  @"order_state" : @"10"};
    }
    else if ([self.title isEqualToString:@"待发货"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"page" : @10,
                  @"curpage" : @1,
                  @"getpayment" : @"true",
                  @"order_state" : @"20"};
    }
    else if ([self.title isEqualToString:@"待收货"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"page" : @10,
                  @"curpage" : @1,
                  @"getpayment" : @"true",
                  @"order_state" : @"30"};
    }
    else if ([self.title isEqualToString:@"待评价"])
    {
        dict = @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                 @"client" : @"ios",
                 @"page" : @10,
                 @"curpage" : @1,
                 @"getpayment" : @"true",
                 @"order_state" : @"40",
                 @"evaluation_state" : @"0"};
    }
    else if ([self.title isEqualToString:@"售后/取消"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"page" : @10,
                  @"curpage" : @1,
                  @"getpayment" : @"true",
                  @"order_state" : @"0"};
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Order_list parameters:dict
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
                                             [self.tableView initWithPlaceString:PlaceholderStr_Order imgPath:@"placeholder-1.png"];
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
        
        [goodscell setitemWithData:arr[indexPath.row - 1]];
        
        cell = goodscell;
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsOrderDetailViewController *detailVC = [[GoodsOrderDetailViewController alloc] init];
    [detailVC setItem:dataProvideer[indexPath.section]];
    [self.nav pushViewController:detailVC animated:YES];
}

#pragma mark  订单操作模块

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
        [self deleteOrder:item indexPath:indexPath];
    }
    else if ([btn.titleLabel.text isEqualToString:@"确认收货"])
    {
        [self recive:item indexPath:indexPath];
    }
    else if ([btn.titleLabel.text isEqualToString:@"提醒发货"])
    {
        [NoticeHelper AlertShow:@"提醒成功!" view:self.view.window.rootViewController.view];
    }
    else if ([btn.titleLabel.text isEqualToString:@"查看物流"])
    {
        [self showDeliver:item];
    }
    else if ([btn.titleLabel.text isEqualToString:@"评价"])
    {
        [self showEvaViewControler:indexPath];
    }
}

//查看物流
-(void)showDeliver:(CommonGoodsModel*)item
{
    DeliverViewController *vc = [[DeliverViewController alloc] init];
    [vc setItem:item];
    [self.nav pushViewController:vc animated:YES];
}

//删除订单
-(void)deleteOrder:(CommonGoodsModel*)item indexPath:(NSIndexPath *)indexPath
{
    selectedCanceOrder = item;
    selectedIndexPath = indexPath;
    UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除订单？删除后将无法恢复订单。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    deleteAlertView.tag = 200;
    [deleteAlertView show];
}

//取消订单
-(void)canceOrder:(CommonGoodsModel*)item indexPath:(NSIndexPath *)indexPath
{
    selectedCanceOrder = item;
    selectedIndexPath = indexPath;
    UIAlertView *canceAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认取消订单？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    canceAlertView.tag = 100;
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
                                         if (![self.title isEqualToString:@"全部"])
                                         {
                                             [dataProvideer removeObject:dataProvideer[selectedIndexPath.section]];
                                             [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                 [self.tableView reloadData];
                                             });
                                         }
                                         else{
                                             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                         }
                                                                             }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}

//支付
-(void)pay:(CommonGoodsModel*)item indexPath:(NSIndexPath *)indexPath
{
    [MTPayHelper payWithAliPayWitTradeNO:item.pay_sn productName:@"百货" amount:item.pay_amount productDescription:@"海予健康商城" notifyURL:URL_AliPay_Goods success:^(NSDictionary *dict,NSString *signedString) {
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
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
    } failure:^(NSDictionary *dict) {
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
    if (alertView.tag == 100)
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
                                                 if (![self.title isEqualToString:@"全部"])
                                                 {
                                                     [dataProvideer removeObject:dataProvideer[selectedIndexPath.section]];
                                                     [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                         [self.tableView reloadData];
                                                     });
                                                 }
                                                 else{
                                                     [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                                 }
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             NSLog(@"发生错误！%@",error);
                                             [HUD removeFromSuperview];
                                         }];
            
        }
    }
    else if (alertView.tag == 200)
    {
        if(buttonIndex == 0)
        {
            CommonOrderModel *orderModel = selectedCanceOrder.order_list[0];
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view.window.rootViewController.view animated:YES];
            [CommonRemoteHelper RemoteWithUrl:URL_Del_order parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
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
                                                 [dataProvideer removeObject:dataProvideer[selectedIndexPath.section]];
                                                 [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:selectedIndexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                                 
                                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                     [self.tableView reloadData];
                                                 });
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             NSLog(@"发生错误！%@",error);
                                             [HUD removeFromSuperview];
                                         }];
        }
    }
}

#pragma mark 评价
-(void)showEvaViewControler:(NSIndexPath *)indexPath
{
    CommonEvaluateGoodsViewController *vc = [[CommonEvaluateGoodsViewController alloc] init];
    [vc setItem:dataProvideer[indexPath.section]];
    [self.nav pushViewController:vc animated:YES];
}


@end
