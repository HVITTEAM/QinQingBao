//
//  CAShapeLayer+MutipleData.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/30.
//  Copyright © 2016年 董徐维. All rights reserved.
//  动态添加flag数据字段

#import "CAShapeLayer+MutipleData.h"
#import <objc/runtime.h>

@implementation CAShapeLayer (MutipleData)

char flag;

-(void)setFlagData:(NSString *) flagData{
    objc_setAssociatedObject(self, &flag, flagData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)flagData{
    return objc_getAssociatedObject(self, &flag);
}
@end
