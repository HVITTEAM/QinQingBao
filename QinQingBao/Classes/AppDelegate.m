//
//  AppDelegate.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "HealthMonitorViewController.h"
#import "ProfileViewController.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 2.显示窗口(成为主窗口)
    [self.window makeKeyAndVisible];
    
    // 3.设置窗口的根控制器
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
    
      //将其设置为当前窗口的跟视图控制器
    
//    RootViewController *rootView = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootView];
//    self.window.rootViewController = nav;
      self.window.rootViewController = tabBarController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
