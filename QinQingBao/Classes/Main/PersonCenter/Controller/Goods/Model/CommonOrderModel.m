//
//  CommonOrderModel.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonOrderModel.h"
#import "ExtendOrderGoodsModel.h"

@implementation CommonOrderModel


+ (NSDictionary *)objectClassInArray
{
    return @{
             @"extend_order_goods" : [ExtendOrderGoodsModel class],
             };
}
@end
