//
//  IntercomView.h
//  VideoGo
//
//  Created by yudan on 14-5-26.
//
//

#import <UIKit/UIKit.h>
#import "YSPlayerController.h"


typedef enum _ENUM_INTERCOM_TYPE
{
    INTERCOM_TYPE_DUPLEX = 0,                // 双工
    INTERCOM_TYPE_SEMIDUPLEX = 1,            // 半双工
}ENUM_INTERCOM_TYPE;

@interface IntercomView : UIView
{
    YSPlayerController              *_realCtrl;

    ENUM_INTERCOM_TYPE     _intercomType;
}

@property (nonatomic, assign) ENUM_INTERCOM_TYPE intercomType;  

@property (nonatomic, strong) YSPlayerController * realCtrl;


/**
 *  初始化视图  
 */
- (void)initView;

/**
 *  对讲声音能量值回调
 *
 *  @param nIntensity 能量值
 */
- (void)intercomIntensity:(unsigned int)nIntensity;



@end
