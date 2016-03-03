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
    _endView.goodsitemInfo = self.item.order_list[0];
    _endView.goodsModel = self.item;
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
    [self getDataProvider];
}

-(void)getDataProvider
{
    CommonOrderModel *model = self.item.order_list[0];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Show_order parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                   @"client" : @"ios",
                                                                   @"order_id" : model.order_id}
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
                                         NSDictionary *invoice_info = [order_common objectForKey:@"invoice_info"];
//                                         if (!invoice_info || [invoice_info isEqualToDictionary:@"null"])
//                                             reciverModel.inv_title_select = @"";
//                                         else
//                                             reciverModel.inv_title_select = [invoice_info objectForKey:@"inv_title_select"];
                                         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
    CommonOrderModel *itemInfo = self.item.order_list[0];
    NSMutableArray *arr = itemInfo.extend_order_goods;
    if (section == 1)
        return arr.count + 2;
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
    CommonOrderModel *itemInfo = self.item.order_list[0];
    NSMutableArray *arr = itemInfo.extend_order_goods;
    
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
            [middleTopCell setitemWithData:self.item];
            cell = middleTopCell;
        }
        else if (indexPath.row == arr.count + 1)
        {
            if(middleBottomCell == nil)
                middleBottomCell = [GoodsMiddleBottomCell goodsMiddleBottomCell];
            //            middleBottomCell.buttonClick = ^(UIButton *btn)
            //            {
            //                [self buttonClickHandler:btn item:item indexPath:indexPath];
            //            };
            [middleBottomCell setitemWithData:self.item];
            cell = middleBottomCell;
        }
        else
        {
            //修改 by swy
            if(middleCell == nil)
                middleCell = [CommonGoodsDetailMiddleCell commonGoodsDetailMiddleCell];
            
            [middleCell setitemWithData:arr[indexPath.row -1]];
//            if ([itemInfo.order_state isEqualToString:@"20"]) {//付款未发货
//                middleCell.button.hidden = YES;
//            }else if([itemInfo.order_state isEqualToString:@"30"]){//付款已发货
//                middleCell.button.hidden = NO;
//            }
            //跳转到退款界面
            __weak typeof(self) weakSelf = self;
            middleCell.refundOperation = ^(CommonGoodsDetailMiddleCell *midCell){
                
                RefundViewController *refundVC = [[RefundViewController alloc] init];
                refundVC.orderInfo = itemInfo;
                refundVC.orderGoodsModel = arr[indexPath.row -1];
                if ([itemInfo.order_state isEqualToString:@"20"]) {//付款未发货
                    refundVC.isShowRefundType = NO;
                }else if([itemInfo.order_state isEqualToString:@"30"]){//付款已发货
                     refundVC.isShowRefundType = YES;
                }
                [weakSelf.navigationController pushViewController:refundVC animated:YES];
            };
            cell = middleCell;
        }
    }
    else
    {
        if(bottomCell == nil)
            bottomCell = [CommonGoodsDetailBottomCell commonGoodsDetailBottomCell];
        
        [bottomCell setitemWithData:self.item];
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
    if (index == 0) {
        CommonOrderModel *itemInfo = self.item.order_list[0];
        RefundViewController *refundVC = [[RefundViewController alloc] init];
        refundVC.orderInfo = itemInfo;
        if ([itemInfo.order_state isEqualToString:@"20"]) {//付款未发货
            refundVC.isShowRefundType = NO;
        }else if([itemInfo.order_state isEqualToString:@"30"]){//付款已发货
            refundVC.isShowRefundType = YES;
        }
        [self.navigationController pushViewController:refundVC animated:YES];
    }
}

@end
