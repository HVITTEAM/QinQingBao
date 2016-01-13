//
//  AddressListTotal.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AddressListTotal.h"

@implementation AddressListTotal
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"datas" : [MallAddressModel class],
             };
}
@end
