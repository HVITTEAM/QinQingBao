//
//  VenderMannager.m
//  EQCollect_HD
//
//  Created by 董徐维 on 15/9/7.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "VenderMannager.h"

#import <SMS_SDK/SMS_SDK.h>


/**
 *  SMS appkey
 */
#define sms_appKey @"81de4ff2ac9e"
#define sms_appSecret @"7a3ebe233b66e0df2505eb54e1096f37"

@implementation VenderMannager

+ (void)load
{
    static dispatch_once_t onceToken;dispatch_once(&onceToken, ^{
        NSLog(@"第三方服务开始注册");
        
//        [SMS_SDK registerApp:sms_appKey withSecret:sms_appSecret];
        
        NSLog(@"第三方服务注册完成");
    });
}
@end
