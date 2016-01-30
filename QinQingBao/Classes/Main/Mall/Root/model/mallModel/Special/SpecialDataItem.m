//
//  SpecialDataItem.m
//  QinQingBao
//
//  Created by shi on 16/1/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SpecialDataItem.h"
#import "CommodityModel.h"

@implementation SpecialDataItem

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"item" : [CommodityModel class]
             };
}

@end
