//
//  VenderMannager.m
//  EQCollect_HD
//
//  Created by 董徐维 on 15/9/7.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

/**
 *  SDK 正式地址 appKey, 需要开发者申请好appkey方可访问
 */
#define AppAPIUrl     @"https://open.ys7.com"
#define AppAuthUrl    @"https://auth.ys7.com"
#define AppKey        @"c68b4a6740244f76b013e3f526cfaf24"

#import "VenderMannager.h"
#import "YSPlayerController.h"
#import "YSHTTPClient.h"

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
        // TODO
        NSLog(@"第三方服务注册完毕");
        
        [SMS_SDK registerApp:sms_appKey withSecret:sms_appSecret];

//        // 初始化SDK库, 设置SDK平台服务器地址
//        NSMutableDictionary *dictServers = [NSMutableDictionary dictionary];
//        [dictServers setObject:@"https://auth.ys7.com" forKey:kAuthServer];
//        [dictServers setObject:@"https://open.ys7.com" forKey:kApiServer];
//        [YSPlayerController loadSDKWithPlatfromServers:dictServers];
//        
//        [[YSHTTPClient sharedInstance] setClientAppKey:AppKey];

        
    });
}
@end
