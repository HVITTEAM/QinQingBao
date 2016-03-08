//
//  RefundGoodsListController.m
//  QinQingBao
//
//  Created by shi on 16/2/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RefundGoodsListController.h"
#import "RefundListTotal.h"
#import "RefundListModel.h"
#import "CommonGoodsCellHead.h"
#import "CommonGoodsCellMiddle.h"
#import "RefundCellBottom.h"
#import "RefundDetailViewController.h"

@interface RefundGoodsListController ()
{
    RefundListModel*selectedDeleteOrder;
    NSIndexPath * selectedIndexPath;
}

@property(assign,nonatomic)NSInteger nextPage;                    //下一页

@property(assign,nonatomic)BOOL isMoreData;                       //指示是否还有数据

@property(strong,nonatomic)NSMutableArray *dataProvider;         //数据源

@property(assign,nonatomic)BOOL isLoading;                       //指示是否正在向服务器请求数据

@end

@implementation RefundGoodsListController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    self.hidesBottomBarWhenPushed = YES;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPageRefundListData)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HMGlobalBg;
    
    [self loadFirstPageRefundListData];
}

#pragma  mark -- 协议方法 --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundListModel *model = self.dataProvider[indexPath.section];
    
    
    if (indexPath.row == 0) {
        //头部
        CommonGoodsCellHead *headcell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonGoodsCellHead"];
        if (!headcell) {
            headcell = [CommonGoodsCellHead commonGoodsCellHead];
        }
        [headcell setItemWithRefundData:model];
        return headcell;
    }else if (indexPath.row == 2){
        //底部
        RefundCellBottom *bottomcell = [RefundCellBottom refundCellBottomWithTableView:tableView];
        bottomcell.refundAmountLb.text = model.refund_amount;
        bottomcell.descLb.text = [NSString stringWithFormat:@"共%@件商品 合计￥%@",model.goods_num,model.refund_amount];
        [bottomcell setItemWithRefundData:model];
        bottomcell.buttonClick = ^(UIButton *btn)
        {
            [self buttonClickHandler:btn item:model indexPath:indexPath];
        };
        return bottomcell;
    }else{
        //中间商品底部
        CommonGoodsCellMiddle *goodscell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonGoodsCellMiddle"];
        if(!goodscell)
            goodscell = [CommonGoodsCellMiddle commonGoodsCellMiddle];
        [goodscell setItemWithRefundData:model];
        return goodscell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到退款详情界面
    RefundListModel *model = self.dataProvider[indexPath.section];
    RefundDetailViewController *refundDetailVC = [[RefundDetailViewController alloc] init];
    refundDetailVC.refundId = model.refund_id;
//    refundDetailVC.title = model.goods_name;
    [self.nav pushViewController:refundDetailVC animated:YES];
}

#pragma  mark -- 网络相关方法 --
/**
 *  加载第一页数据
 */
-(void)loadFirstPageRefundListData
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    self.nextPage = 1;
    NSDictionary *params = @{
                             @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client":@"ios",
                             @"page":@10,
                             @"curpage":@(self.nextPage)
                             };
    self.isLoading = YES;
    [CommonRemoteHelper RemoteWithUrl:URL_refund_return_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [HUD removeFromSuperview];
        self.isLoading = NO;
        if ([dict[@"code"] integerValue] == 17001) {
            [self.tableView initWithPlaceString:@"暂无数据"];
        }else if ([dict[@"code"] integerValue] == 0){
            RefundListTotal *listTotal = [RefundListTotal objectWithKeyValues:dict];
            self.dataProvider = listTotal.datas;
            if (self.dataProvider.count == 0) {
                [self.tableView initWithPlaceString:@"暂无数据"];
            }
            self.isMoreData = [listTotal.hasmore boolValue];
            [self.tableView reloadData];
            //设置下一页的页号
            self.nextPage ++;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isLoading = NO;
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"数据请求不成功" view:self.view];
    }];
}

/**
 *  加载下一页数据
 */
-(void)loadNextPageRefundListData
{
    //如果已经在请求数据就不再发送请求
    if (self.isLoading) {
        [self.tableView.footer endRefreshing];
        return;
    }
    
    //没有更多数据不再发送请求
    if (!self.isMoreData) {
        [self.tableView.footer endRefreshing];
        [self.view showNonedataTooltip];
        return;
    }
    
    NSDictionary *params = @{@"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client":@"ios",
                             @"page":@10,
                             @"curpage":@(self.nextPage)};
    self.isLoading = YES;
    [CommonRemoteHelper RemoteWithUrl:URL_refund_return_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        self.isLoading = NO;
        //结束上拉刷新
        [self.tableView.footer endRefreshing];
        
        if ([dict[@"code"] integerValue] == 17001)
        {
            [self.view showNonedataTooltip];
            //                [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
        else if ([dict[@"code"] integerValue] == 0){
            
            RefundListTotal *listTotal = [RefundListTotal objectWithKeyValues:dict];
            [self.dataProvider addObjectsFromArray:listTotal.datas];
            self.isMoreData = [listTotal.hasmore boolValue];
            [self.tableView reloadData];
            //设置下一页的页号
            self.nextPage ++;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isLoading = NO;
        //结束上拉刷新
        [self.tableView.footer endRefreshing];
        [NoticeHelper AlertShow:@"数据请求不成功" view:self.view];
    }];
}

#pragma mark  订单操作模块

/**操作按钮对应点击事件**/
-(void)buttonClickHandler:(UIButton *)btn item:(RefundListModel*)item indexPath:(NSIndexPath *)indexPath
{
    if ([btn.titleLabel.text isEqualToString:@"删除订单"])
    {
        [self deleteOrder:item indexPath:indexPath];
    }
    else if ([btn.titleLabel.text isEqualToString:@"退款详情"])
    {
        //跳转到退款详情界面
        RefundListModel *model = self.dataProvider[indexPath.section];
        RefundDetailViewController *refundDetailVC = [[RefundDetailViewController alloc] init];
        refundDetailVC.refundId = model.refund_id;
        refundDetailVC.title = model.goods_name;
        [self.nav pushViewController:refundDetailVC animated:YES];
    }
}

//删除订单
-(void)deleteOrder:(RefundListModel*)item indexPath:(NSIndexPath *)indexPath
{
    selectedDeleteOrder = item;
    selectedIndexPath = indexPath;
    UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除订单？删除后将无法恢复订单。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    deleteAlertView.tag = 200;
    [deleteAlertView show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view.window.rootViewController.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_Del_order parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                      @"client" : @"ios",
                                                                      @"order_id" : selectedDeleteOrder.order_id}
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
                                             [self.dataProvider removeObject:self.dataProvider[selectedIndexPath.section]];
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

@end
