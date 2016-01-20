//
//  ConfirmViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ConfirmViewController.h"
#import "ConfirmOrderEndView.h"
#import "DefaultAddressCell.h"
#import "MTCommonTextCell.h"
#import "OrderGoodsCell.h"
#import "InvoiceViewController.h"
#import "ConfirmViewController.h"
#import "UseCouponsViewController.h"
#import "AddressTableViewController.h"
#import "AddaddressInfoViewController.h"
#import "MTShoppIngCarModel.h"
#import "OrderResultModel.h"

#import "AddressListTotal.h"
#import "MallAddressModel.h"

#import "OrderSubmitSuccessViewController.h"

static CGFloat ENDVIEW_HEIGHT = 50;

@interface ConfirmViewController ()<UITableViewDataSource,UITableViewDelegate,MTConfirmOrderEndViewDelegate>
{
    NSString *invoiceStr;
    
    MallAddressModel *model;
    //    NSMutableArray *addressDataProvider;
    
    //是否从地址列表选择回来
    BOOL selectedAddress;
    
    //优惠券
    CouponsModel *couponsItem;
    
    NSString *totalPrice;
}

@property (nonatomic,strong) ConfirmOrderEndView *endView;
@property (nonatomic,strong) UITableView *tableView;

@end



@implementation ConfirmViewController


-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"确认订单";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self loadNotificationCell];
    
    self.view.backgroundColor = HMGlobalBg;
    _endView = [[ConfirmOrderEndView alloc]initWithFrame:CGRectMake(0, MTScreenH - ENDVIEW_HEIGHT, MTScreenW,ENDVIEW_HEIGHT)];
    _endView.delegate = self;
    [self.view addSubview:_endView];
    [self setEndviewValue];
    invoiceStr = @"不需要发票";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addEventListener];
    
    if (!selectedAddress)
        [self getDefaultAddress];
}

-(void)addEventListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(invoiceHandler:)
                                                 name:MTInvoiceNotification
                                               object:nil];
}

/**获取默认地址**/
-(void)getDefaultAddress
{
    NSLog(@"获取默认地址");
    if (![SharedAppUtil defaultCommonUtil].userVO )
        return;
    [CommonRemoteHelper RemoteWithUrl:URL_Address_list parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios",
                                                                     @"page" : @"1"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id addressData = [dict objectForKey:@"datas"];
                                     if ([addressData isKindOfClass:[NSArray class]])
                                     {
                                         NSArray *arr = [dict objectForKey:@"datas"];
                                         model = [MallAddressModel objectWithKeyValues:arr[0]];
                                         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                 }];
}

-(void)setGoodsArr:(NSMutableArray *)goodsArr
{
    _goodsArr = goodsArr;
    [self.tableView reloadData];
}

//设置底部数据
-(void)setEndviewValue
{
    if (self.goodsArr.count > 0 && _endView)
    {
        float num = 0.00;
        for (int j = 0; j < _goodsArr.count ; j++)
        {
            MTShoppIngCarModel *shopmodel = [_goodsArr objectAtIndex:j];
            NSInteger count = [shopmodel.count integerValue];
            float sale = [shopmodel.item_info.sale_price floatValue];
            if (shopmodel.isSelect && ![shopmodel.item_info.sale_state isEqualToString:@"3"] )
            {
                num = count*sale+ num;
            }
        }
        if (couponsItem)
            totalPrice = [NSString stringWithFormat:@"%.2f",num - [couponsItem.voucher_price floatValue]];
        else
            totalPrice = [NSString stringWithFormat:@"%.2f",num];
        
        [_endView setGoodsCount:[NSString stringWithFormat:@"%lu",(unsigned long)self.goodsArr.count] totalPrice:[NSString stringWithFormat:@"￥%.2f",[totalPrice floatValue]]];
    }
}

