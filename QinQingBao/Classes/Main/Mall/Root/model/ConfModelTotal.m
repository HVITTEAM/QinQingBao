//
//  ConfModelTotal.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/27.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ConfModelTotal.h"

@implementation ConfModelTotal

// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"data" : [ConfModel class],
             };
}
@end
