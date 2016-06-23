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
#import "JPUSHService.h"
#import "YSPlayerController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "CCLocationManager.h"

#import <Bugtags/Bugtags.h>

#import "NewsDetailViewControler.h"
#import "EventInfoController.h"

//微信SDK头文件
#import "WXApi.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//新浪微博SDK头文件
#import "WeiboSDK.h"

/**
 *  SMS appkey
 */
#define sms_appKey @"81de4ff2ac9e"
#define sms_appSecret @"7a3ebe233b66e0df2505eb54e1096f37"

@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    CLLocationManager *locationmanager;
    
    //消息的id
    NSString *msg_id;
    //消息的分类
    NSString *type;
    //文章id
    NSString *msg_artid;
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
    
    //注册登录信息超时监听
    [MTNotificationCenter addObserver:self selector:@selector(loginTimeoutHanlder:) name:MTLoginTimeout object:nil];
    
    //注册登录信息超时监听
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
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    [JPUSHService setupWithOption:launchOptions];
    
    //    [Bugtags startWithAppKey:@"0024657878877c9f392509bc6482a667" invocationEvent:BTGInvocationEventBubble];
    
    [self setShareSDK];
    
    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif


#pragma mark -- JPush相关

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    
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
    [JPUSHService handleRemoteNotification:userInfo];
}

/**
 *  接收到推送消息
 *
 *  @param application       application description
 *  @param userInfo          userInfo description
 *  @param completionHandler completionHandler description
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    NSLog ( @ "Receive remote notification : %@",userInfo );
    NSDictionary *alertStr = [userInfo objectForKey:@"aps"];
    //具体的内容
    NSString *pushStr = [alertStr objectForKey:@"alert"];
    //消息的id
    msg_id = [userInfo objectForKey:@"msg_id"];
    //消息的分类
    type = [userInfo objectForKey:@"type"];
    //文章的id
    msg_artid = [userInfo objectForKey:@"msg_artid"];
    
    
    if (application.applicationState == UIApplicationStateActive)//当用户正在运行app的时候
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:pushStr delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看详情", nil];
        [alert show];
    }
    else
    {
        [self sendMsgByType];
        //当用户点击通知栏的消息进入app
        [JPUSHService setBadge:0];
        application.applicationIconBadgeNumber = 0;
        
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

/**
 *  根据type显示不同的view
 */
-(void)sendMsgByType
{
    //12 文章详情 34 通知界面
    switch ([type integerValue])
    {
        case 1:
        {
            [self showArticle:msg_artid];
        }
            break;
        case 2:
        {
            [self showArticle:msg_artid];
        }
            break;
        case 3:
        {
            EventInfoController *vc = [[EventInfoController alloc] init];
            vc.type = MessageTypePushMsg;
            vc.title = @"通知消息";
            UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
            UINavigationController *nav = tab.selectedViewController;
            [nav pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            EventInfoController *vc = [[EventInfoController alloc] init];
            vc.type = MessageTypeLogistics;
            vc.title = @"物流助手";
            UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
            UINavigationController *nav = tab.selectedViewController;
            [nav pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }

}

/**
 *  显示文章详情
 *
 *  @param idstr 文章id
 */
-(void)showArticle:(NSString *)idstr
{
    NewsDetailViewControler *view = [[NewsDetailViewControler alloc] init];
    NSString *url;
    if (![SharedAppUtil defaultCommonUtil].userVO)
        url = [NSString stringWithFormat:@"%@/admin/manager/index.php/family/article_detail/%@?key=cxjk&like",URL_Local,idstr];
    else
        url = [NSString stringWithFormat:@"%@/admin/manager/index.php/family/article_detail/%@?key=%@&like",URL_Local,idstr,[SharedAppUtil defaultCommonUtil].userVO.key];
    view.url = url;
    // 切换控制器
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    [nav pushViewController:view animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self sendMsgByType];
    }
}

#pragma mark -- JPush End


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
    [JPUSHService setBadge:0];
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
 * 登录信息超时处理事件
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

/**
 *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
 *  在将生成的AppKey传入到此方法中。
 *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
 *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
 *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
 */
-(void)setShareSDK
{
    [ShareSDK registerApp:@"12731697d2ffc"
          activePlatforms:@[
                            // 不要使用微信总平台进行初始化
                            //@(SSDKPlatformTypeWechat),
                            // 使用微信子平台进行初始化，即可
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"3331200145"
                                                appSecret:@"86dcd3d64e3ae949f82a34305ad86a7a"
                                              redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1104940369"
                                           appKey:@"Q9PT8FrjYwHZWthH"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx3b685f707604d3e4"
                                            appSecret:@"118f8dde46fd525d738d8b767e70e43a"];
                      break;
                  default:
                      break;
              }
          }];
}
@end