-(void)initTableSkin
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.backgroundColor = HMGlobalBg;
    
    [self.view addSubview:self.tableView];
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? self.goodsArr.count + 2 :1 ;
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
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
    
    DefaultAddressCell *defaultAddressCell = [tableView dequeueReusableCellWithIdentifier:@"MTDefaultAddressCell"];
    
    OrderGoodsCell *orderGoodsCell = [tableView dequeueReusableCellWithIdentifier:@"MTOrderGoodsCell"];
    
    MTCommonTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonTextCell"];
    
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if (model)
            {
                if(defaultAddressCell == nil)
                    defaultAddressCell = [DefaultAddressCell defaultAddressCell];
                defaultAddressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                [defaultAddressCell setItem:model];
                cell = defaultAddressCell;
            }
            else
            {
                if (commoncell == nil)
                    commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
                commoncell.textLabel.text = @"没有收货地址,点击新增地址";
                commoncell.imageView.image = [UIImage imageNamed:@"map"];
                commoncell.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
                commoncell.textLabel.font = [UIFont systemFontOfSize:14];
                commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell = commoncell;
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
            commoncell.textLabel.text = @"海予孝心商城";
            commoncell.imageView.image = [UIImage imageNamed:@"hyxxshop.png"];
            commoncell.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
            commoncell.textLabel.font = [UIFont systemFontOfSize:14];
            commoncell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = commoncell;
        }
        else if (indexPath.row == self.goodsArr.count + 1)
        {
            if(textCell == nil)
                textCell = [MTCommonTextCell commonTextCell];
            [textCell setItemWithTittle:@"买家留言:" placeHolder:@"选填,可填写您的备注信息"];
            cell = textCell;
        }
        else
        {
            if(orderGoodsCell == nil)
                orderGoodsCell = [OrderGoodsCell orderGoodsCell];
            
            MTShoppIngCarModel *itemInfo = self.goodsArr[indexPath.row - 1];
            [orderGoodsCell setitemWithData:itemInfo];
            cell = orderGoodsCell;
        }
    }
    else if (indexPath.section == 2)
    {
        if (commoncell == nil)
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCardsCell"];
        commoncell.textLabel.text = @"优惠券";
        commoncell.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
        commoncell.textLabel.font = [UIFont systemFontOfSize:16];
        commoncell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        commoncell.detailTextLabel.text = @"选择优惠券";
        if (couponsItem)
            commoncell.detailTextLabel.text = [NSString stringWithFormat:@"减%@",couponsItem.voucher_price];
        cell = commoncell;
    }
    else if (indexPath.section == 3)
    {
        if (commoncell == nil)
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCommonCell"];
        commoncell.textLabel.text = @"发票信息";
        commoncell.detailTextLabel.text = invoiceStr;
        commoncell.textLabel.textColor = [UIColor colorWithRGB:@"333333"];
        commoncell.textLabel.font = [UIFont systemFontOfSize:16];
        commoncell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = commoncell;
    }
    else
    {
        UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
        
        if (commoncell == nil)
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
        
        commoncell.textLabel.text = @"服务详情";
        cell = commoncell;
    }
    return cell;
}

#pragma mark - MTConfirmOrderEndViewDelegate
-(void)submitClick:(UIButton *)btn
{
    NSLog(@"去支付");
    
    if (!model)
        return [NoticeHelper AlertShow:@"请选择收货地址！" view:self.view];
    NSString *str = @"";
    if (self.fromCart)
    {
        //来自购物车
        for (int i = 0; i < self.goodsArr.count; i++)
        {
            MTShoppIngCarModel *goodsItem  = self.goodsArr[i];
            if (i == 0)
                str = [NSString stringWithFormat:@"%@|%@",goodsItem.item_id,goodsItem.count];
            else
            {
                str = [NSString stringWithFormat:@"%@,%@|%@",str,goodsItem.item_id,goodsItem.count];
            }
        }
    }
    else //来自立即购买
    {
        MTShoppIngCarModel *goodsItem  = self.goodsArr[0];
        str = [NSString stringWithFormat:@"%@|%@",goodsItem.goods_id,goodsItem.count];
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    if ([invoiceStr isEqualToString:@"不需要发票"])
    {
        
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"cart_id" : str,
                  @"client" : @"ios",
                  @"address_id" : model.address_id,
                  @"city_id" : model.city_id,
                  @"area_id" : model.area_id,
                  @"pay_name" : @"online",
#warning 暂时解决  storeid为14
                  @"voucher" : couponsItem ? [NSString stringWithFormat:@"%@|%@|%@",couponsItem.voucher_t_id,@"14",couponsItem.voucher_price] : @0,                  @"rcb_pay" : @0,
                  @"pd_pay" : @0,
                  @"ifcart" : self.fromCart ? @"1" : @"0"};
    }
    else
    {
        dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                  @"cart_id" : str,
                  @"client" : @"ios",
                  @"address_id" : model.address_id,
                  @"city_id" : model.city_id,
                  @"area_id" : model.area_id,
                  @"pay_name" : @"online",
                  @"voucher" : couponsItem ? [NSString stringWithFormat:@"%@|%@|%@",couponsItem.voucher_t_id,@"14",couponsItem.voucher_price] : @0,
                  @"rcb_pay" : @0,
                  @"pd_pay" : @0,
                  @"ifcart" : self.fromCart ? @"1" : @"0",
                  @"inv_title_select" :[invoiceStr isEqualToString:@"个人"] ? @"person" : @"company",
                  @"inv_content" :@"食品",
                  @"inv_title" :[invoiceStr isEqualToString:@"个人"] ? @"person" : invoiceStr};
    }
    
    [CommonRemoteHelper RemoteWithUrl:URL_Cart_Submit parameters: dict
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
                                         
                                         NSArray *arr = [dict objectForKey:@"datas"];
                                         OrderResultModel *result = [OrderResultModel objectWithKeyValues:arr[0]];
                                         
                                         [self orderSubmitSuccess:result];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                     [NoticeHelper AlertShow:@"网络连接出错,请重试" view:self.view];
                                     [HUD removeFromSuperview];
                                 }];
}

