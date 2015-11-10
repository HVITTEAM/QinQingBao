//
//  EvaluationTotal.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/9.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "EvaluationTotal.h"
#import "EvaluationModel.h"

@implementation EvaluationTotal
// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"datas" : [EvaluationModel class],
             };
}
@end
