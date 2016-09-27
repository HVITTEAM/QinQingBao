//
//  DetailPostsModel.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DetailPostsModel.h"
#import "DetailImgModel.h"

@implementation DetailPostsModel
// 实现这个方法的目的：告诉MJExtension框架statuses和ads数组里面装的是什么模型
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"img" : [DetailImgModel class],
             };
}
@end