//订单提交成功
-(void)orderSubmitSuccess:(OrderResultModel *)item
{
    OrderSubmitSuccessViewController *buyView = [[OrderSubmitSuccessViewController alloc] init];
    buyView.orderModel = item;
    buyView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:buyView animated:YES completion:^{
        buyView.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
    
    buyView.cancelClick = ^(void)
    {
        [self.navigationController popViewControllerAnimated:YES];
    };
}


#pragma mark - 监听

-(void)invoiceHandler:(NSNotification *)notification
{
    invoiceStr = notification.object;
    [self.tableView reloadData];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (model)
        {
            AddressTableViewController *vc = [[AddressTableViewController alloc] init];
            vc.selectedAddressModelBlock = ^(MallAddressModel *item){
                NSLog(@"选中了。。。。。");
                model = item;
                selectedAddress = YES;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            AddaddressInfoViewController *addvc = [[AddaddressInfoViewController alloc] init];
            [self.navigationController pushViewController:addvc animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        //        ConfirmViewController *vc = [[ConfirmViewController alloc] init];
        //        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 2)
    {
        UseCouponsViewController *vc = [[UseCouponsViewController alloc] init];
        vc.title = @"选择优惠券";
        vc.totalPrice = totalPrice;
        if(couponsItem)
            vc.selectedModel = couponsItem;
        vc.selectedClick = ^(CouponsModel *item)
        {
            NSLog(@"选择优惠券");
            couponsItem = item;
            [self setEndviewValue];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationLeft];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 3)
    {
        InvoiceViewController *detail = [[InvoiceViewController alloc] init];
        if([invoiceStr isEqualToString:@"不需要发票"])
        {
            detail.selectedIndex = 0;
        }
        else if([invoiceStr isEqualToString:@"个人"])
        {
            detail.selectedIndex = 1;
        }
        else
        {
            detail.selectedIndex = 2;
        }
        [self.navigationController pushViewController:detail animated:YES];
    }
}


#pragma mark - 键盘处理事件

-(void)loadNotificationCell
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    if (self.view.hidden == YES)
        return;
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        CGFloat maxY = CGRectGetMaxY(sub.frame);
        if ([sub isKindOfClass:[UITableView class]])
        {
            sub.frame = CGRectMake(0, 0, sub.frame.size.width, MTScreenH -rect.size.height);
            
            CGRect rectInTableView = [_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
            
            CGRect rect = [_tableView convertRect:rectInTableView toView:[_tableView superview]];
            
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.frame.size.height/3);
        }else
        {
            if (maxY > y - 2) {
                sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.center.y - maxY + y );
            }
        }
    }
    [UIView commitAnimations];
}

- (void)keyboardShow:(NSNotification *)notif
{
    if (self.view.hidden == YES) {
        return;
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        if (sub.center.y < CGRectGetHeight(self.view.frame)/2.0) {
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0);
        }
    }
    _endView.frame = CGRectMake(0, self.view.frame.size.height-_endView.frame.size.height, MTScreenW, _endView.frame.size.height);
    
    self.tableView.frame=CGRectMake(0, 0, self.tableView.frame.size.width, MTScreenH - self.endView.height);
    [UIView commitAnimations];
}

- (void)keyboardHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
