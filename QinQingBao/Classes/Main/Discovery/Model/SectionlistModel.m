//
//  SectionlistModel.m
//  QinQingBao
//
//  Created by shi on 16/9/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SectionlistModel.h"

@implementation SectionlistModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"sectionId":@"id"
             };
}

@end
