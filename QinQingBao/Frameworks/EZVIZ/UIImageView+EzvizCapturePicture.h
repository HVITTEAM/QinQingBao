//
//  UIImageView+EzvizCapturePicture.h
//  EzvizOpenSDK
//
//  Created by DeJohn Dong on 15/6/2.
//  Copyright (c) 2015年 Hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (EzvizCapturePicture)

- (void)ezviz_setImageWithCameraInfo:(NSString *)cameraId;

- (void)ezviz_setImageWithCameraInfo:(NSString *)cameraId andPlaceholderImage:(UIImage *)placeholder;


@end
