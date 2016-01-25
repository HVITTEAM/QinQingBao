//
//  UIViewController+EzvizTransition.m
//  EzvizOpenSDKDemo
//
//  Created by DeJohn Dong on 15/6/1.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import "UIViewController+EzvizTransition.h"
//#import "RealPlayViewController.h"
//#import "CPlaybackController.h"
//#import "YSDemoAlarmListViewController.h"
//#import "EzvizFindDeviceListViewController.h"
#import "WifiInfoViewController.h"
//#import "EzvizLocalPlayViewController.h"
#import "YSCheckSMSCodeViewController.h"
//#import "YSVideoSquareColumnViewController.h"

@implementation UIViewController (EzvizTransition)

+ (void)go2PlaybackViewController:(id)rootViewController andDeviceInfo:(YSCameraInfo *)info{
//    CPlaybackController *playbackController = [[CPlaybackController alloc]
//                                               initWithNibName:@"CPlaybackController"
//                                               bundle:nil
//                                               camera:info];
//    [((UIViewController *)rootViewController).navigationController pushViewController:playbackController animated:YES];
}

+ (void)go2RealTimePlaybackViewController:(id)rootViewController andDeviceInfo:(YSCameraInfo *)info{
//    RealPlayViewController *realPlayController = [[RealPlayViewController alloc] init];
//    realPlayController.cameraInfo = info;
//    [((UIViewController *)rootViewController).navigationController pushViewController:realPlayController animated:YES];
}

+ (void)go2DeviceListViewController:(id)rootViewController{

}

+ (void)go2SquareListViewController:(id)rootViewController{
//    YSVideoSquareColumnViewController *controller = [[YSVideoSquareColumnViewController alloc] initWithNibName:NSStringFromClass([YSVideoSquareColumnViewController class]) bundle:nil];
//    [((UIViewController *)rootViewController).navigationController pushViewController:controller animated:YES];
}

+ (void)go2CapturePictureViewController:(id)rootViewController andDeviceInfo:(YSCameraInfo *)info{
    
}

+ (void)go2AlarmListViewController:(id)rootViewController andDeviceInfo:(YSCameraInfo *)info{
//    YSDemoAlarmListViewController *controller = [[YSDemoAlarmListViewController alloc] initWithNibName:@"YSDemoAlarmListViewController" bundle:nil cameraId:info.cameraId];
//    controller.cameraInfo = info;
//    [((UIViewController *)rootViewController).navigationController pushViewController:controller animated:YES];
}

+ (void)go2DeviceSettingViewController:(id)rootViewController andDeviceInfo:(YSCameraInfo *)info{
    
}

+ (void)go2FindDevicesViewController:(id)rootViewController andParams:(NSDictionary *)params{
//    EzvizFindDeviceListViewController *findDevicesVC = [[EzvizFindDeviceListViewController alloc] initWithNibName:@"EzvizFindDeviceListViewController" bundle:nil];
//    findDevicesVC.params = params;
//    [((UIViewController *)rootViewController).navigationController pushViewController:findDevicesVC animated:YES];
}

+ (void)go2WifiInfoViewController:(id)rootViewController{
    WifiInfoViewController *wifiVC = [[WifiInfoViewController alloc] init];
    [((UIViewController *)rootViewController).navigationController pushViewController:wifiVC animated:YES];
}

+ (void)go2LocalPlayerViewController:(id)rootViewController andParams:(NSDictionary *)params{
//    EzvizLocalPlayViewController *localVC = [[EzvizLocalPlayViewController alloc] initWithNibName:@"EzvizLocalPlayViewController" bundle:nil];
//    localVC.params = params;
//    [((UIViewController *)rootViewController).navigationController pushViewController:localVC animated:YES];
}


+ (void)go2TransferDemoViewController:(id)rootViewController{
    YSCheckSMSCodeViewController *transferVC = [[YSCheckSMSCodeViewController alloc] initWithNibName:@"YSCheckSMSCodeViewController" bundle:nil];
    [((UIViewController *)rootViewController).navigationController pushViewController:transferVC animated:YES];
}



@end
