//
//  CommendList.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommendList.h"

@implementation CommendList

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"goods_commend_list" : [CommendModel class],
             };
}
@end
