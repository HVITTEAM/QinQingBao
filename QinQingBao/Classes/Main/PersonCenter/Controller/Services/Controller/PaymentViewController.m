//
//  PaymentViewController.m
//  QinQingBao
//
//  Created by shi on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PaymentViewController.h"
#import "UseCouponsViewController.h"
#import "OrderModel.h"
#import "CouponsModel.h"
#import "SWYSubtitleCell.h"
#import "BalanceModel.h"
#import "MassageModel.h"
#import "SMSVerificationView.h"
#import "PayResultViewController.h"

typedef NS_ENUM(NSInteger, PaymentType) {
    PaymentTypeAlipay = 1,
    PaymentTypeBalance = 6,
    PaymentTypeCoupons = 7
};

@interface PaymentViewController ()<UIAlertViewDelegate>

@property(assign,nonatomic)PaymentType payType;           //付款类型

@property(strong,nonatomic)CouponsModel *couponsModel;    //选中的代金券，未选中时为nil

@property (nonatomic, retain) NSString *balance;//账号余额

@property (nonatomic, retain) NSString *lastPrice;//最终结算金额 扣除代金券

@property (copy,nonatomic) NSString *numberOfVerification;     //验证码，余额支付时需要

@property (strong,nonatomic)UIButton *confirmBtn;   //确认按钮

@end

@implementation PaymentViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


#pragma mark - 生命周期方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 60)];
    self.confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, MTScreenW - 40,40)];
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"确认支付(￥%@)",self.lastPrice] forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmBtn.backgroundColor = HMColor(255, 126, 0);
    self.confirmBtn.layer.cornerRadius = 8.0f;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.confirmBtn addTarget:self action:@selector(payNow:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:self.confirmBtn];
    self.tableView.tableFooterView = footView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showAlert)];
    
    //设置默认选项
    self.payType = PaymentTypeAlipay;
    self.navigationItem.title = @"结算";
    [self loadBalanceData];
}

