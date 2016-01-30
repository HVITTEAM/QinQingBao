//
//  SpecialList.m
//  QinQingBao
//
//  Created by shi on 16/1/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SpecialList.h"
#import "SpecialModel.h"

@implementation SpecialList

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"data" : [SpecialModel class]
             };
}

@end
