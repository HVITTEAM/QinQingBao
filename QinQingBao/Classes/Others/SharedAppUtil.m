//
//  sharedAppUtil.m
//  GPSNavDemo
//
//  Created by 董徐维 on 15/3/11.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "SharedAppUtil.h"

@implementation SharedAppUtil

+(SharedAppUtil *)defaultCommonUtil
{
    static SharedAppUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[SharedAppUtil alloc]init];
    });
    return util;
}

-(void)setLat:(NSString *)lat
{
    if (lat.length == 0 )
        _lat = @"";
    _lat = lat;
}

-(void)setLon:(NSString *)lon
{
    if (lon.length == 0 )
        lon = @"";
    _lon = lon;
}

-(UserModel *)userVO
{
    return _userVO;
}

//-(UITabBarController*)tabBar
//{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    if ( window.rootViewController && [window.rootViewController isKindOfClass:[UITabBarController class]])
//        return nil;
//    else
//        return (UITabBarController *)window.rootViewController;
//}
@end
