//
//  MTPayHelper.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MTPayHelper.h"
#import "Order.h"
#import "DataSigner.h"

@implementation MTPayHelper

+(void)payWithAliPayWitTradeNO:(NSString *)tradeNO productName:(NSString *)productName amount:(NSString *)amount productDescription:(NSString *)productDescription  success:(void (^)(NSDictionary *dict,NSString *signedString))success failure:(void (^)(NSDictionary *dict))failure
{
    NSLog(@"确认支付");
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088121051826945";
    NSString *seller = @"ofc.er@hvit.com.cn";
    NSString *privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKdIyxd3pZwIRBOXBkmkZRsTO9VTlsTlh3+cCxYKWgJc9FsKnOcLQxweSB8NVgwlgilc7LfIFKperP+P+U3KHv/NFlmoz5jJ1OTR9oQF+FoMVYqF9C9C8v3NNGxGnHQwak6d67wxYxntUXQjKFUZWlCnFNXR99D34rseGW6ro74xAgMBAAECgYAewAvNKYpAz2gsLbPTL6wCORvjj/UEBqlMtNN43rhC/PFSFvZWpkRU0+AwDRSHMRHnJpTBB798veCRLdcHDKN71/aPuCoESU4UONwVpHE3cpdDVQ0ATIDDMf5lww6WI29xEbuOcKSQMXJPhyBNCT6hYVbORwr7dQMts2P3xA8JHQJBANqJ6XfDbPfx0Io2xI2zfYhXAOIUf6YQ/ACVcoyAHFsi8vCg7pEbfHf5K9nlAqPBTqJpZLQ8w2N12KctPWQ61hcCQQDD9bJeyIs0an6zvEt0TFgBCTpkTsC6zTsYQj7HuYE05FJofgiXRQaq3PfzlhEKOl4uOx84sQibfPSvXrS7RQL3AkA8Issd66bmq6IJBn0byRJ4HAjgLWfa2L2fo4A77VzgL0POt1ouj/O2R9irQvtw+FadFodhmX7itaECj85e8FnNAkACcWCs39EkcSNtOC60n3MFaEkLERRD/+T5s3G26bAbqbEBTnjq8dhYbvLEXZ2OxBWCfAgym7pgvdkLCqI0J3MXAkAhw0vU9MIi9GWz3PoQzXsJyUHE03+zOjlm4ZLWvBNi3YQuXOZ7VXVcf0yT2VPw8N0vvHiAil6go+E3zS+VehRU";
    
//    NSString *privateKey = @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBANg0wCPkCRjHqSdUko7bjzwVHSZqN7E5OQm5lx6m3cDsQ/6V2axJz5RCAyJ2O7+8t7rOJooOjg1ukNtCVT+dC+CyInnS6ZwhwT/ecZmGWeEWA9703ivvo7whV/NTESCacQWqAx6Xn0M5IbENELlzZHKg6rl/tXKHDkecIcpQYJAFAgMBAAECgYEAx+6f75CkSOH5roEqtiibH/h2aFu4/I3qDPAuqw2r6weRKQ/xprzq1DLnKysivYAKdxjD0s761bj1A40nwBe+Lmvo1v9IdL/mzbNqUgFMX0ntsOJ4oVUWHj7QCdCPB1Z7MYIZPrGNx1Ptz2eeu4HPvxpJaTzysTaPx8umce6en4ECQQDtobDKAYEpcMw36aG3STYzG9hbgyKC5yBAbaLNF76crERdyZMOMl6SgaErFwq9VcVdgxIBtbx36bed7Utz30YNAkEA6OsWFSizaMvxKnFNvxZ6OzzNCB+HJRj8PF3mv43aeXDYwvqraKkxfUHzcJLJODb8+QYlaZI6qH3vdgauqEIr2QJBAONigB+cNvLni5LJDcSr2qAnOe2/Wqu17AeaoVjtKqkSskyoUP4ZtqMsRYNNBirMQxJLFFTsiQ6ZZulIopWbBZUCQQDUD1VnpkrSGvxTfB0g4UIgNNcnkizlJb5g581ykaBb+NYhj0AIZiLcu/L8h2gUelwQDfx6BdzKEv62IpdaMgThAkEAogJ/6KWMfKX1iaVKB+QCmnUeBFm3XojypYDkjBka+XEP+7q6RZKIuGHQG4NVeipM0K7yhiwL/1zhSt6+VOANRg==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = tradeNO;
    order.productName = productName; //商品标题
    order.productDescription = productDescription; //商品描述
    order.amount = amount; //商品价格
    order.notifyURL =  URL_Pay; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"QinQingBao";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                                message:[resultDic objectForKey:@"memo"]
                                                               delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                failure(resultDic);
            }
            else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                                message:@"支付成功"
                                                               delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                
                success(resultDic,signedString);
            }
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

@end
