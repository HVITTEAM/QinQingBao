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

/**
 *  9000 订单支付成功
 *  8000 正在处理中
 *  4000 订单支付失败
 *  6001 用户中途取消
 *  6002 网络连接出错
 *  @param tradeNO            <#tradeNO description#>
 *  @param productName        <#productName description#>
 *  @param amount             <#amount description#>
 *  @param productDescription <#productDescription description#>
 *  @param success            <#success description#>
 *  @param failure            <#failure description#>
 */
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
    NSString *partner = @"2088221350981588";
    NSString *seller = @"ofc.hz@hvit.com.cn";
    NSString *privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKdIyxd3pZwIRBOXBkmkZRsTO9VTlsTlh3+cCxYKWgJc9FsKnOcLQxweSB8NVgwlgilc7LfIFKperP+P+U3KHv/NFlmoz5jJ1OTR9oQF+FoMVYqF9C9C8v3NNGxGnHQwak6d67wxYxntUXQjKFUZWlCnFNXR99D34rseGW6ro74xAgMBAAECgYAewAvNKYpAz2gsLbPTL6wCORvjj/UEBqlMtNN43rhC/PFSFvZWpkRU0+AwDRSHMRHnJpTBB798veCRLdcHDKN71/aPuCoESU4UONwVpHE3cpdDVQ0ATIDDMf5lww6WI29xEbuOcKSQMXJPhyBNCT6hYVbORwr7dQMts2P3xA8JHQJBANqJ6XfDbPfx0Io2xI2zfYhXAOIUf6YQ/ACVcoyAHFsi8vCg7pEbfHf5K9nlAqPBTqJpZLQ8w2N12KctPWQ61hcCQQDD9bJeyIs0an6zvEt0TFgBCTpkTsC6zTsYQj7HuYE05FJofgiXRQaq3PfzlhEKOl4uOx84sQibfPSvXrS7RQL3AkA8Issd66bmq6IJBn0byRJ4HAjgLWfa2L2fo4A77VzgL0POt1ouj/O2R9irQvtw+FadFodhmX7itaECj85e8FnNAkACcWCs39EkcSNtOC60n3MFaEkLERRD/+T5s3G26bAbqbEBTnjq8dhYbvLEXZ2OxBWCfAgym7pgvdkLCqI0J3MXAkAhw0vU9MIi9GWz3PoQzXsJyUHE03+zOjlm4ZLWvBNi3YQuXOZ7VXVcf0yT2VPw8N0vvHiAil6go+E3zS+VehRU";
    
//    NSString *privateKey = @"MIICXQIBAAKBgQDn5FzddkkhXaznBrDMoulKmzWVFlq3ZMKhRVjMmkKQlbyRvU2oZiWj16Fkj05tUYAQSSY1I5OvuriFCH0jkMPB+4hf8ISaeMTEQHUwxObtYpkIYrFQ1dVbzSXWgpyQ9hDe4fgzvxQdchTSgSEWF5t6Dh7w9HA/gv0xnWrJ8N7Z8QIDAQABAoGAOUAT/UkavPYXneH0/FCsMBMpo2kldGmX86DfT4Q2MuQE7iZCafTuDglKez02K58Xcu3cVPo3mAcNTyrNWl5/NYi0cQ4es8yVfVw43rp/uWSwr1nBX/BBdmNP/qr73ctsGiSxD6rwX5WjRLICVwwNI+zKNIOmwdshRLCTEflv0QECQQD80q9A1Uuy0MN5ZCwGRDIQq+njz1qPjkVpShmLaljSW91eHmnA+FjY13INwce6MYHQyU8yiQvM+tk1rGHluqOpAkEA6s5YO33ppnqFyCuduMY87WRaZAl9fsWO8QQl2Zm/BHneweK0+yIewI9MPdiMmjsS2nHmphFkKOQIgbIWlXXxCQJBAKJt1WyI3MZ4e22tHt+zxpqRaIYU/PDIDe40Ti8U1xXnMVS7o2P36lT+LeeKvP/xuJ5kB37HL461BwIFyyul+mkCQFzLZ3s7a5drXGubMR3Q2ktHGaHnTj1HfhIp/Xtdk2wFbc9Z9QQ6m8Sl3Q+kAQ0Cw5So5upCfT7bv7Dh3KL8lWECQQD7HLXXXqaY8esw+DEjArhV/ZuBKKBt5hg6hDVYjUjynEWiBlitBVL3dW37PAMxfxdQJamHN415gNuYCsHAKJ2X";
    
    
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
    order.notifyURL =  URL_AliPay; //回调URL
    
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
    if (signedString != nil)
    {
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
