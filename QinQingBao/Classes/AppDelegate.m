//
//  AppDelegate.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "AppDelegate.h"
#import "UserModel.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "APService.h"
#import "YSPlayerController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "CCLocationManager.h"

#import <Bugtags/Bugtags.h>


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//微信SDK头文件
#import "WXApi.h"

/**
 *  SMS appkey
 */
#define sms_appKey @"81de4ff2ac9e"
#define sms_appSecret @"7a3ebe233b66e0df2505eb54e1096f37"

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationmanager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    // 2.显示窗口(成为主窗口)
    [self.window makeKeyAndVisible];
    
    NSUUID *str = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"设备ID:%@",str);
    
    [self getLocation];
    
    //注册登陆信息超时监听
    [MTNotificationCenter addObserver:self selector:@selector(loginTimeoutHanlder:) name:MTLoginTimeout object:nil];
    
    //注册登陆信息超时监听
    [MTNotificationCenter addObserver:self selector:@selector(needLoginoutHanlder:) name:MTNeedLogin object:nil];
    
    [MTControllerChooseTool chooseRootViewController];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    // 初始化荧石SDK库, 设置SDK平台服务器地址
    NSMutableDictionary *dictServers = [NSMutableDictionary dictionary];
    [dictServers setObject:@"https://auth.ys7.com" forKey:kAuthServer];
    [dictServers setObject:@"https://open.ys7.com" forKey:kApiServer];
    [YSPlayerController loadSDKWithPlatfromServers:dictServers];
    
    [[YSHTTPClient sharedInstance] setClientAppKey:AppKey];
    
    [SMS_SDK registerApp:sms_appKey withSecret:sms_appSecret];
    
    //注册用户的apns服务
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    
    //    [Bugtags startWithAppKey:@"0024657878877c9f392509bc6482a667" invocationEvent:BTGInvocationEventBubble];
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"12731697d2ffc"
          activePlatforms:@[
                            // 不要使用微信总平台进行初始化
                            //@(SSDKPlatformTypeWechat),
                            // 使用微信子平台进行初始化，即可
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx544ef206061848b4"
                                            appSecret:@"c6f33d454b060fe19c9f57317b24bf32"];
                      break;
                  default:
                      break;
              }
          }];
    
    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
    
    //格式化deviceToken
    NSString *deviceTokenStr = [[NSString stringWithFormat:@"%@",deviceToken] substringWithRange:NSMakeRange(1,[NSString stringWithFormat:@"%@",deviceToken].length - 2)];
    NSLog(@"My token is: %@",deviceToken);
    
    [SharedAppUtil defaultCommonUtil].deviceToken = deviceTokenStr;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"--------------deviceToken获取失败--------------------");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
}

/**
 *  接收到推送消息
 *
 *  @param application       application description
 *  @param userInfo          userInfo description
 *  @param completionHandler completionHandler description
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (application.applicationState == UIApplicationStateActive)//当用户正在运行app的时候
    {
        NSLog ( @ "Receive remote notification : %@",userInfo );
        NSDictionary *alertStr = [userInfo objectForKey:@"aps"];
        NSString *pushStr = [alertStr objectForKey:@"alert"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:pushStr delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
        [alert show];
    }
    else
    {
        //消除BadgeNumber
        [APService setBadge:0];
        application.applicationIconBadgeNumber = 0;
        
        // IOS 7 Support Required
        [APService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

/**
 *  在点击设备的home键的时候调用的方法
 *
 *  @param application
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

/**
 *  在点击设备的home键返回桌面后，再次打开应用进入app的时候调用的方法
 *
 *  @param application application description
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //消除BadgeNumber
    [APService setBadge:0];
    application.applicationIconBadgeNumber = 0;
}

/**
 *  进程KILL掉之后也会调用，这个只是第一次授权回调，同时也会返回支付信息
 *
 *  @param application       <#application description#>
 *  @param url               <#url description#>
 *  @param sourceApplication <#sourceApplication description#>
 *  @param annotation        <#annotation description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        NSLog(@"支付成功!");
    }];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        NSLog(@"支付成功!");
    }];
    return YES;
}

/**
 * 登陆信息超时处理事件
 */
-(void)loginTimeoutHanlder:(NSNotification *)notification
{
    [SharedAppUtil defaultCommonUtil].userVO = nil;
    [ArchiverCacheHelper saveObjectToLoacl:[SharedAppUtil defaultCommonUtil].userVO key:User_Archiver_Key filePath:User_Archiver_Path];
    [MTControllerChooseTool setRootViewController];
    
    [SharedAppUtil defaultCommonUtil].tabBar.selectedIndex = 0;
    LoginViewController *login = [[LoginViewController alloc] init];
    login.backHiden = NO;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [[SharedAppUtil defaultCommonUtil].tabBar presentViewController:nav animated:YES completion:nil];
}

/**
 * 需要验证身份才能进行下一步操作
 */
-(void)needLoginoutHanlder:(NSNotification *)notification
{
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    login.backHiden = NO;
}

/**
 *  获取当前位置
 */
-(void)getLocation
{
    locationmanager = [[CLLocationManager alloc] init];
    [locationmanager requestAlwaysAuthorization];
    [locationmanager requestWhenInUseAuthorization];
    locationmanager.delegate = self;
    
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
        [SharedAppUtil defaultCommonUtil].lat = [NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
        [SharedAppUtil defaultCommonUtil].lon = [NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
    }];
}
@end
