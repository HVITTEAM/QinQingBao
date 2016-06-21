//
//  OrderSubmitController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderSubmitController.h"
#import "OrderServiceDetailCell.h"
#import "UseCouponsViewController.h"
#import "CouponsModel.h"
#import "OrderItem.h"
#import "OrderResultViewController.h"
#import "UpdateAddressController.h"
#import "OrderTimeViewController.h"
#import "AddressTableViewController.h"
#import "OrderManCell.h"
#import "MallAddressModel.h"

#import "ServiceDetailCell.h"
#import "AddressListTotal.h"

@interface OrderSubmitController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger selectedIndex;
    
    OrderSubmitCell *orderSubmitCell;
    
    NSMutableArray *addressDataProvider;
    //代金券
    CouponsModel *couponsItem;
}
@property(nonatomic,strong)UITableView *tableView;

@property(retain,nonatomic)MallAddressModel *addressModel;

@property(strong,nonatomic)NSString *showTimestr;

@property(strong,nonatomic)NSString *uploadTimestr;

@end

@implementation OrderSubmitController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    selectedIndex = 1;
    
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initTableviewSkin];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getDataProvider];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - 50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.userInteractionEnabled=YES;
        _tableView.dataSource = self;
        _tableView.scrollsToTop=YES;
    }
    return _tableView;
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (!orderSubmitCell)
        orderSubmitCell = [OrderSubmitCell orderSubmitCell];
    __weak typeof(self) weakSelf = self;
    orderSubmitCell.payClick = ^(UIButton *button){
        [weakSelf submitClickHandler];
    };
    orderSubmitCell.serviceDetailItem = self.serviceDetailItem;
    orderSubmitCell.frame = CGRectMake(0, MTScreenH - 50, MTScreenW, 50);
    [self.view addSubview:orderSubmitCell];
}


/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"提交订单";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 0;
            break;
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if (self.addressModel) {
            static OrderManCell *orderManCell = nil;
            if (!orderManCell) {
                orderManCell = [OrderManCell createOrderManCellWithTableView:tableView];
            }
            orderManCell.nameStr = self.addressModel.true_name;
            orderManCell.phoneStr = self.addressModel.mob_phone;
            orderManCell.addressStr = [NSString stringWithFormat:@"%@%@",self.addressModel.area_info,self.addressModel.address];
            return [orderManCell setupCellUI];
        }
        
        return 44;
    }
    else if (indexPath.section == 2 && indexPath.row == 1)
        return 70;
    else if (indexPath.section == 3)
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        if (self.addressModel)
        {
            OrderManCell *orderManCell = [OrderManCell createOrderManCellWithTableView:tableView];
            orderManCell.nameStr = self.addressModel.true_name;
            orderManCell.phoneStr = self.addressModel.mob_phone;
            orderManCell.addressStr = [NSString stringWithFormat:@"%@%@",self.addressModel.area_info,self.addressModel.address];
            [orderManCell setupCellUI];
            cell = orderManCell;
        }
        else
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommoncell"];
            
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCommoncell"];
            
            commoncell.textLabel.text = @"服务对象";
            commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell = commoncell;
        }
    }
    else  if (indexPath.section == 1 && indexPath.row == 0)
    {
        UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommoncell"];
        
        if (commoncell == nil)
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCommoncell"];
        
        commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        commoncell.textLabel.text = @"预约时间";
        commoncell.detailTextLabel.text =  self.showTimestr;
        cell = commoncell;
    }
    //    else  if (indexPath.section == 3)
    //    {
    //        UITableViewCell *payTypecell = [tableView dequeueReusableCellWithIdentifier:@"MTPaytypeCell"];
    //        if (payTypecell == nil)
    //            payTypecell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTPaytypeCell"];
    //        payTypecell.textLabel.text = indexPath.row == 0 ? @"在线支付": @"货到付款";
    //
    //        if (selectedIndex == indexPath.row)
    //            payTypecell.accessoryType = UITableViewCellAccessoryCheckmark;
    //        else
    //            payTypecell.accessoryType = UITableViewCellAccessoryNone;
    //
    //        cell =  payTypecell;
    //    }
    else  if (indexPath.section == 4)
    {
        UITableViewCell *vouchercell = [tableView dequeueReusableCellWithIdentifier:@"MTVoucherCell"];
        if (vouchercell == nil)
            vouchercell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTVoucherCell"];
        vouchercell.textLabel.text = @"代金券";
        if (couponsItem)
            vouchercell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",couponsItem.voucher_price];
        else
        {
            vouchercell.detailTextLabel.text = @"暂未开通";
            vouchercell.detailTextLabel.textColor = MTNavgationBackgroundColor;
        }
        vouchercell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell =  vouchercell;
    }
    else if (indexPath.section == 3)
    {
        ServiceDetailCell *serviceDetailcell = [tableView dequeueReusableCellWithIdentifier:@"MTServiceDetailsCell"];
        if(serviceDetailcell == nil)
            serviceDetailcell = [ServiceDetailCell serviceCell];
        
        [serviceDetailcell setItemInfo:self.serviceDetailItem];
        
        cell = serviceDetailcell;
    }
    else  if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommoncell"];
            
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCommoncell"];
            
            commoncell.textLabel.text = @"服务项目";
            commoncell.detailTextLabel.text =  @"";
            
            cell = commoncell;
        }
        else
        {
            OrderServiceDetailCell *orderServiceDetailCell = [tableView dequeueReusableCellWithIdentifier:@"MTOrderServiceDetailCell"];
            
            if(orderServiceDetailCell == nil)
                orderServiceDetailCell = [OrderServiceDetailCell orderServiceDetailCell];
            
            [orderServiceDetailCell setdataWithItem:self.serviceDetailItem];
            
            cell = orderServiceDetailCell;
        }
    }
    
    //    //设置背景图片
    //    if ([tableView numberOfRowsInSection:indexPath.section] == 1)
    //        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_background.png"]];
    //    else if (indexPath.row == 0)
    //        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_background_top.png"]];
    //    else
    //        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_background_bottom.png"]];
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        __weak typeof(self) weakSelf = self;
        AddressTableViewController *vc = [[AddressTableViewController alloc] init];
        vc.selectedItem = self.addressModel;
        vc.selectedAddressModelBlock = ^(MallAddressModel *item){
            weakSelf.addressModel = item;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        __weak typeof(self)weakSelf = self;
        OrderTimeViewController *chooseTimeVC = [[OrderTimeViewController alloc] init];
        chooseTimeVC.finishTimeCallBack = ^(NSString *showTime,NSString *uploadTime){
            weakSelf.showTimestr = showTime;
            weakSelf.uploadTimestr = uploadTime;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:chooseTimeVC animated:YES];
    }
    else if (indexPath.section == 3)
    {
        UseCouponsViewController *coupons = [[UseCouponsViewController alloc] init];
        coupons.selectedClick = ^(CouponsModel *item)
        {
            NSLog(@"选择代金券");
            couponsItem = item;
            [orderSubmitCell setCouponsModel:item];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:coupons animated:YES];
    }
}

