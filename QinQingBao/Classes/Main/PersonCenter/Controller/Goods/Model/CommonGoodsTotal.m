//
//  CommonGoodsTotal.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonGoodsTotal.h"

@implementation CommonGoodsTotal
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"order_group_list" : [CommonGoodsModel class],
             };
}
@end
