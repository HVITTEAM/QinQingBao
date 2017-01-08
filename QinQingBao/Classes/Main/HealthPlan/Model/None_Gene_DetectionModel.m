//
//  None_Gene_DetectionModel.m
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/8.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import "None_Gene_DetectionModel.h"

#import "GenesModel.h"

@implementation None_Gene_DetectionModel
// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"normal" : [GenesModel class],
             @"non_normal" : [GenesModel class],
             
             };
}

@end
