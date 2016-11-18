//
//  AppDelegate.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "AppDelegate.h"
#import "UserModel.h"
#import "Reachability.h"

#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "JPUSHService.h"
#import <SMS_SDK/SMSSDK.h>
#import "CCLocationManager.h"

#import <Bugtags/Bugtags.h>

#import "NewsDetailViewControler.h"
#import "EventInfoController.h"
#import "CXTabBarViewController.h"
#import "EaseSDKHelper.h"

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
#define sms_appKey @"152e9f3fee53a"
#define sms_appSecret @"7f24f0f1f76efee6c6caf44a609f5648"

#define APPID @"1064826790"


@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    CLLocationManager *locationmanager;
    
    //消息的id
    NSString *msg_id;
    //消息的分类
    NSString *type;
    //文章id
    NSString *msg_artid;
    
    Reachability *_reacha;
    NetworkStates _preStatus;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    // 2.显示窗口(成为主窗口)
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSUUID *str = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"设备ID:%@",str);
    
    [self checkNetworkStates];
    
    [self getLocation];
    
    [MTControllerChooseTool chooseRootViewController];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [SMSSDK registerApp:sms_appKey withSecret:sms_appSecret];
    
    //注册用户的apns服务
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    //    [JPUSHService setupWithOption:launchOptions];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"acfe90ae99f621a1ea5b0e04" channel:@"" apsForProduction:YES];
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"hvit#familyprotect" apnsCertName:@"istore_dev"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [self setShareSDK];
    
    // 获取appStore版本号  最后一串数字就是当前app在AppStore上面的唯一id
    NSString *url = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=%@",APPID];
    [self Postpath:url];
    
    
    
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
        case 5:
        {
            EventInfoController *vc = [[EventInfoController alloc] init];
            vc.type = MessageTypePushMsg;
            vc.title = @"通知消息";
            UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
            UINavigationController *nav = tab.selectedViewController;
            [nav pushViewController:vc animated:YES];
        }
            break;
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


#pragma mark -- JPush End


/**
 *  在点击设备的home键的时候调用的方法
 *
 *  @param application
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];

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
    
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];

}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
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

#pragma mark -- 监测版本信息
-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0)
            {
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
    }];
    
}
-(void)receiveData:(id)sender
{
    NSLog(@"receiveData=%@",sender);
    
    NSString *version = [sender objectForKey:@"version"];
    
    NSString *thisVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *thisBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if (version && ![version isEqualToString:[NSString stringWithFormat:@"%@.%@",thisVersion,thisBuild]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"当前APP有新版本，是否更新？" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"去更新", nil];
        alert.tag = 100;
        //        [alert show];
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 100)
    {
        NSString  *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APPID];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication]openURL:url];
    }
    else if (buttonIndex == 1)
    {
        [self sendMsgByType];
    }
}

// 实时监控网络状态
- (void)checkNetworkStates
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];
    _reacha = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    [_reacha startNotifier];
}

- (void)networkChange
{
    NSString *tips;
    NetworkStates currentStates = [NoticeHelper getNetworkStates];
    if (currentStates == _preStatus) {
        return;
    }
    _preStatus = currentStates;
    switch (currentStates) {
        case NetworkStatesNone:
            tips = @"当前无网络, 请检查您的网络状态";
            break;
        case NetworkStates2G:
            tips = @"切换到了2G网络";
            break;
        case NetworkStates3G:
            tips = @"切换到了3G网络";
            break;
        case NetworkStates4G:
            tips = @"切换到了4G网络";
            break;
        case NetworkStatesWIFI:
            tips = nil;
            break;
        default:
            break;
    }
    
    if (tips.length) {
        [[[UIAlertView alloc] initWithTitle:@"寸欣健康" message:@"正在使用蜂窝移动网络，继续使用可能产生流量费用" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
}

@end
