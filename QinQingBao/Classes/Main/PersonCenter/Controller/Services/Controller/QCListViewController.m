//
//  QCListViewController.m
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//

#import "QCListViewController.h"
#import "OrderModel.h"
#import "OrderTotals.h"
//#import "OrderDetailController.h"
#import "OrderDetailViewController.h"
#import "OrderPayViewController.h"
#import "OrderDetailCancelViewController.h"
#import "PaymentViewController.h"

#import "EvaluationViewController.h"
#import "OrderRefundViewController.h"

@interface QCListViewController ()<UIActionSheetDelegate>
{
    NSMutableArray *dataProvider;
    NSInteger currentPageIdx;
}

@property(strong,nonatomic)NSDateFormatter *formatterOut;

@property(strong,nonatomic)NSDateFormatter *formatterIn;

@end

@implementation QCListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
    
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    currentPageIdx = 1;
    dataProvider = [[NSMutableArray alloc] init];
    [self dataRereshing];
}


/** 屏蔽tableView的样式 */
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 10;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, -25, 0);
    
}

-(NSDateFormatter *)formatterOut
{
    if (!_formatterOut) {
        _formatterOut = [[NSDateFormatter alloc] init];
        [_formatterOut setDateFormat:@"yyyy年MM月dd日 EEEE aa"];
    }
    return _formatterOut;
}


-(NSDateFormatter *)formatterIn
{
    if (!_formatterIn) {
        _formatterIn = [[NSDateFormatter alloc] init];
        [_formatterIn setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _formatterIn;
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 上拉刷新
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentPageIdx ++ ;
        [self dataRereshing];
    }];
}

#pragma mark 开始进入刷新状态
- (void)dataRereshing
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    if ([self.title isEqualToString:@"全部"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"page" : @"100",
                  @"get_type" : @"2",
                  @"status" : @"0,119"
                  };
    }
    else if ([self.title isEqualToString:@"待服务"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"page" : @"100",
                  @"get_type" : @"2",
                  @"status" : @"0,29",
                  @"pay_staus":@"1"
                  };
    }
    else if ([self.title isEqualToString:@"待付款"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"page" : @"100",
                  @"get_type" : @"2",
                  @"status" : @"0,9",
                  @"pay_staus":@"0"
                  };
    }
    else if ([self.title isEqualToString:@"待退款"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"page" : @"100",
                  @"get_type" : @"2",
                  @"status" : @"0,49",
                  @"pay_staus":@"2"
                  };
    }
    else if ([self.title isEqualToString:@"待评价"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"page" : @"100",
                  @"get_type" : @"2",
                  @"status" : @"30,39"
                  };
    }
    [CommonRemoteHelper RemoteWithUrl:URL_Get_workinfo_bystatus parameters: dict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     OrderTotals *result = [OrderTotals objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     
                                     NSLog(@"----+++++---%@",responseObject);
                                     [self.tableView removePlace];
                                     if (result.datas.count == 0 && currentPageIdx == 1)
                                     {
                                         [self.tableView initWithPlaceString:@"暂无数据!"];
                                     }
                                     else if (result.datas.count == 0 && currentPageIdx > 1)
                                     {
                                         NSLog(@"没有更多的数据了");
                                         currentPageIdx --;
                                         self.noneResultHandler();
                                     }
                                     [dataProvider addObjectsFromArray:[result.datas copy]];
                                     [self.tableView reloadData];
                                     [self.tableView.footer endRefreshing];
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.footer endRefreshing];
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark - 表格视图数据源代理方法

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
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
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonOrderCell"];
    if (cell == nil)
        cell = [CommonOrderCell commonOrderCell];
    
    cell.deleteClick = ^(UIButton *btn){
        [self deleteOrderClickHandler:indexPath btn:btn];
    };
    cell.formatterIn = self.formatterIn;
    cell.formatterOut = self.formatterOut;
    [cell setItem:dataProvider[indexPath.section]];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *orderModel = dataProvider[indexPath.section];
    
    NSInteger orderStatus = [orderModel.status integerValue];
    
    if (orderStatus >= 50 && orderStatus <= 69) {
        OrderDetailCancelViewController *cancelVC = [[OrderDetailCancelViewController alloc] init];
        cancelVC.orderInfor = dataProvider[indexPath.section];
        [self.nav pushViewController:cancelVC animated:YES];
        return;
    }
    
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
    orderDetailVC.orderInfor = dataProvider[indexPath.section];
    [self.nav pushViewController:orderDetailVC animated:YES];
}

