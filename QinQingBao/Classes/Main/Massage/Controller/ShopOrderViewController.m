//
//  ManipulateOrderViewController.m
//  QinQingBao
//
//  Created by shi on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ShopOrderViewController.h"
#import "LeftTitleSubTitleCell.h"
#import "ShopOrderInfoCell.h"
#import "NumPickerView.h"
#import "OrderTimeViewController.h"
#import "OrderItem.h"
#import "CustominfoViewController.h"
#import "OrderResultViewController.h"
#import "PaymentViewController.h"

@interface ShopOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *customName;
    NSString *customTel;
}

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSString *showTimestr;    //用于本地显示的时间

@property(strong,nonatomic)NSString *uploadTimestr;  //用于上传给服务器的时间（与showTimestr显示格式有区别）

@property(assign,nonatomic)NSInteger quantity;      //用户选择的数量

@end

@implementation ShopOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    
    [self getUserIcon];
}

#pragma mark - 与后台数据交互模块
/**
 *  获取用户数据数据
 */
-(void)getUserIcon
{
    [CommonRemoteHelper RemoteWithUrl:URL_GetUserInfor parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         NSLog(@"用户信息获取失败");
                                     }
                                     else
                                     {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         if ([di count] != 0)
                                         {
                                             customName = (NSString*)[di objectForKey:@"member_truename"];
                                             customTel = (NSString*)[di objectForKey:@"member_mobile"];
                                         }
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}


#pragma mark - 初始化界面
/**
 *  初始化导航栏
 */
-(void)setupUI
{
    self.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat bottomViewHeight = 60;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - bottomViewHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - bottomViewHeight, MTScreenW, bottomViewHeight)];
    [self.view addSubview:bottomView];
    
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, MTScreenW - 20, 40)];
    commitBtn.backgroundColor = HMColor(253, 125, 35);
    commitBtn.layer.cornerRadius = 8.0f;
    [commitBtn setTitle:@"提交预约" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitHandle:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:commitBtn];
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((0 == section && customName.length != 0) || 3 == section)
    {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell *cell;
    if ((0 == section && 0 == row) || 1 == section || 2 == section || (3 == section && 0 == row) ) {
        static NSString *shopOrderCommonCellId = @"shopOrderCommonCell";
        UITableViewCell *shopOrderCommonCell = [tableView dequeueReusableCellWithIdentifier:shopOrderCommonCellId];
        if (!shopOrderCommonCell) {
            shopOrderCommonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:shopOrderCommonCellId];
        }
        
        if (0 == section && 0 == row) {
            shopOrderCommonCell.textLabel.text = @"顾客信息";
            shopOrderCommonCell.detailTextLabel.text = nil;
            shopOrderCommonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (1 == section){
            shopOrderCommonCell.textLabel.text = @"预约时间";
            shopOrderCommonCell.detailTextLabel.text = self.showTimestr;
            shopOrderCommonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (2 == section){
            shopOrderCommonCell.textLabel.text = @"服务方式";
            shopOrderCommonCell.detailTextLabel.text = @"到店";
            shopOrderCommonCell.accessoryType = UITableViewCellAccessoryNone;
        }else if (3 == section && 0 == row){
            shopOrderCommonCell.textLabel.text = @"店面信息";
            shopOrderCommonCell.detailTextLabel.text =  nil;
            shopOrderCommonCell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell = shopOrderCommonCell;
        
    }else if (0 == indexPath.section && 1 == indexPath.row){
        
        LeftTitleSubTitleCell *shopOrderBuyerInforCell = [LeftTitleSubTitleCell createLeftTitleSubTitleCellWithTableView:tableView indexPath:indexPath];
        shopOrderBuyerInforCell.textLabel.text = customName;
        shopOrderBuyerInforCell.detailTextLabel.text = customTel;
        cell = shopOrderBuyerInforCell;
        
    }else if (3 == indexPath.section && 1 == indexPath.row){
        ShopOrderInfoCell *shopInfoCell = [ShopOrderInfoCell createShopOrderInfoCellWithTableView:tableView indexPath:indexPath];
        [shopInfoCell setItem:self.shopItem];
        cell = shopInfoCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (3 == indexPath.section && 1 == indexPath.row)
        return 103;
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 1)
    {
        OrderTimeViewController *chooseTimeVC = [[OrderTimeViewController alloc] init];
        chooseTimeVC.finishTimeCallBack = ^(NSString *showTime,NSString *uploadTime){
            weakSelf.showTimestr = showTime;
            weakSelf.uploadTimestr = uploadTime;
            [weakSelf.tableView reloadData];
            //NSLog(@"%@ %@",weakSelf.showTimestr,weakSelf.uploadTimestr);
        };
        [self.navigationController pushViewController:chooseTimeVC animated:YES];
    }
    else if (indexPath.section == 0)
    {
        CustominfoViewController *view = [CustominfoViewController itemWithName:customName phpne:customTel];
        view.inforClick = ^(NSString *name,NSString *telnum){
            customName = name;
            customTel = telnum;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self.navigationController pushViewController:view animated:YES];
    }
}

#pragma mark - 事件方法
/**
 *  提交预约
 */
-(void)commitHandle:(UIButton *)sender
{
    if (self.uploadTimestr.length == 0)
        return [NoticeHelper AlertShow:@"请选择预约时间" view:self.view];
    else if (customName == nil)
        return [NoticeHelper AlertShow:@"请选择预约联系人" view:self.view];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Create_order parameters: @{@"iid" : self.dataItem.iid,
                                                                     @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                     @"wtime" : self.uploadTimestr,
                                                                     @"wname" : customName,
                                                                     @"wprice" : self.dataItem.price_mem,
                                                                     @"dvcode" : self.shopItem.dvcode,
                                                                     @"wtelnum" : customTel,
                                                                     @"waddress" : self.shopItem.totalname,
                                                                     @"client" : @"ios",
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"wlevel" : @"1",
                                                                     @"wremark" : @"用户留言",
                                                                     @"voucher_id" :  @"",
                                                                     @"pay_type" : @"3",
                                                                     @"item_sum" : @"1",
                                                                     @"wlat" : [SharedAppUtil defaultCommonUtil].lat ? [SharedAppUtil defaultCommonUtil].lat : @"",
                                                                     @"wlng" : [SharedAppUtil defaultCommonUtil].lon ? [SharedAppUtil defaultCommonUtil].lon :@"",
                                                                     @"w_status" : @"5"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     OrderItem *item = [OrderItem objectWithKeyValues:[dict objectForKey:@"datas"]];
                                     if (item.wcode.length != 0)
                                     {

                                         PaymentViewController *paymentVC = [[PaymentViewController alloc] init];
                                         
                                         paymentVC.imageUrlStr = [NSString stringWithFormat:@"%@%@",URL_Img,self.dataItem.item_url];
                                         paymentVC.content = self.dataItem.iname;
                                         paymentVC.wprice = item.wprice;
                                         paymentVC.wid = item.wid;
                                         paymentVC.wcode = item.wcode;
                                         paymentVC.store_id = item.store_id;
                                         paymentVC.productName = self.dataItem.iname;
                                         
                                         NSUInteger count = self.navigationController.viewControllers.count;
                                         paymentVC.viewControllerOfback = self.navigationController.viewControllers[count -2];
                                         [self.navigationController pushViewController:paymentVC animated:YES];
                                         
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"下单失败!" view:self.view];
                                     [HUD removeFromSuperview];
                                 }];
}
@end
