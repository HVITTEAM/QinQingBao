//
//  ResetDeviceTipsViewController.h
//  VideoGo
//
//  Created by yudan on 14-6-11.
//
//

#import <UIKit/UIKit.h>

@interface ResetDeviceTipsViewController : UIViewController
{
    NSString      *_strSN;
    BOOL           _bSupportNet;    // 是否支持以太网
}

@property(nonatomic, copy) NSString * strSN;
@property(nonatomic, assign) BOOL bSupportNet;

@end