/**
 *  取消工单
 *
 *  @param indexPath <#indexPath description#>
 */
-(void)deleteOrderClickHandler:(NSIndexPath *)indexPath btn:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"取消"])
    {
        CancelOrderController *cancelView  = [[CancelOrderController alloc]init];
        cancelView.orderItem = dataProvider[indexPath.section];
        cancelView.doneHandlerClick = ^(void){
            [self viewDidCurrentView];
        };
        [self.nav pushViewController:cancelView animated:YES];
    }
    else if ([btn.titleLabel.text isEqualToString:@"去支付"])
    {
        PaymentViewController *paymentVC = [[PaymentViewController alloc] init];
        OrderModel *model = dataProvider[indexPath.section];
        paymentVC.imageUrlStr = [NSString stringWithFormat:@"%@%@",URL_Img,model.item_url];
        paymentVC.content = model.icontent;
        paymentVC.wprice = model.wprice;
        paymentVC.wid = model.wid;
        paymentVC.wcode = model.wcode;
        paymentVC.store_id = model.store_id;
        paymentVC.productName = model.icontent;
        [self.nav pushViewController:paymentVC animated:YES];
    }
    else if ([btn.titleLabel.text isEqualToString:@"联系商家"] || [btn.titleLabel.text isEqualToString:@"投诉"])
    {
        NSURL *url = [NSURL URLWithString:@"telprompt://4001512626"];
        [[UIApplication sharedApplication] openURL:url];
    }
    else if ([btn.titleLabel.text isEqualToString:@"申请退款"])
    {
        OrderRefundViewController *refundVC = [[OrderRefundViewController alloc] init];
        OrderModel *model = dataProvider[indexPath.section];
        refundVC.orderModel = model;
        [self.nav pushViewController:refundVC animated:YES];
    }
    else if ([btn.titleLabel.text isEqualToString:@"评价"])
    {
        EvaluationViewController *evaluationVC = [[EvaluationViewController alloc] init];
        OrderModel *model = dataProvider[indexPath.section];
        evaluationVC.orderModel = model;
        [self.nav pushViewController:evaluationVC animated:YES];
    }
}


/**
 *  回调方法
 *
 *  @param indexPath indexPath description
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //KVO
    [self setValue:@"0" forKey:@"needFlesh"];
    [self addObserver:self forKeyPath:@"needFlesh" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    if([keyPath isEqualToString:@"needFlesh"])
    {
        [self dataRereshing];
    }
}

//- (void)callHandler:
//{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"联系电话"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"客服电话:96345",[NSString stringWithFormat:@"商家固话:%@",_itemInfo.orgtelnum],
//                                  _itemInfo.orgphone ? [NSString stringWithFormat:@"商家手机:%@",_itemInfo.orgphone] : nil,nil];
//    [actionSheet showInView:self];
//
//}
//
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSURL *url;
//    switch (buttonIndex)
//    {
//        case 0:
//            url = [NSURL URLWithString:@"telprompt://96345"];
//            break;
//        case 1:
//            url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_itemInfo.orgtelnum]];
//            break;
//        case 2:
//            url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_itemInfo.orgphone]];
//            break;
//        default:
//            break;
//    }
//    [[UIApplication sharedApplication] openURL:url];
//
//}


@end
