//
//  YSCameraInfo.m
//  EzvizRealPlayDemo
//
//  Created by zhengwen zhu on 7/17/14.
//  Copyright (c) 2014 hikvision. All rights reserved.
//

#import "YSCameraInfo.h"

@implementation YSCameraInfo

- (void)setCameraFromDict:(NSDictionary *)dictionary
{
    NSString *deviceId = [dictionary objectForKey:@"deviceId"];
    if (deviceId != nil && ![deviceId isKindOfClass:[NSNull class]])
    {
        self.deviceId = deviceId;
    }
    
    NSString *cameraID = [dictionary objectForKey:@"cameraId"];
    if (cameraID != nil && ![cameraID isKindOfClass:[NSNull class]])
    {
        self.cameraId = cameraID;
    }
    
    NSNumber *cameraNo = [dictionary objectForKey:@"cameraNo"];
    if (cameraNo != nil)
    {
        self.cameraNo = [cameraNo integerValue];
    }
    
    NSString *cameraName = [dictionary objectForKey:@"cameraName"];
    if (cameraName != nil && ![cameraName isKindOfClass:[NSNull class]])
    {
        self.cameraName = cameraName;
    }
    
    NSString *status = [dictionary objectForKey:@"status"];
    if (status != nil && ![status isKindOfClass:[NSNull class]])
    {
        self.status = status;
    }

    NSString *display = [dictionary objectForKey:@"display"];
    if (display != nil)
    {
        self.display = display;
    }

    NSString *smallThumbnailUrl = [dictionary objectForKey:@"picUrl"];
    if (smallThumbnailUrl != nil && ![smallThumbnailUrl isKindOfClass:[NSNull class]])
    {
        self.picUrl = smallThumbnailUrl;
    }
}

@end
