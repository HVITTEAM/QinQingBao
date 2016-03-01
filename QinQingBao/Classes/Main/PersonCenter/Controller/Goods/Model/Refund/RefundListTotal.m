//
//  RefundListTotal.m
//  QinQingBao
//
//  Created by shi on 16/2/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RefundListTotal.h"
#import "RefundListModel.h"

@implementation RefundListTotal

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"datas" : [RefundListModel class],
             };
}

@end
