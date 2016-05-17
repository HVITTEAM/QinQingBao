//
//  PaymentViewController.m
//  QinQingBao
//
//  Created by shi on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PaymentViewController.h"
#import "EvaluateCell.h"
#import "UseCouponsViewController.h"
#import "OrderModel.h"
#import "CouponsModel.h"
#import "SWYSubtitleCell.h"
#import "BalanceModel.h"

typedef NS_ENUM(NSInteger, PaymentType) {
    PaymentTypeAlipay = 1,
    PaymentTypeBalance = 6,
    PaymentTypeCoupons = 7
};

@interface PaymentViewController ()<EvaluateCellDelegate>

@property(assign,nonatomic)PaymentType payType;           //付款类型

@property(copy,nonatomic)NSString *evaluateContent;       //评价内容

@property(assign,nonatomic)NSInteger score;               //评分

@property(strong,nonatomic)CouponsModel *couponsModel;    //选中的优惠券，未选中时为nil

@property (nonatomic, retain) NSString *balance;//账号余额

@property (nonatomic, retain) NSString *lastPrice;//最终结算金额 扣除优惠券

@end

@implementation PaymentViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    //设置默认选项
    self.payType = PaymentTypeAlipay;
    self.score = 5;
    self.evaluateContent = @"默认好评";
    self.navigationItem.title = @"订单支付";
    [self loadBalanceData];
}

-(void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    
    //设置初始的价格
    self.lastPrice = self.orderModel.wprice;
}
#pragma mark - 网络相关
/**
 *  获取余额相关信息包括使用记录
 */
-(void)loadBalanceData
{
    NSDictionary *params = @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client" : @"ios",
                             @"curpage":@"1",
                             @"page":@"50"};
    [CommonRemoteHelper RemoteWithUrl:URL_get_member_blance parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:@"未获取到数据" view:self.view];
        }else{
            BalanceModel *balanceMD = [BalanceModel objectWithKeyValues:dict[@"datas"]];
            self.balance = balanceMD.available_rc_balance;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请示失败" view:self.view];
    }];
}


