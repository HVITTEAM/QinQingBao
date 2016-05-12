//
//  BalanceTotal.m
//  QinQingBao
//
//  Created by shi on 16/5/6.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "BalanceModel.h"
#import "BalanceLogModel.h"

@implementation BalanceModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"log" : [BalanceLogModel class],
             };
}

@end
