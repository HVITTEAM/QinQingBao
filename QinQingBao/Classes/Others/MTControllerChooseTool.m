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
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "RootViewController.h"

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
    if ([currentVersion isEqualToString:lastVersion]) {
        // 当前版本号 == 上次使用的版本：显示HMTabBarViewController
        [UIApplication sharedApplication].statusBarHidden = NO;
        
        //        ViewController *vc = [[ViewController alloc] init];
        // 显示主控制器（MainViewController）
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        // 切换控制器
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = nav;
        
    } else { // 当前版本号 != 上次使用的版本：显示版本新特性
        window.rootViewController = [[MTNewfeatureViewController alloc] init];
        
        // 存储这次使用的软件版本
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }
}

+ (void)setRootViewController
{
    HealthMonitorViewController *healthView = [[HealthMonitorViewController alloc] init];
    healthView.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"监护"
                                                           image:[UIImage imageNamed:@"second_normal.png"]
                                                   selectedImage:[UIImage imageNamed:@"second_selected.png"]];
    UINavigationController *navhealth = [[UINavigationController alloc] initWithRootViewController:healthView];
    
    HomeViewController *homeView = [[HomeViewController alloc] init];
    homeView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                        image:[UIImage imageNamed:@"first_normal.png"]
                                                selectedImage:[UIImage imageNamed:@"first_selected.png"]];
    UINavigationController *navhome = [[UINavigationController alloc] initWithRootViewController:homeView];
    
    ProfileViewController *sysview = [[ProfileViewController alloc] init];
    sysview.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心"
                                                       image:[UIImage imageNamed:@"third_selected.png"]
                                               selectedImage:[UIImage imageNamed:@"third_normal.png"]];
    UINavigationController *navsys = [[UINavigationController alloc] initWithRootViewController:sysview];
    
    //初始化对象
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    //    tabBarController.tabBar.barTintColor = HMColor(48, 37, 44);
    //    tabBarController.tabBar.tintColor = HMColor(18, 141, 216);
    
    //将2个uivc以数组的方式制定给bar对象
    tabBarController.viewControllers = [NSArray arrayWithObjects:navhome,navhealth,navsys, nil];
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //将其设置为当前窗口的跟视图控制器
    window.rootViewController = tabBarController;
    
    [SharedAppUtil defaultCommonUtil].tabBarController = tabBarController;
}

+ (void)setLoginViewController
{
    // 3.设置窗口的根控制器
    RootViewController *rootView = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootView];
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //将其设置为当前窗口的跟视图控制器
    window.rootViewController = nav;
}


@end
