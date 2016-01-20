//
//  MTDateHelper.h
//  QinQinBao
//
//  Created by 董徐维 on 15/6/16.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTDateHelper : NSObject


/**
 *  显示提示信息（默认1.33秒消失）
 *
 *  @param msg  提示信息文字
 *  @param view 在哪个view上显示
 */
+(void)AlertShow:(NSString *)msg view:(UIView *)view;

/**
 * 获取和当前时间的时间差
 */
+ (NSString *)intervalSinceNow: (NSString *) theDate;


/**
 * 根据日期和间隔天数 获得需要的日期
 */
+(NSString *)getDaySinceday:(NSDate *)aDate days:(float)days;

/**
 * 时间戳转换成时间
 */
+(NSString *)getDaySince1970:(NSString *)timeStr dateformat:(NSString *)dateformat;

/**
 * 根据运行时特性获取当前网络类型
 * 0 - 无网络 ; 1 - 2G ; 2 - 3G ; 3 - 4G ; 5 - WIFI
 */
+(int)getApplicationNettype;

@end
