//
//  SpecialDataTotal.m
//  QinQingBao
//
//  Created by shi on 16/1/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SpecialDataTotal.h"
#import "SpecialData.h"

@implementation SpecialDataTotal


+ (NSDictionary *)objectClassInArray
{
    return @{
             @"data" : [SpecialData class]
             };
}

@end
