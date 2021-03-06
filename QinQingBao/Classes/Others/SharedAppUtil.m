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

+(BOOL)checkLoginStates
{
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
    {
        [MTNotificationCenter postNotificationName:MTNeedLogin object:nil];
        return NO;
    }
    else if ([SharedAppUtil defaultCommonUtil].bbsVO == nil)
    {
        [MTNotificationCenter postNotificationName:MTCompleteInfo object:nil];
        return NO;
    }
    else
        return YES;
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

-(BBSUserModel *)bbsVO
{
    return _bbsVO;
}

@end
