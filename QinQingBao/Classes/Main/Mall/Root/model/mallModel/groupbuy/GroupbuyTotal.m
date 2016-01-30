//
//  GroupbuyTotal.m
//  QinQingBao
//
//  Created by shi on 16/1/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GroupbuyTotal.h"
#import "GroupbuyMode.h"

@implementation GroupbuyTotal

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"data" : [GroupbuyMode class]
             };
}

@end
