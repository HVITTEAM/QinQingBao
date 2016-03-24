//
//  MTPayHelper.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPayHelper : NSObject

/**
 *  支付宝支付帮助类
 *
 *  @param tradeNO     订单号
 *  @param productName 订单名称
 *  @param amount      价格
 *  @param productDescription      订单描述
 *  @param success       成功回调block
 *  @param failure       失败回调block
 */
+(void)payWithAliPayWitTradeNO:(NSString *)tradeNO productName:(NSString *)productName amount:(NSString *)amount productDescription:(NSString *)productDescription  success:(void (^)(NSDictionary *dict,NSString *signedString))success failure:(void (^)(NSDictionary *dict))failure;
@end
