//
//  YSCommonMethods.h
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/30/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface YSCommonMethods : NSObject


/** @fn	figureLongHandle
 *	@brief  数长处理，个位数前面补0
 *  @param  iFigure - 需要处理的数字
 *	@return	数字字符串
 */
+ (NSString *) figureLongHandle:(NSInteger) iFigure;


/**
 * 强制旋转到竖屏
 */
+ (void)forbitRotatePortraitOrientation;

/**
 * 强制转屏
 */
+ (void)forbitRotatePortraitOrientation:(UIInterfaceOrientation)orientation;

/**
 * 使用加速计控制转向
 */
+ (void)resetOritationWithMotion:(CMMotionManager *)motionManager;


/**
 @function   createFolderAtPath:
 @abstract   创建指定路径下文件夹
 @param      strFolderPath - 文件夹路径
 @result     YES-succ;NO-fail
 */
+ (BOOL)createFolderAtPath:(NSString *) strFolderPath;


/** @fn	configPath
 *  @brief  获得沙盒中的文件路径
 *  @param  沙盒目录的文件名
 *  @return 返回沙盒目录
 */
+ (NSString*)configFilePath:(NSString *)configName;

@end
