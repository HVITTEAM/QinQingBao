//
//  MTControllerChooseTool.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/14.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "MTControllerChooseTool.h"
#import "MTNewfeatureViewController.h"
#import "HealthMonitorViewController.h"
//#import "HomeViewController.h"

#import "CXHomeViewController.h"

#import "ProfileViewController.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "MallRootViewControlelr.h"

@implementation MTControllerChooseTool

+ (void)chooseRootViewController
{
    // 如何知道第一次使用这个版本？比较上次的使用情况
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    // 从沙盒中取出上次存储的软件版本号(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    if ([currentVersion isEqualToString:lastVersion]) {
    
        [UIApplication sharedApplication].statusBarHidden = NO;
        
        UserModel *vo = [ArchiverCacheHelper getLocaldataBykey:User_Archiver_Key filePath:User_Archiver_Path];
        
        CityModel *cityVO =  [ArchiverCacheHelper getLocaldataBykey:User_LocationCity_Key filePath:User_LocationCity_Path];
        [SharedAppUtil defaultCommonUtil].cityVO = cityVO;
        [SharedAppUtil defaultCommonUtil].userVO = vo;
        [MTControllerChooseTool setRootViewController];
        
//    } else { // 当前版本号 != 上次使用的版本：显示版本新特性
//        window.rootViewController = [[MTNewfeatureViewController alloc] init];
//        // 存储这次使用的软件版本
//        [defaults setObject:currentVersion forKey:versionKey];
//        [defaults synchronize];
//    }
}

+ (void)setRootViewController
{
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //登陆界面
    LoginViewController *login = [[LoginViewController alloc] init];
    login.backHiden = YES;
    UINavigationController *navLoginNav = [[UINavigationController alloc] initWithRootViewController:login];
    navLoginNav.navigationItem.leftBarButtonItem = nil;
    
    LoginViewController *healthLogin = [[LoginViewController alloc] init];
    healthLogin.backHiden = YES;
    UINavigationController *healthLoginNav = [[UINavigationController alloc] initWithRootViewController:healthLogin];
    healthLoginNav.navigationItem.leftBarButtonItem = nil;
    
    CXHomeViewController *homeView = [[CXHomeViewController alloc] init];
    UINavigationController *navhome = [[UINavigationController alloc] initWithRootViewController:homeView];
    
    HealthMonitorViewController *healthView = [[HealthMonitorViewController alloc] init];
    UINavigationController *navhealth = [[UINavigationController alloc] initWithRootViewController:healthView];
    
    MallRootViewControlelr *mallView = [[MallRootViewControlelr alloc] init];
    
    UINavigationController *navMall = [[UINavigationController alloc] initWithRootViewController:mallView];
    ProfileViewController *sysview = [[ProfileViewController alloc] init];
    UINavigationController *navsys = [[UINavigationController alloc] initWithRootViewController:sysview];
    
    if (![SharedAppUtil defaultCommonUtil].tabBar)
    {
        //初始化对象
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.tabBar.barTintColor = [UIColor whiteColor];
        tabBarController.tabBar.tintColor =HMColor(95, 117, 75);
        [SharedAppUtil defaultCommonUtil].tabBar = tabBarController;
    }
    //uivc以数组的方式制定给bar对象
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        [SharedAppUtil defaultCommonUtil].tabBar.viewControllers = [NSArray arrayWithObjects:navhome,healthLoginNav,navMall,navsys, nil];
    else
        [SharedAppUtil defaultCommonUtil].tabBar.viewControllers = [NSArray arrayWithObjects:navhome,navhealth,navMall,navsys, nil];
    NSArray *barItems = [SharedAppUtil defaultCommonUtil].tabBar.tabBar.items;
    
    ((UITabBarItem *)barItems[0]).title = @"首页";
    ((UITabBarItem *)barItems[0]).image = [[UIImage imageNamed:@"first_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ((UITabBarItem *)barItems[0]).selectedImage = [[UIImage imageNamed:@"first_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ((UITabBarItem *)barItems[1]).title = @"监护";
    ((UITabBarItem *)barItems[1]).image = [[UIImage imageNamed:@"second_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ((UITabBarItem *)barItems[1]).selectedImage = [[UIImage imageNamed:@"second_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ((UITabBarItem *)barItems[2]).title = @"商城";
    ((UITabBarItem *)barItems[2]).image = [[UIImage imageNamed:@"shop_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ((UITabBarItem *)barItems[2]).selectedImage = [[UIImage imageNamed:@"shop_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ((UITabBarItem *)barItems[3]).title = @"我的";
    ((UITabBarItem *)barItems[3]).image = [[UIImage imageNamed:@"third_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ((UITabBarItem *)barItems[3]).selectedImage = [[UIImage imageNamed:@"third_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //将其设置为当前窗口的跟视图控制器
    window.rootViewController = [SharedAppUtil defaultCommonUtil].tabBar;
}

+(void)setMainViewcontroller
{
    HealthMonitorViewController *healthView = [[HealthMonitorViewController alloc] init];
    UINavigationController *nav = [SharedAppUtil defaultCommonUtil].tabBar.viewControllers[1];
    nav.navigationBarHidden = NO;
    [nav setViewControllers:@[healthView] animated:YES];
}

+(void)setloginOutViewController
{
    LoginViewController *healthLogin = [[LoginViewController alloc] init];
    healthLogin.backHiden = YES;
    UINavigationController *nav1 = [SharedAppUtil defaultCommonUtil].tabBar.viewControllers[1];
    [nav1 setViewControllers:@[healthLogin] animated:YES];
}

+ (void)setLoginViewController
{
    // 3.设置窗口的根控制器
    LoginViewController *rootView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootView];
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //将其设置为当前窗口的跟视图控制器
    window.rootViewController = nav;
}

@end
