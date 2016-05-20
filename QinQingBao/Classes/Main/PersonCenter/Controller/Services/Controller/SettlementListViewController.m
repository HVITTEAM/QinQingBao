//
//  SettlementViewController.m
//  QinQingBao
//
//  Created by shi on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SettlementListViewController.h"
#import "HomeSettlementCell.h"
#import "PaymentViewController.h"
#import "OrderDetailViewController.h"
#import "OrderTotals.h"
#import "OrderModel.h"

@interface SettlementListViewController ()

@property(assign,nonatomic)NSInteger currentPageIdx;

@property(strong,nonatomic)NSMutableArray *dataProvider;

@property(strong,nonatomic)NSDateFormatter *formatterOut;

@property(strong,nonatomic)NSDateFormatter *formatterIn;

@end

@implementation SettlementListViewController

-(instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = HMGlobalBg;
    self.currentPageIdx = 1;
}

-(NSMutableArray *)dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[NSMutableArray alloc] init];
    }
    return _dataProvider;
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

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    self.currentPageIdx = 1;
    self.dataProvider = [[NSMutableArray alloc] init];
    [self dataRereshing];
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    HomeSettlementCell *cell = [HomeSettlementCell createHomeSettlementCellWithTableView:tableView];
    cell.cellButtonTapCallBack = ^(UIButton *tapedBtn){
        PaymentViewController *paymentVC = [[PaymentViewController alloc] init];
        OrderModel *model = weakSelf.dataProvider[indexPath.section];
//        paymentVC.orderModel = model;
        [weakSelf.nav pushViewController:paymentVC animated:YES];
    };
    
    cell.formatterIn = self.formatterIn;
    cell.formatterOut = self.formatterOut;
    
    OrderModel *model = self.dataProvider[indexPath.section];
    
    if ([self.title isEqualToString:@"未结算订单"]) {
        cell.isShowEvaluate = NO;
    }else{
        cell.isShowEvaluate = YES;
    }
    
    [cell setItem:model];
    
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *orderModel = self.dataProvider[indexPath.section];
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
    orderDetailVC.orderInfor = self.dataProvider[indexPath.section];
    [self.nav pushViewController:orderDetailVC animated:YES];
}

- (void)dataRereshing
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    if ([self.title isEqualToString:@"未结算订单"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)self.currentPageIdx],
                  @"page" : @"100",
                  @"get_type" : @"2",
                  @"status" : @"30,99",
                  @"pay_staus":@"0"
                  };
    }else if ([self.title isEqualToString:@"已结算订单"])
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"client" : @"ios",
                  @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                  @"p" : [NSString stringWithFormat:@"%li",(long)self.currentPageIdx],
                  @"page" : @"100",
                  @"get_type" : @"2",
                  @"status" : @"30,49",
                  @"pay_staus":@"1"
                  };
    }
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_workinfo_bystatus parameters: dict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     OrderTotals *result = [OrderTotals objectWithKeyValues:dict];
                                     NSLog(@"获取到%lu条数据",(unsigned long)result.datas.count);
                                     
                                     [self.tableView removePlace];
                                     if (result.datas.count == 0 && self.currentPageIdx == 1)
                                     {
                                         [self.tableView initWithPlaceString:@"暂无数据!"];
                                     }
                                     else if (result.datas.count == 0 && self.currentPageIdx > 1)
                                     {
                                         NSLog(@"没有更多的数据了");
                                         self.currentPageIdx --;
                                     }
                                     [self.dataProvider addObjectsFromArray:[result.datas copy]];
                                     [self.tableView reloadData];
                                     [self.tableView.footer endRefreshing];
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.footer endRefreshing];
                                     [HUD removeFromSuperview];
                                 }];
}



@end
