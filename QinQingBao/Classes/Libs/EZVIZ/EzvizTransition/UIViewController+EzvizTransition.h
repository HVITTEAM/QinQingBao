//
//  UIViewController+EzvizTransition.h
//  EzvizOpenSDKDemo
//
//  Created by DeJohn Dong on 15/6/1.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSCameraInfo;

@interface UIViewController (EzvizTransition)

//实时监控
+ (void)go2RealTimePlaybackViewController:(id)rootViewController andDeviceInfo:(YSCameraInfo *)info;

//回放
+ (void)go2PlaybackViewController:(id)rootViewController andDeviceInfo:(YSCameraInfo *)info;

//设备列表
+ (void)go2DeviceListViewController:(id)rootViewController;

//设备警告信息
+ (void)go2AlarmListViewController:(id)rootViewController andDeviceInfo:(YSCameraInfo *)info;

//设备抓图
+ (void)go2CapturePictureViewController:(id)rootViewController andDeviceInfo:(YSCameraInfo *)info;

//设置
+ (void)go2DeviceSettingViewController:(id)rootViewController andDeviceInfo:(YSCameraInfo *)info;

//设置wifi
+ (void)go2WifiInfoViewController:(id)rootViewController;

//发现局域网设备
+ (void)go2FindDevicesViewController:(id)rootViewController andParams:(NSDictionary *)params;

//局域网预览
+ (void)go2LocalPlayerViewController:(id)rootViewController andParams:(NSDictionary *)params;

//透传接口demo
+ (void)go2TransferDemoViewController:(id)rootViewController;

//视频广场
+ (void)go2SquareListViewController:(id)rootViewController;

@end
