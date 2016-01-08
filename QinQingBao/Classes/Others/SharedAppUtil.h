//
//  sharedAppUtil.h 系统缓存
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/11.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  单例保存app的全局信息

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "CityModel.h"

@interface SharedAppUtil : NSObject

+(SharedAppUtil *)defaultCommonUtil;

@property (nonatomic, retain) UserModel *userVO;

@property (nonatomic, retain) CityModel *cityVO;

@property (nonatomic, retain) UITabBarController *tabBar;

@property (nonatomic, copy) NSString *deviceToken;

@property (nonatomic, copy) NSString *lon;

@property (nonatomic, copy) NSString *lat;

/**
 *  判断是否需要刷新健康数据  当做出了绑定或者解绑操作之后需要更新健康数据
 */
@property (nonatomic, assign) BOOL needRefleshMonitor;



@end

