//
//  GoodsOrderDetailViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsOrderDetailViewController.h"
#import "CommonGoodsDetailEndView.h"

#import "CommonGoodsDetailBottomCell.h"
#import "CommonGoodsDetailHeadCell.h"
#import "CommonGoodsDetailMiddleCell.h"

#import "GoodsMiddleTopCell.h"
#import "GoodsMiddleBottomCell.h"

#import "CommonOrderModel.h"
#import "ReciverinfoModel.h"

#import "RefundViewController.h"

static CGFloat ENDVIEW_HEIGHT = 50;


@interface GoodsOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,CommonGoodsDetailEndViewDelegate>
{
    ReciverinfoModel *reciverModel;
    
    CommonGoodsModel *dataProvider;
}

@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,strong) CommonGoodsDetailEndView *endView;

@end

@implementation GoodsOrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
}


-(void)initTableSkin
{
    self.title = @"订单详情";
    
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = HMGlobalBg;
    
    [self.view addSubview:self.tableView];
    
    _endView = [[CommonGoodsDetailEndView alloc]initWithFrame:CGRectMake(0, MTScreenH - ENDVIEW_HEIGHT, MTScreenW,ENDVIEW_HEIGHT)];
    _endView.nav = self.navigationController;
    _endView.delegate = self;
    [self.view addSubview:_endView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - ENDVIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(void)setItem:(CommonGoodsModel *)item
{
    _item = item;
    CommonOrderModel *model = self.item.order_list[0];
    [self setOrderID:model.order_id];
}

-(void)setOrderID:(NSString *)orderID
{
    _orderID = orderID;
    [self getDataProvider];
}

-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Show_order parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                   @"client" : @"ios",
                                                                   @"order_id" :self.orderID}
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
                                         NSDictionary *dict1 = [dict objectForKey:@"datas"];
                                         NSDictionary *order_common = [dict1 objectForKey:@"extend_order_common"];
                                         NSDictionary *reciver_info = [order_common objectForKey:@"reciver_info"];
                                         reciverModel = [ReciverinfoModel objectWithKeyValues:reciver_info];
                                         reciverModel.reciver_name = [order_common objectForKey:@"reciver_name"];
                                         dataProvider = [CommonGoodsModel objectWithKeyValues:dict1];
                                         
                                         _endView.goodsitemInfo = dataProvider;
                                         _endView.goodsModel = dataProvider;
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //获取这个订单有多少个商品
    if (section == 1)
        return dataProvider.goods_list.count + 2;
    return 1;
}

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    CommonGoodsDetailHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonGoodsDetailHeadCell"];
    
    CommonGoodsDetailBottomCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonGoodsDetailBottomCell"];
    
    GoodsMiddleTopCell *middleTopCell = [tableView dequeueReusableCellWithIdentifier:@"MTGoodsMiddleTopCell"];
    
    CommonGoodsDetailMiddleCell *middleCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonGoodsDetailMiddleCell"];
    
    GoodsMiddleBottomCell *middleBottomCell = [tableView dequeueReusableCellWithIdentifier:@"MTGoodsMiddleBottomCell"];
    
    
    //获取这个订单有多少个商品
    //    CommonOrderModel *itemInfo = self.item.order_list[0];
    //    NSMutableArray *arr = itemInfo.extend_order_goods;
    
    //收货地址
    if (indexPath.section == 0)
    {
        if(headCell == nil)
            headCell = [CommonGoodsDetailHeadCell commonGoodsDetailHeadCell];
        [headCell setitemWithData:reciverModel];
        cell = headCell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            if(middleTopCell == nil)
                middleTopCell = [GoodsMiddleTopCell goodsMiddleTopCell];
            [middleTopCell setitemWithData:dataProvider];
            cell = middleTopCell;
        }
        else if (indexPath.row == dataProvider.goods_list.count + 1)
        {
            if(middleBottomCell == nil)
                middleBottomCell = [GoodsMiddleBottomCell goodsMiddleBottomCell];
            [middleBottomCell setitemWithData:dataProvider];
            cell = middleBottomCell;
        }
        else
        {
            //修改 by swy
            if(middleCell == nil)
                middleCell = [CommonGoodsDetailMiddleCell commonGoodsDetailMiddleCell];
            
            [middleCell setitemWithData:dataProvider.goods_list[indexPath.row -1]];
            //已經取消了
            if ([dataProvider.order_state isEqualToString:@"0"]) {
                middleCell.button.hidden = YES;
                //客戶都已經評論了
            }else if([dataProvider.evaluation_state isEqualToString:@"1"]){
                middleCell.button.hidden = YES;
                //订单未支付
            } else if([dataProvider.order_state isEqualToString:@"10"]){
                middleCell.button.hidden = YES;
            }
            //跳转到退款界面
            __weak typeof(self) weakSelf = self;
            middleCell.refundOperation = ^(CommonGoodsDetailMiddleCell *midCell){
                RefundViewController *refundVC = [[RefundViewController alloc] init];
                refundVC.orderInfo = dataProvider;
                refundVC.orderGoodsModel = dataProvider.goods_list[indexPath.row -1];
                if ([dataProvider.order_state isEqualToString:@"20"]) {//付款未发货
                    refundVC.isShowRefundType = NO;
                }else if([dataProvider.order_state isEqualToString:@"30"]){//付款已发货
                    refundVC.isShowRefundType = YES;
                }
                [weakSelf.navigationController pushViewController:refundVC animated:YES];
            };
            cell = middleCell;
        }
    }
    //订单编号等信息
    else
    {
        if(bottomCell == nil)
            bottomCell = [CommonGoodsDetailBottomCell commonGoodsDetailBottomCell];
        
        [bottomCell setitemWithData:dataProvider];
        cell = bottomCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma  mark CommonGoodsDetailEndViewDelegate
/**
 *  底部的CommonGoodsDetailEndView中的按钮被点击后回调
 */
-(void)endView:(CommonGoodsDetailEndView *)endView button:(UIButton *)btn tappedAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        //        CommonOrderModel *itemInfo = dataProvider.order_list[0];
        RefundViewController *refundVC = [[RefundViewController alloc] init];
        refundVC.orderInfo = dataProvider;
        if ([dataProvider.order_state isEqualToString:@"20"]) {//付款未发货
            refundVC.isShowRefundType = NO;
        }else if([dataProvider.order_state isEqualToString:@"30"]){//付款已发货
            refundVC.isShowRefundType = YES;
        }
        [self.navigationController pushViewController:refundVC animated:YES];
    }
}

@end