-(void)setWprice:(NSString *)wprice
{
    _wprice = wprice;
    
    //设置初始的价格
    self.lastPrice = wprice;
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 2;
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {  //顶部信息cell
        
        SWYSubtitleCell *infoCell = [SWYSubtitleCell createSWYSubtitleCellWithTableView:tableView];
        
        NSURL *iconUrl = [NSURL URLWithString:self.imageUrlStr];
        [infoCell.imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
        infoCell.textLabel.text = [NSString stringWithFormat:@"￥%@",self.wprice];
        infoCell.detailTextLabel.text = self.content;
        cell = infoCell;
        
    }else if (indexPath.section == 1){  //代金券cell
        static NSString *couponCellId = @"couponCell";
        UITableViewCell *couponCell = [tableView dequeueReusableCellWithIdentifier:couponCellId];
        if (!couponCell) {
            couponCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:couponCellId];
            couponCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            couponCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        couponCell.imageView.image = [UIImage imageNamed:@"paytype_coup"];
        couponCell.textLabel.text = @"代金券";
        couponCell.detailTextLabel.text = @"立即使用";
        couponCell.detailTextLabel.textColor = [UIColor orangeColor];
        couponCell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        if (self.couponsModel)
        {
            couponCell.detailTextLabel.text = [NSString stringWithFormat:@"-%@元",self.couponsModel.voucher_price];
        }
        
        cell = couponCell;
        
    }else if (indexPath.section == 2){  //支付类型cell
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.highlightedImage = [UIImage imageNamed:@"ic_cb_checked.png"];
        imgView.image = [UIImage imageNamed:@"ic_cb_normal.png"];
        
        static NSString *paytypeCellId = @"paytypeCell";
        UITableViewCell *paytypeCell = [tableView dequeueReusableCellWithIdentifier:paytypeCellId];
        if (!paytypeCell)
        {
            paytypeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:paytypeCellId];
            paytypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.couponsModel)//如果选择了代金券  其他方式不允许支付
            paytypeCell.accessoryView = nil;
        else
            paytypeCell.accessoryView = imgView;
        
        if (indexPath.row == 0)
        {
            [self setPayTypeCell:paytypeCell
                         payType:PaymentTypeAlipay
                           title:@"支付宝支付"
                        subTitle:@"推荐有支付宝帐号的用户使用"
                           image:[UIImage imageNamed:@"paytype_ali"]];
        }
        else
        {
            if ([self.lastPrice floatValue] <= [self.balance floatValue])//可以支付
            {
                [self setPayTypeCell:paytypeCell
                             payType:PaymentTypeBalance
                               title:@"余额支付"
                            subTitle:[NSString stringWithFormat:@"余额:%@元,可以支付",self.balance]
                               image:[UIImage imageNamed:@"paytype_yue"]];
            }
            else
            {
                [self setPayTypeCell:paytypeCell
                             payType:PaymentTypeBalance
                               title:@"余额支付"
                            subTitle:[NSString stringWithFormat:@"余额:%@元,不可支付",self.balance]
                               image:[UIImage imageNamed:@"paytype_yue"]];
            }
        }
        cell = paytypeCell;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 85;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //跳转到代金券使用界面
        __weak typeof(self) weakSelf = self;
        UseCouponsViewController *useCouponVC = [[UseCouponsViewController alloc] init];
        useCouponVC.store_id = self.store_id;
        useCouponVC.totalPrice = self.wprice;
        useCouponVC.selectedModel = self.couponsModel;
        useCouponVC.selectedClick = ^(CouponsModel *item){
            weakSelf.couponsModel = item;
            CGFloat servicePrice = [weakSelf.wprice floatValue];
            CGFloat couponPrice = 0;
            if (weakSelf.couponsModel)
            {
                //当前需求是：选择了代金券其他方式就不允许支付了。
                self.payType = PaymentTypeCoupons;
                if (servicePrice >= [self.couponsModel.voucher_limit floatValue]) {
                    couponPrice = [self.couponsModel.voucher_price floatValue];
                }
            }
            weakSelf.lastPrice = [NSString stringWithFormat:@"%.2f",servicePrice - couponPrice];
            [self.confirmBtn setTitle:[NSString stringWithFormat:@"确认支付(￥%@)",self.lastPrice] forState:UIControlStateNormal];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:useCouponVC animated:YES];
        
    }else if (indexPath.section == 2) {
        //如果结算方式不能更改就不允许点击
        if ([self.lastPrice floatValue] > [self.balance floatValue])
            return;
        else if ([SharedAppUtil defaultCommonUtil].userVO.member_mobile.length == 0)
        {
            UIAlertView *mobile_alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的账号未绑定手机号码,不能使用余额支付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
            mobile_alert.tag = 100;
            [mobile_alert show];
        }
        switch (indexPath.row) {
            case 0:
                self.payType = PaymentTypeAlipay;
                break;
            case 1:
                self.payType = PaymentTypeBalance;
                break;
            default:
                self.payType = PaymentTypeCoupons;
                break;
        }
        
        [self.tableView reloadData];
    }
}


#pragma mark - 网络相关方法
/**
 *  获取余额相关信息包括使用记录
 */
-(void)loadBalanceData
{
    NSDictionary *params = @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client" : @"ios",
                             @"curpage":@"1",
                             @"page":@"1"};
    [CommonRemoteHelper RemoteWithUrl:URL_get_member_blance parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:@"未获取到余额数据" view:self.view];
        }else{
            BalanceModel *balanceMD = [BalanceModel objectWithKeyValues:dict[@"datas"]];
            self.balance = balanceMD.available_rc_balance;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请示失败" view:self.view];
    }];
}


/**
 *  确认支付按钮被点击时调用
 */
-(void)payNow:(UIButton *)sender
{
    [self selectTypeToPay];
}

/**
 *  选择支付方式支付
 */
