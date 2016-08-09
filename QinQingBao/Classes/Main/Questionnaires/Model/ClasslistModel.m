//
//  ClasslistModel.m
//  QinQingBao
//
//  Created by shi on 16/8/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ClasslistModel.h"

@implementation ClasslistModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"exam_info" : [ClasslistExamInfoModel class]
             };
}

@end
