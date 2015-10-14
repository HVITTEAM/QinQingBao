//
//  YSMobilePages.h
//  EzvizRealPlay
//
//  Created by zhengwen zhu on 7/12/14.
//  Copyright (c) 2014 yudan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  登录成功回调
 *
 *  @param accessToken 如果登录成功, 返回token字符串; 反之, 返回nil.
 *
 *  @since v1.0.0.0
 */
typedef void (^EzvizLoginBlock)(NSString *accessToken);

typedef void (^EzvziDeviceAddResultBlock)(NSString *deviceNo);

/**
 *  中间页
 *
 *  @since v1.0.0.0
 */
@interface YSMobilePages : NSObject

/**
 *  登录页面
 *
 *  @param navController 控制器
 *  @param keyValue      应用程序id
 *  @param block         登录回调
 *
 *  @since v1.0.0.0
 */
- (void)login:(UINavigationController *)navController
   withAppKey:(NSString *)keyValue
   complition:(EzvizLoginBlock)block __deprecated_msg("方法即将过期，请使用login:completion:方法替代");

/**
 *  登录页面
 *
 *  @param viewController 当前控制器
 *  @param block          登录回调
 *
 *  @since v2.4.0
 */
- (void)login:(UIViewController *)viewController
   completion:(EzvizLoginBlock)block;

/**
 *  添加设备页面
 *
 *  @param navController
 *  @param token         用户登录 token
 *  @param did           设备唯一标识符
 *  @param sf            设备加密秘钥
 */
- (void)addDevice:(UIViewController *)viewController
  withAccessToken:(NSString *)token
         deviceId:(NSString *)did
          safeKey:(NSString *)sf __deprecated_msg("方法即将过期，请使用addDevice:withAccessToken:deviceNo:validateCode:completion方法替代");

/**
 *  添加设备页面
 *
 *  @param viewController 用户页面
 *  @param token          用户登录 token
 *  @param deviceNo       设备序列号
 *  @param validateCode   设备验证码
 *  @param comletion      添加设备结果回调
 */
- (void)addDevice:(UIViewController *)viewController
  withAccessToken:(NSString *)token
         deviceNo:(NSString *)deviceNo
     validateCode:(NSString *)validateCode
       completion:(EzvziDeviceAddResultBlock)comletion;

/**
 *  操作设备页面
 *
 *  @param navController
 *  @param did           设备的id
 *  @param token         登录成功返回的token
 *
 *  @since v1.0.0.0
 */
- (void)manageDevice:(UIViewController *)viewController
        withDeviceId:(NSString *)did
         accessToken:(NSString *)token;

@end
