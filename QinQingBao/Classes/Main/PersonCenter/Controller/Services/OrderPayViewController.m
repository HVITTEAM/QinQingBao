//
//  OrderPayViewController.m
//  QinQingBao
//
//  Created by shi on 16/3/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "OrderPayViewController.h"
#import "OrderModel.h"
#import "EvaluateCell.h"
#import "PaySettlementCell.h"
#import "UseCouponsViewController.h"

#define kSellerAccount @"ofc.er@hvit.com.cn"

typedef NS_ENUM(NSInteger, PayType) {
    PayTypeAlipay = 1,
    PayTypeWeChat,
    PayTypeCash
};

@interface OrderPayViewController ()<EvaluateCellDelegate>

@property(assign,nonatomic)PayType payType;                //付款类型

@property(copy,nonatomic)NSString *evaluateContent;       //评价内容

@property(assign,nonatomic)NSInteger score;               //评分

@property(strong,nonatomic)CouponsModel *selectedCoupon;    //选中的优惠券

@end

@implementation OrderPayViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    return self;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 60)];
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, MTScreenW - 40,40)];
    [confirmBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = HMColor(255, 126, 0);
    confirmBtn.layer.cornerRadius = 8.0f;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn addTarget:self action:@selector(payNow:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:confirmBtn];
    self.tableView.tableFooterView = footView;
    
    self.payType = PayTypeAlipay;
    self.score = 5;
    self.evaluateContent = @"默认好评";
    
    self.navigationItem.title = @"订单支付";
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row != 0) {
        PaySettlementCell *paySettlementCell = [PaySettlementCell createPaySettlementCellWithTableView:tableView];
        [paySettlementCell setDataWithOrderModel:self.orderInfor couponsModel:self.selectedCoupon];
        __weak typeof(self)weakSelf = self;
        paySettlementCell.couponHandle = ^{
            UseCouponsViewController *couponsVC = [[UseCouponsViewController alloc] init];
            couponsVC.totalPrice = weakSelf.orderInfor.wprice;
            //如果选择了优惠券
            if (weakSelf.selectedCoupon)
                couponsVC.selectedModel = weakSelf.selectedCoupon;
            couponsVC.selectedClick = ^(CouponsModel *item){
                weakSelf.selectedCoupon = item;
                [weakSelf.tableView reloadData];
            };
            [weakSelf.navigationController pushViewController:couponsVC animated:YES];
        };
        return paySettlementCell;
        
    }else if (indexPath.section == 1 && indexPath.row != 0){
        static NSString *payTypeCellId = @"payTypeCell";
        UITableViewCell *payTypeCell = [tableView dequeueReusableCellWithIdentifier:payTypeCellId];
        if (!payTypeCell) {
            payTypeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:payTypeCellId];
            UIImageView *indicateIconView = [[UIImageView alloc] initWithFrame:CGRectMake(MTScreenW - 45, 15 , 20, 20)];
            indicateIconView.image = [UIImage imageNamed:@"checkPayType"];
            indicateIconView.hidden = YES;
            indicateIconView.tag = 100;
            [payTypeCell.contentView addSubview:indicateIconView];
            
            payTypeCell.textLabel.font = [UIFont systemFontOfSize:14];
            
            payTypeCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
            [payTypeCell setLayoutMargins:UIEdgeInsetsZero];
            
            payTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 1) {
            [self setPayTypeCell:payTypeCell payType:PayTypeWeChat title:@"微信支付"];
        }else if (indexPath.row == 2){
            [self setPayTypeCell:payTypeCell payType:PayTypeAlipay title:@"支付宝支付"];
        }else if (indexPath.row == 3){
            [self setPayTypeCell:payTypeCell payType:PayTypeCash title:@"现金支付"];
        }
        
        return payTypeCell;
        
    }else if ((indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) && indexPath.row == 0){
        static NSString *titleCellId = @"titleCell";
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
        if (!titleCell) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:titleCellId];
            titleCell.separatorInset = UIEdgeInsetsZero;
            [titleCell setLayoutMargins:UIEdgeInsetsZero];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 0) {
            titleCell.textLabel.text = @"服务结算";
        }else if (indexPath.section == 1) {
            titleCell.textLabel.text = @"支付方式";
        }else{
            titleCell.textLabel.text = @"服务评价";
        }
        return titleCell;
    }else{
        EvaluateCell *evaluateCell = [EvaluateCell createEvaluateCellWithTableView:tableView];
        evaluateCell.delegate = self;
        return evaluateCell;
    }
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 100;
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        return 160;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row != 0) {
        if (indexPath.row !=2) {
            [NoticeHelper AlertShow:@"目前仅支持支付宝支付" view: self.view];
            return;
        }
        switch (indexPath.row) {
            case 1:
                self.payType = PayTypeWeChat;
                break;
            case 2:
                self.payType = PayTypeAlipay;
                break;
            case 3:
                self.payType = PayTypeCash;
                break;
            default:
                self.payType = PayTypeAlipay;
                break;
        }
        [self.tableView reloadData];
    }
}