#pragma mark - 协议方法
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
    if (indexPath.section == 0) {  //顶部信息cell
        
        SWYSubtitleCell *infoCell = [SWYSubtitleCell createSWYSubtitleCellWithTableView:tableView];
        NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,self.orderModel.item_url]];
        [infoCell.imageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
        infoCell.textLabel.text = [NSString stringWithFormat:@"￥%@",self.orderModel.wprice];
        infoCell.detailTextLabel.text = self.orderModel.tname;
        infoCell.imageView.backgroundColor = [UIColor redColor];
        return infoCell;
        
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
        
        return couponCell;
        
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
        return paytypeCell;
        
    }else{
        //评价cell
        EvaluateCell *evaluateCell = [EvaluateCell createEvaluateCellWithTableView:tableView];
        evaluateCell.delegate = self;
        return evaluateCell;
    }
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 85;
    }else if (indexPath.section == 3 ) {
        return 160;
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
        //跳转到优惠券使用界面
        __weak typeof(self) weakSelf = self;
        UseCouponsViewController *useCouponVC = [[UseCouponsViewController alloc] init];
        useCouponVC.ordermodel = self.orderModel;
        useCouponVC.totalPrice = self.orderModel.price;
        useCouponVC.selectedModel = self.couponsModel;
        useCouponVC.selectedClick = ^(CouponsModel *item){
            weakSelf.couponsModel = item;
            CGFloat servicePrice = [self.orderModel.wprice floatValue];
            CGFloat couponPrice = 0;
            if (weakSelf.couponsModel)
            {
                //当前需求是：选择了优惠券其他方式就不允许支付了。
                self.payType = PaymentTypeCoupons;
                if (servicePrice >= [self.couponsModel.voucher_limit floatValue]) {
                    couponPrice = [self.couponsModel.voucher_price floatValue];
                }
            }
            weakSelf.lastPrice = [NSString stringWithFormat:@"%.2f",servicePrice - couponPrice];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:useCouponVC animated:YES];
        
    }else if (indexPath.section == 2) {
        //如果结算方式不能更改就不允许点击
        if ([self.lastPrice floatValue] > [self.balance floatValue])
            return;
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

#pragma mark - EvaluateCellDelegate
/**
 *  评分后回调
 */
-(void)evaluateCell:(EvaluateCell *)cell evaluateScore:(NSInteger)score
{
    self.score = score;
    NSLog(@"%ld",(long)self.score);
}

/**
 *  评价内容发生变化后回调
 */
-(void)evaluateCell:(EvaluateCell *)cell didEvaluateContentChange:(NSString *)newContent
{
    self.evaluateContent = newContent;
    NSLog(@"%@",self.evaluateContent);
}

#pragma mark - 网络相关方法
/**
 *  确认支付按钮被点击时调用
 */
-(void)payNow:(UIButton *)sender
{
    if (self.evaluateContent.length == 0)
        return [NoticeHelper AlertShow:@"请输入评论内容" view:nil];
    //如果选择了优惠券 需要先锁定优惠券
    if (self.couponsModel)
        [self editVoucher];
    else
        [self selectTypeToPay];
}

/**
 *  锁定优惠券
 */
-(void)editVoucher
{
    NSDictionary *dict =  @{ @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client" : @"ios",
                             @"wid":self.orderModel.wid,
                             @"voucher_id":self.couponsModel.voucher_id};
    [CommonRemoteHelper RemoteWithUrl:URL_edit_voucher parameters:dict type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if ([dict[@"code"] integerValue] == 0) {
            //优惠券锁定成功
            [self selectTypeToPay];
            
        }else{
            [NoticeHelper AlertShow:@"优惠券使用失败！" view:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"优惠券锁定失败" view:self.view];
    }];
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
            [self payWithAliPayWitTradeNO:self.orderModel.wcode
                              productName:self.orderModel.tname
                                   amount:self.lastPrice
                       productDescription:self.orderModel.icontent];
        }
            break;
        case PaymentTypeBalance:
        {
            [self payResultHandel];
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
    NSDictionary *params = @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client" : @"ios",
                             @"wid" : self.orderModel.wid,
                             @"voucher_id":self.couponsModel ? self.couponsModel.voucher_id : @"",
                             @"pay_type" : [NSString stringWithFormat:@"%ld",(long)self.payType]};
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
                                         [self submitEvaluate];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [NoticeHelper AlertShow:@"支付结果验证出错了...." view:self.view];
                                     [HUD removeFromSuperview];
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
                            @"wid":self.orderModel.wid,
                            @"cont":self.evaluateContent,
                            @"grade":@(self.score)
                            };
    [CommonRemoteHelper RemoteWithUrl:URL_Save_dis_cont parameters:dict type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if ([dict[@"code"] integerValue] == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"结算成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"评论提交失败" view:self.view];
    }];
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

//
//#pragma mark - 键盘处理
//-(void)keyboardWillAppear:(NSNotification *)notification
//{
//    NSDictionary *keyboardInfo = notification.userInfo;
//    CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat keyboardY = MTScreenH - keyboardFrame.size.height;
//    NSInteger animationCurve = [keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    NSTimeInterval seconds = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    
//    CGFloat bottomViewMaxY = CGRectGetMaxY(self.tableView.tableFooterView.frame);
//    
//    NSLog(@"%f   %f",keyboardY,bottomViewMaxY);
//    
//    if (bottomViewMaxY > keyboardY) {
//        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, bottomViewMaxY - keyboardY, 0);
//        [UIView animateWithDuration:seconds delay:0 options:animationCurve animations:^{
//            self.tableView.contentOffset = CGPointMake(0, bottomViewMaxY - keyboardY);
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
//}
//
//-(void)keyboardWillHide:(NSNotification *)notification
//{
//    NSDictionary *keyboardInfo = notification.userInfo;
//    NSInteger animationCurve = [keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    NSTimeInterval seconds = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    
//    [UIView animateWithDuration:seconds delay:0 options:animationCurve animations:^{
//        self.tableView.contentOffset = CGPointMake(0, 0);
//    } completion:^(BOOL finished) {
//        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    }];
//}


@end
