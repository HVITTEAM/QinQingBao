//
//  WifiAddDeviceViewController.h
//  VideoGo
//
//  Created by yudan on 14-4-8.
//
//

#import <UIKit/UIKit.h>


// 设备bonjour搜索到的状态标示  
typedef enum _DEVICE_STATE
{
    STATE_NONE = 0,          // 设备状态-无
    STATE_WIFI,              // wifi已连接
    STATE_LINE,              // 有线已连接  
    STATE_PLAT,              // 平台已注册
    STATE_SUCC,              // 已添加成功
}DEVICE_STATE;


@interface WifiAddDeviceViewController : UIViewController
{
    NSString       *_strSsid;
    NSString       *_strKey;
    
    NSString       *_strSn;
    NSString       *_strVerify;
    NSString       *_strAESVersion;//识别设备AES加密
    
    NSString       *_strModel;
    
    BOOL            _bSupportNet;      // 是否支持以太网
    
    DEVICE_STATE    _enState;            // bonjour到的设备状态
}

@property (nonatomic, copy) NSString * strSsid;
@property (nonatomic, copy) NSString * strKey;
@property (nonatomic, copy) NSString * strSn;
@property (nonatomic, copy) NSString * strVerify;
@property (nonatomic, copy) NSString *strAESVersion;
@property (nonatomic, copy) NSString *strModel;

@property (nonatomic, assign) BOOL     bSupportNet;
@property (nonatomic, assign) DEVICE_STATE enState;


@end
