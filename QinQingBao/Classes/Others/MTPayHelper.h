//
//  MTPayHelper.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPayHelper : NSObject
+(void)payWithAliPayWitTradeNO:(NSString *)tradeNO productName:(NSString *)productName amount:(NSString *)amount productDescription:(NSString *)productDescription  success:(void (^)(NSDictionary *dict,NSString *signedString))success failure:(void (^)(NSDictionary *dict))failure;
@end
