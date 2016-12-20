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
 * 获取和当前时间的时间差
 */
+ (NSString *)intervalSinceNow: (NSString *) theDate;

/**
 * 根据日期和间隔天数 获得需要的日期
 */
+(NSString *)getDaySinceday:(NSDate *)aDate days:(float)days;

+(NSString *)getDaySinceday:(NSDate *)aDate days:(float)days formatter:(NSDateFormatter *)dateFormatter;

/**
 * 时间戳转换成时间
 */
+(NSString *)getDaySince1970:(NSString *)timeStr dateformat:(NSString *)dateformat;

/**
 获取农历的工具方法，可根据需求添加农历节日和二十四节气
 @param wCurYear 年
 @param wCurMonth 月
 @param wCurDay 日
 @return 返回农历日子
 */
+ (NSString *)LunarForSolarYear:(int)wCurYear Month:(int)wCurMonth Day:(int)wCurDay;

@end
