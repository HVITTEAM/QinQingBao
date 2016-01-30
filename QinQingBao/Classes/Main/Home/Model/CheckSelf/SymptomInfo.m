//
//  SymptomInfo.m
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SymptomInfo.h"
#include "DiseaseModel.h"

@implementation SymptomInfo

// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"disease" : [DiseaseModel class]
             };
}

@end
