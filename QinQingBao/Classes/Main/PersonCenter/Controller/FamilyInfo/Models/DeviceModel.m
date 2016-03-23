//
//  DeviceModel.m
//  QinQingBao
//
//  Created by 董徐维 on 16/3/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DeviceModel.h"
#import "DeviceInfoModel.h"
#import "RelationModel.h"

@implementation DeviceModel
// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"device" : [DeviceInfoModel class],
             @"ud_sos" : [RelationModel class],
             };
}
@end