#pragma mark EvaluateCellDelegate
-(void)evaluateCell:(EvaluateCell *)cell didEvaluateContentChange:(NSString *)newContent
{
    self.evaluateContent = newContent;
}

-(void)evaluateCell:(EvaluateCell *)cell evaluateScore:(NSInteger)score
{
    self.score = score;
}

#pragma mark ---- 网络相关方法 ------
/**
 *  确认支付按钮被点击时调用
 */
-(void)payNow:(UIButton *)sender
{
    if ((self.orderInfor.voucher_id && self.orderInfor.voucher_price) || !self.selectedCoupon) {
        
        [self payWithAliPayWitTradeNO:self.orderInfor.wcode
                          productName:self.orderInfor.tname
                               amount:self.orderInfor.wprice
                   productDescription:self.orderInfor.icontent];
        return;
    }
    
    [self editVoucher];
}

/**
 *  调用支付接口支付
 */
-(void)payWithAliPayWitTradeNO:(NSString *)tradeNo
                   productName:(NSString *)productName
                        amount:(NSString *)productPrice
            productDescription:(NSString *)productDesc
{
    [MTPayHelper payWithAliPayWitTradeNO:tradeNo productName:productName amount:productPrice productDescription:productDesc success:^(NSDictionary *dict, NSString *signedString) {
        
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
                    //NSLog(@"%@",[strArray objectAtIndex:1]);
                    out_trade_no = [strArray objectAtIndex:1];
                }
                else if ([st isEqualToString:@"sign"])
                {
                    //NSLog(@"%@",[strArray objectAtIndex:1]);
                    sign = [strArray objectAtIndex:1];
                    [self api_alipay:out_trade_no pay_sn:self.orderInfor.wid signedString:sign total_fee:productPrice];
                }
            }
        }
        
    } failure:^(NSDictionary *dict) {
        [NoticeHelper AlertShow:@"支付失败，请稍后再试" view:self.view];
    }];
}


/**
 *  支付宝付款后的订单状态修改
 */
-(void)api_alipay:(NSString *)out_trade_no
           pay_sn:(NSString *)pay_sn
     signedString:(NSString *)signedString
        total_fee:(NSString *)totalfee
{
    NSDictionary *params = @{
                             @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client" : @"ios",
                             @"wid" : pay_sn,
                             @"sign" : signedString,
                             @"out_trade_no" : out_trade_no,
                             @"total_fee" :totalfee,
                             @"seller_id" : kSellerAccount
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_pay_workinfo_status
                           parameters:params
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         [self submitEvaluate];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [NoticeHelper AlertShow:@"支付结果验证出错了...." view:self.view];
                                 }];
}

/**
 *  提交评论
 */
-(void)submitEvaluate
{
    NSDictionary *dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                            @"client" : @"ios",
                            @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                            @"wid":self.orderInfor.wid,
                            @"cont":self.evaluateContent,
                            @"grade":@(self.score)
                            };
    [CommonRemoteHelper RemoteWithUrl:URL_Save_dis_cont parameters:dict type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if ([dict[@"code"] integerValue] == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"评论提交失败" view:self.view];
    }];
}

/**
 *  锁定优惠券
 */
-(void)editVoucher
{
    NSDictionary *dict =  @{ @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client" : @"ios",
                             @"wid":self.orderInfor.wid,
                             @"voucher_id":self.selectedCoupon.voucher_id};
    [CommonRemoteHelper RemoteWithUrl:URL_edit_voucher parameters:dict type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if ([dict[@"code"] integerValue] == 0) {
            //优惠券锁定成功
            CGFloat servicePrice = [self.orderInfor.wprice floatValue];
            CGFloat couponPrice = 0;
            if (self.selectedCoupon) {
                if (servicePrice >= [self.selectedCoupon.voucher_limit floatValue]) {
                    couponPrice = [self.selectedCoupon.voucher_price floatValue];
                }
            }
            
            NSString *lastPrice = [NSString stringWithFormat:@"%.2f",servicePrice - couponPrice];
            
            [self payWithAliPayWitTradeNO:self.orderInfor.wcode
                              productName:self.orderInfor.tname
                                   amount:lastPrice
                       productDescription:self.orderInfor.icontent];
        }else{
            [NoticeHelper AlertShow:@"优惠券使用失败！" view:self.view];
//            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"优惠券锁定失败" view:self.view];
    }];
}

#pragma mark ---- 工具方法 ------
/**
 *  设置付款类型cell的数据
 */
-(void)setPayTypeCell:(UITableViewCell *)cell payType:(PayType)payType title:(NSString *)aString
{
    UIImageView *iconView = [cell viewWithTag:100];
    cell.textLabel.text = aString;
    if (self.payType == payType) {
        iconView.hidden = NO;
    }else{
        iconView.hidden = YES;
    }
}

@end
