//
//  MTControllerChooseTool.h
//  QinQingBao
//
//  Created by 董徐维 on 15/8/14.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  负责控制器相关的操作

#import <Foundation/Foundation.h>

@interface MTControllerChooseTool : NSObject

@property(nonatomic, strong) UITabBarController *rootTabbarCtr;

/**
 *  选择根控制器
 */
+ (void)chooseRootViewController;

/**
 *  设置根控制器
 */
+ (void)setRootViewController;

/**
 *  设置登录控制器
 */
+ (void)setLoginViewController;

/**
 *  设置注销控制器
 */
+ (void)setPrivateProfileViewController;

/**
 *  登录之后更新控制器
 */
+ (void)setMainViewcontroller;

@end
