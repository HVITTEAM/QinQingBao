//
//  NearMenuModel.m
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/27.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceMenuModel.h"

@implementation ServiceMenuModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.img = [dict[@"img"] copy];
        self.label = [dict[@"label"] copy];
        self.url = [dict[@"url"] copy];
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)personWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
