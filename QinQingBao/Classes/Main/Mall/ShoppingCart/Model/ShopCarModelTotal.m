//
//  ShopCarModelTotal.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ShopCarModelTotal.h"

@implementation ShopCarModelTotal

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"cart_list" : [ShopCarModel class],
             };
}
@end
