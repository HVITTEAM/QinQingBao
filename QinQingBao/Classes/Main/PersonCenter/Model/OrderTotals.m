//
//  OrderTotals.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/25.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "OrderTotals.h"
#import "OrderModel.h"

@implementation OrderTotals


// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"datas" : [OrderModel class],
             };
}
@end
