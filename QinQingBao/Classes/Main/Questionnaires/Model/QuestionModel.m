//
//  QuestionModel.m
//  QinQingBao
//
//  Created by 董徐维 on 16/7/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "QuestionModel.h"
#import "QuestionModel_1.h"

@implementation QuestionModel
// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"questions" : [QuestionModel_1 class],
             };
}
@end
