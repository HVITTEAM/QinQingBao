//
//  GoodsClassModelTotal.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsClassModelTotal.h"

@implementation GoodsClassModelTotal

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"class_list" : [GoodsClassModel class],
             };
}
@end