/**
 *  提交订单、前往支付
 */
-(void)submitClickHandler
{
    NSString *telNum = self.addressModel.mob_phone ?:(self.addressModel.tel_phone ?:nil);
    NSString *address = [NSString stringWithFormat:@"%@",self.addressModel.address];
    if (self.uploadTimestr.length == 0)
        return [NoticeHelper AlertShow:@"请选择预约时间" view:self.view];
    else if (self.addressModel == nil)
        return [NoticeHelper AlertShow:@"请选择服务对象" view:self.view];
    else if (!self.addressModel.true_name)
        return [NoticeHelper AlertShow:@"服务对象的真实姓名不能为空" view:self.view];
    else if (!self.addressModel.address)
        return [NoticeHelper AlertShow:@"服务地址不能为空" view:self.view];
    else if (!telNum)
        return [NoticeHelper AlertShow:@"联系号码不能为空" view:self.view];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Create_order parameters: @{@"tid" : self.serviceTypeItem.tid,
                                                                     @"iid" : self.serviceDetailItem.iid,
                                                                     @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                     @"wtime" : self.uploadTimestr,
                                                                     @"wname" : self.addressModel.true_name,
                                                                     @"wprice" : self.serviceDetailItem.price,
                                                                     @"dvcode" : self.addressModel.area_id,
                                                                     @"wtelnum" : telNum,
                                                                     @"waddress" : address,
                                                                     @"client" : @"ios",
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"wlevel" : @"1",
                                                                     @"wremark" : @"用户留言",
                                                                     @"voucher_id" : couponsItem ? couponsItem.voucher_id : @"",
                                                                     @"pay_type" : @"3",
                                                                     @"wlat" : [SharedAppUtil defaultCommonUtil].lat ? [SharedAppUtil defaultCommonUtil].lat : @"",
                                                                     @"lon" : [SharedAppUtil defaultCommonUtil].lon ? [SharedAppUtil defaultCommonUtil].lon :@""}
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
                                         OrderResultViewController *vc = [[OrderResultViewController alloc] init];
                                         vc.orderItem = item;
                                         [self.navigationController pushViewController:vc animated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"下单失败!" view:self.view];
                                     [HUD removeFromSuperview];
                                 }];
}

#pragma mark 收货地址校验和管理
/**
 *  获取当前账号的地址数据
 */
-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_Address_list parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios",
                                                                     @"page" : @100}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     AddressListTotal *result = [AddressListTotal objectWithKeyValues:dict];
                                     addressDataProvider = result.datas;
                                     [self checkAddressVaild];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                 }];
}

/**
 *  检查当前选中的地址的有效性，如果删除掉了需要作出处理
 */
-(void)checkAddressVaild
{
    if (!self.addressModel && addressDataProvider.count >0)
    {
        self.addressModel = addressDataProvider[0];
    }
    else if (self.addressModel && addressDataProvider.count >0)
    {
        BOOL find = false;
        for (MallAddressModel *item in addressDataProvider)
        {
            //之前选中的地址是否还存在，万一被删除了呢
            if ([item.address_id isEqualToString:self.addressModel.address_id])
            {
                find = YES;
                break;
            }
        }
        if (!find)
            self.addressModel = nil;
        else
            return;
    }
    else
        self.addressModel = nil;
        
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
