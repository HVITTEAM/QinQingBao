//
//  MTControllerChooseTool.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/14.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "MTControllerChooseTool.h"
#import "MTNewfeatureViewController.h"
#import "BBSUserModel.h"

#import "NewHomeViewController.h"

#import "LoginViewController.h"
#import "MallRootViewControlelr.h"

#import "CXTabBarViewController.h"

@interface MTControllerChooseTool ()

@end

@implementation MTControllerChooseTool

+ (void)chooseRootViewController
{
    // 如何知道第一次使用这个版本？比较上次的使用情况
//    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    // 从沙盒中取出上次存储的软件版本号(取出用户上次的使用记录)
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    // 获得当前打开软件的版本号
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    if ([currentVersion isEqualToString:lastVersion]) {
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    UserModel *vo = [ArchiverCacheHelper getLocaldataBykey:User_Archiver_Key filePath:User_Archiver_Path];
    BBSUserModel *bbsvo = [ArchiverCacheHelper getLocaldataBykey:BBSUser_Archiver_Key filePath:BBSUser_Archiver_Path];
    CityModel *cityVO =  [ArchiverCacheHelper getLocaldataBykey:User_LocationCity_Key filePath:User_LocationCity_Path];
    [SharedAppUtil defaultCommonUtil].cityVO = cityVO;
    [SharedAppUtil defaultCommonUtil].bbsVO = bbsvo;
    [SharedAppUtil defaultCommonUtil].userVO = vo;
    
//    [MTControllerChooseTool setRootViewController];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    [SharedAppUtil defaultCommonUtil].tabBar = [[CXTabBarViewController alloc] init];
    
    window.rootViewController = [SharedAppUtil defaultCommonUtil].tabBar;

    //    } else { // 当前版本号 != 上次使用的版本：显示版本新特性
    //        window.rootViewController = [[MTNewfeatureViewController alloc] init];
    //        // 存储这次使用的软件版本
    //        [defaults setObject:currentVersion forKey:versionKey];
    //        [defaults synchronize];
    //    }
}


@end
