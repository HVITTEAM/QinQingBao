//
//  CmmonOrderListTotal.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CmmonOrderListTotal.h"

@implementation CmmonOrderListTotal
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"order_list" : [CommonOrderModel class],
             };
}
@end
