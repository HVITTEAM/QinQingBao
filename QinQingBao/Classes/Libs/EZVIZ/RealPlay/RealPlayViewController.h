//
//  RealPlayViewController.h
//  VideoGo
//
//  Created by yudan on 14-5-17.
//
//

#import <UIKit/UIKit.h>
#import "YSCameraInfo.h"

@interface RealPlayViewController : UIViewController
{
    YSCameraInfo          *_cameraInfo;               // 当前正在播放的摄像机信息
    
}

@property (nonatomic, strong) YSCameraInfo * cameraInfo;


@end
