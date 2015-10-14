//
//  YSCommonMethods.m
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/30/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "YSCommonMethods.h"

@implementation YSCommonMethods


/** @fn	figureLongHandle
 *	@brief  数长处理，个位数前面补0
 *  @param  iFigure - 需要处理的数字
 *	@return	数字字符串
 */
+ (NSString *) figureLongHandle:(NSInteger) iFigure
{
	NSString *sFigure = nil;
	if (iFigure < 10 && iFigure >= 0)
	{
		sFigure = [NSString stringWithFormat:@"0%d", (int)iFigure];
	}
	else
	{
		sFigure = [NSString stringWithFormat:@"%d", (int)iFigure] ;
	}
	
	return sFigure;
}

/**
 * 强制旋转到竖屏
 */
+ (void)forbitRotatePortraitOrientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                       withObject:@(UIInterfaceOrientationPortrait)];
    }
}


/**
 * 使用加速计控制转向
 */
+ (void)resetOritationWithMotion:(CMMotionManager *)motionManager
{
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    if (motionManager.accelerometerAvailable)
    {
        motionManager.accelerometerUpdateInterval = 5.0/10.0;
        [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             if (!error)
             {
                 if (accelerometerData.acceleration.y < -0.6f && fabs(accelerometerData.acceleration.x) < 0.5f && ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight))
                 {
                     dispatch_async(dispatch_get_main_queue(),
                                    ^{
                                        [YSCommonMethods forbitRotatePortraitOrientation:UIInterfaceOrientationPortrait];
                                    });
                 }
                 else if (accelerometerData.acceleration.x < -0.6f && fabs(accelerometerData.acceleration.y) < 0.5 && [UIDevice currentDevice].orientation != UIInterfaceOrientationLandscapeRight)
                 {
                     dispatch_async(dispatch_get_main_queue(),
                                    ^{
                                        [YSCommonMethods forbitRotatePortraitOrientation:UIInterfaceOrientationLandscapeRight];
                                    });
                 }
                 else if (accelerometerData.acceleration.x > 0.6f && fabs(accelerometerData.acceleration.y) < 0.5f && [UIDevice currentDevice].orientation != UIInterfaceOrientationLandscapeLeft)
                 {
                     dispatch_async(dispatch_get_main_queue(),
                                    ^{
                                        [YSCommonMethods forbitRotatePortraitOrientation:UIInterfaceOrientationLandscapeLeft];
                                    });
                 }
             }
         }
         ];
    }
}

/**
 * 强制转屏
 */
+ (void)forbitRotatePortraitOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                       withObject:@(orientation)];
    }
}

/**
 @function   createFolderAtPath:
 @abstract   创建指定路径下文件夹
 @param      strFolderPath - 文件夹路径
 @result     YES-succ;NO-fail
 */
+ (BOOL)createFolderAtPath:(NSString *) strFolderPath
{
    BOOL bRet = NO;
    NSError * err = nil;
    bRet = [[NSFileManager defaultManager] createDirectoryAtPath:strFolderPath
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:&err];
    if (!bRet)
    {
        NSLog(@"err:%@", [err localizedDescription]);
    }
    return bRet;
}

/** @fn	configPath
 *  @brief  获得沙盒中的文件路径
 *  @param  沙盒目录的文件名
 *  @return 返回沙盒目录
 */
+ (NSString*)configFilePath:(NSString *)configName
{
	NSArray * docdirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * docdir = [docdirs objectAtIndex:0];
	
	NSString * configFilePath = [docdir stringByAppendingPathComponent:configName];
	return configFilePath;
}

@end
