//
//  GoodsInfoTotal.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsInfoTotal.h"

@implementation GoodsInfoTotal
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"goods_list" : [GoodsInfoModel class],
             };
}
@end