-(void)selectTypeToPay
{
    switch (self.payType)
    {
        case PaymentTypeAlipay:
        {
            [self payWithAliPayWitTradeNO:self.wcode
                              productName:self.productName
                                   amount:self.lastPrice
                       productDescription:self.content];
        }
            break;
        case PaymentTypeBalance:
        {
            __weak typeof(self) weakSelf = self;
            UIWindow *wd = [UIApplication sharedApplication].keyWindow;
            SMSVerificationView *verificationView = [SMSVerificationView showSMSVerificationViewToView:wd];
            verificationView.phoneNum = [SharedAppUtil defaultCommonUtil].userVO.member_mobile;
            verificationView.tapConfirmBtnCallBack = ^(NSString *safeNum){
                weakSelf.numberOfVerification = safeNum;
                [weakSelf payResultHandel];
            };
        }
            break;
        case PaymentTypeCoupons:
        {
            [self payResultHandel];
        }
            break;
        default:
            break;
    }
}

/**
 *  调用支付接口支付
 */
-(void)payWithAliPayWitTradeNO:(NSString *)tradeNo
                   productName:(NSString *)productName
                        amount:(NSString *)productPrice
            productDescription:(NSString *)productDesc
{
    [MTPayHelper payWithAliPayWitTradeNO:tradeNo productName:productName amount:productPrice productDescription:productDesc notifyURL:URL_AliPay_Service success:^(NSDictionary *dict, NSString *signedString) {
        
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
                    
                    if (self.doneHandlerClick) {
                        self.doneHandlerClick();
                    }
                    [self payResultHandel];
                }
            }
        }
    } failure:^(NSDictionary *dict) {
        [NoticeHelper AlertShow:@"支付失败，请稍后再试" view:self.view];
    }];
}

/**
 *  支付成功之后,更改状态
 *  支付方式 1支付宝2 微信 3现金 4POS机支付 5店长代付6 余额支付 7代金券支付
 */
-(void)payResultHandel
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [@{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"client" : @"ios",
                                     @"wid" : self.wid,
                                     @"pay_type" : [NSString stringWithFormat:@"%ld",(long)self.payType]
                                     }mutableCopy];
    
    [params setValue:self.couponsModel ? self.couponsModel.voucher_id : nil forKey:@"voucher_id"];
    [params setValue:self.payType == PaymentTypeBalance?self.numberOfVerification:nil forKey:@"code"];
    
    [CommonRemoteHelper RemoteWithUrl:URL_pay_workinfo_by_type
                           parameters:params
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
                                         [NoticeHelper AlertShow:@"支付成功!" view:nil];
                                         if (self.doneHandlerClick) {
                                             self.doneHandlerClick();
                                         }
                                         
                                         PayResultViewController *payResultVC = [[PayResultViewController alloc] init];
                                         payResultVC.wid = self.wid;
                                         payResultVC.navigationItem.hidesBackButton = YES;
                                         [self.navigationController pushViewController:payResultVC animated:YES];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [NoticeHelper AlertShow:@"支付结果验证出错了...." view:self.view];
                                     [HUD removeFromSuperview];
                                 }];
}

/**
 *  手动退出界面时做出判断
 */
-(void)showAlert
{
    if (self.viewControllerOfback)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否确定退出结算？退出后可在我的服务中继续支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
        [alertView show];
    }else
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (alertView.tag == 100)
        {
            //TODO 去绑定
        }
        else
        {
            [self.navigationController popToViewController:self.viewControllerOfback animated:YES];
        }
    }
    
}

#pragma mark - 工具方法
/**
 *  设置付款类型cell的数据
 */
-(void)setPayTypeCell:(UITableViewCell *)cell
              payType:(PaymentType)payType
                title:(NSString *)titleStr
             subTitle:(NSString *)subTitleStr
                image:(UIImage *)aImage
{
    cell.textLabel.text = titleStr;
    cell.detailTextLabel.text = subTitleStr;
    cell.imageView.image = aImage;
    if (self.payType == payType) {
        ((UIImageView *)cell.accessoryView).highlighted = YES;
    }
}

@end

