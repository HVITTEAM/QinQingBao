//
//  WifiInfoViewController.h
//  VideoGo
//
//  Created by yudan on 14-4-4.
//
//

#import <UIKit/UIKit.h>

@interface WifiInfoViewController : UIViewController
{
    NSString       *_strSn;
    NSString       *_strVerify;
    NSString       *_strAESVersion;//识别设备AES加密
    
    NSString       *_strModel;   //标示设备类型
    
    BOOL            _bForAddDeivce;  // 是否是添加设备分支逻辑中
}


@property (nonatomic, copy) NSString *strSn;
@property (nonatomic, copy) NSString *strVerify;
@property (nonatomic, copy) NSString *strAESVersion;
@property (nonatomic, copy) NSString *strModel;

@property (nonatomic, assign) BOOL bForAddDevice;
@property (nonatomic, assign) BOOL bSupportNet;           // 是否支持以太网

@end
