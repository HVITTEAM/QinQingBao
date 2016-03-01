//
//  CommonGoodsDetailEndView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//
//按钮宽度
static CGFloat BUTTON_WIDTH = 80;

#import "CommonGoodsDetailEndView.h"
#import "RefundViewController.h"

@implementation CommonGoodsDetailEndView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}


-(void)initView
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line];
    
    //立刻购买
    _buyBt = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - BUTTON_WIDTH - 10, 10, BUTTON_WIDTH, self.height - 20)];
    _buyBt.hidden = NO;
    [_buyBt setTitle:@"评价" forState:UIControlStateNormal];
    _buyBt.layer.borderColor = [[UIColor colorWithRGB:@"f14950"] CGColor];
    _buyBt.layer.borderWidth = 0.5f;
    _buyBt.layer.cornerRadius = 4;
    [_buyBt.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_buyBt setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_buyBt setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    
    [_buyBt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBt setTitleColor:[UIColor colorWithRGB:@"f14950"] forState:UIControlStateNormal];
    [self addSubview:_buyBt];
    _buyBt.tag =1;
    
    //加入购物车
    _add2Car = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - 2*BUTTON_WIDTH - 20, 10, BUTTON_WIDTH, self.height -20)];
    _add2Car.hidden = NO;
    [_add2Car setTitle:@"取消订单" forState:UIControlStateNormal];
    _add2Car.layer.borderColor = [[UIColor colorWithRGB:@"666666"] CGColor];
    _add2Car.layer.borderWidth = 0.5f;
    _add2Car.layer.cornerRadius = 4;
    [_add2Car.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_add2Car setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_add2Car setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    
    [_add2Car addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_add2Car setTitleColor:[UIColor colorWithRGB:@"666666"] forState:UIControlStateNormal];
    _add2Car.tag = 0;
    [self addSubview:_add2Car];
}

-(void)setGoodsitemInfo:(CommonOrderModel *)goodsitemInfo
{
    _goodsitemInfo = goodsitemInfo;
    [self setButtonTitles];
}

-(void)setButtonTitles
{
    if ([_goodsitemInfo.order_state isEqualToString:@"0"])//已取消
    {
        [_buyBt setTitle:@"删除订单" forState:UIControlStateNormal];
        _add2Car.hidden = YES;
    }
    else if ([_goodsitemInfo.order_state isEqualToString:@"10"])//未付款
    {
        [_buyBt setTitle:@"支付" forState:UIControlStateNormal];
        [_add2Car setTitle:@"取消订单" forState:UIControlStateNormal];
    }
    else if ([_goodsitemInfo.order_state isEqualToString:@"20"])//已付款
    {
        //修改 by swy
        [_buyBt setTitle:@"提醒发货" forState:UIControlStateNormal];
        [_add2Car setTitle:@"全部退款" forState:UIControlStateNormal];
        //_add2Car.hidden = YES;
    }
    else if ([_goodsitemInfo.order_state isEqualToString:@"30"])//已发货
    {
        [_buyBt setTitle:@"确认收货" forState:UIControlStateNormal];
        if (_goodsitemInfo.shipping_code == nil || _goodsitemInfo.shipping_code.length == 0)
            _add2Car.hidden = YES;
        [_add2Car setTitle:@"查看物流" forState:UIControlStateNormal];
    }
    else if ([_goodsitemInfo.order_state isEqualToString:@"40"] && [_goodsitemInfo.evaluation_state isEqualToString:@"0"])//交易完成
    {
        [_add2Car setTitle:@"删除订单" forState:UIControlStateNormal];
        [_buyBt setTitle:@"评价" forState:UIControlStateNormal];
    }
    else if ([_goodsitemInfo.order_state isEqualToString:@"40"] && [_goodsitemInfo.evaluation_state isEqualToString:@"1"])//交易完成
    {
        _add2Car.hidden = YES;
        [_buyBt setTitle:@"删除订单" forState:UIControlStateNormal];
    }
}

-(void)buttonClick:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"支付"])
    {
        [self pay];
    }
    else if ([btn.titleLabel.text isEqualToString:@"取消订单"])
    {
        [self canceOrder];
    }
    else if ([btn.titleLabel.text isEqualToString:@"删除订单"])
    {
        [NoticeHelper AlertShow:@"此功能尚未开通!" view:self.window.rootViewController.view];
        //TODO
    }
    else if ([btn.titleLabel.text isEqualToString:@"确认收货"])
    {
        [self recive];
    }
    else if ([btn.titleLabel.text isEqualToString:@"提醒发货"])
    {
        [NoticeHelper AlertShow:@"提醒成功!" view:self.window.rootViewController.view];
    }
    else if ([btn.titleLabel.text isEqualToString:@"查看物流"])
    {
        //TODO
        [NoticeHelper AlertShow:@"此功能尚未开通!" view:self.window.rootViewController.view];
    }
    
    if ([self.delegate respondsToSelector:@selector(endView:button:tappedAtIndex:)]) {
        [self.delegate endView:self button:btn tappedAtIndex:btn.tag];
    }

}

//取消订单
-(void)canceOrder
{
    UIAlertView *canceAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认取消订单？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    [canceAlertView show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_Order_cancel parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                         @"client" : @"ios",
                                                                         @"order_id" : self.goodsitemInfo.order_id}
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
                                             self.goodsitemInfo.order_state = @"0";
                                             
                                             [self.nav popViewControllerAnimated:YES];
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                     }];
        
    }
}


//确认收货
-(void)recive
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Order_receive parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                      @"client" : @"ios",
                                                                      @"order_id" : self.goodsitemInfo.order_id}
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
                                         [self.nav popViewControllerAnimated:YES];
                                         self.goodsitemInfo.order_state = @"40";
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}


//支付
-(void)pay
{
    [MTPayHelper payWithAliPayWitTradeNO:self.goodsModel.pay_sn productName:@"百货" amount:self.goodsModel.pay_amount productDescription:@"海予孝心商城" success:^(NSDictionary *dict,NSString *signedString) {
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
                    NSLog(@"%@",[strArray objectAtIndex:1]);
                    out_trade_no = [strArray objectAtIndex:1];
                }
                else if ([st isEqualToString:@"sign"])
                {
                    NSLog(@"%@",[strArray objectAtIndex:1]);
                    sign = [strArray objectAtIndex:1];
                    [self api_alipay:out_trade_no pay_sn:self.goodsitemInfo.pay_sn signedString:sign];
                }
            }
        }
        self.goodsitemInfo.order_state = @"20";
        [self.nav popViewControllerAnimated:YES];
    } failure:^(NSDictionary *dict) {
            NSLog(@"支付失败");
            //用户中途取消
            if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"6001"])
            {
                
            }
        }];
    
}


/**订单 - 支付付款 订单状态修改**/
-(void)api_alipay:(NSString *)out_trade_no pay_sn:(NSString *)pay_sn signedString:(NSString *)signedString
{
    [CommonRemoteHelper RemoteWithUrl:URL_Alipay parameters: @{@"out_trade_no" : pay_sn,
                                                               @"request_token" : @"requestToken",
                                                               @"result" : @"success",
                                                               @"trade_no" : out_trade_no,
                                                               @"sign" : signedString,
                                                               @"sign_type" : @"MD5"}
                                 type:CommonRemoteTypeGet success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSLog(@"支付结果验证成功");
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"出错了....");
                                 }];
}

@end
