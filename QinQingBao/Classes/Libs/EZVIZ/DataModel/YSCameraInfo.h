//
//  YSCameraInfo.h
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/17/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCameraInfo : NSObject

@property (nonatomic, copy) NSString *deviceId;       // 设备唯一标识
@property (nonatomic, copy) NSString *cameraId;       // 摄像头唯一标识
@property (nonatomic, assign) NSInteger cameraNo;       // 设备的通道号
@property (nonatomic, copy) NSString *cameraName;     // 通道名称
@property (nonatomic, copy) NSString *status;         // 是否在线 0：不在线 1：在线
@property (nonatomic, copy) NSString *display;        // 是否显示 0：不显示 1：显示
@property (nonatomic, copy) NSString *isShared;       // 分享状态
@property (nonatomic, copy) NSString *picUrl;         // 图片地址

- (void)setCameraFromDict:(NSDictionary *)dictionary;

@end
