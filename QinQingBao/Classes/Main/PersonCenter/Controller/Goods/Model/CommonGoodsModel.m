//
//  CommonGoodsModel.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonGoodsModel.h"

@implementation CommonGoodsModel

// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"order_list" : [CommonOrderModel class],
             };
}
@end
