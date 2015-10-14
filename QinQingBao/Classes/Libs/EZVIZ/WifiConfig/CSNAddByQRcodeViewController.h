//
//  CSNAddByQRcodeViewController.h
//  VideoGo
//
//  Created by yd on 12-11-23.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
//#import "TSAlertView.h"
#import "ZBarSDK.h"


#define kINFOVIEW_HEIGHT           120  //文本信息框view高度
#define kNAVAGATION_HEIGHT         44   //导航栏高度
#define kFONTIMAGE_HEIGHT          56   //前景图高度
#define kINFOLABEL_HEIGHT          21   //labe高度
#define kINFOLABEL_SPACE           10   //label间隔
#define KAIMLINE_HEIGHT            2    //瞄准线高度
#define kAIMLINGTOFRAME_SPACE      35   //瞄准线距边框间隔


@class CDeviceInfo;
@interface CSNAddByQRcodeViewController : UIViewController <ZBarReaderViewDelegate>
{
    IBOutlet UIView   * _qrLoadView;         // 扫描camera视图load视图
    IBOutlet UIButton *_torchModeBtn;        // 闪光灯控制
//    IBOutlet UILabel  *m_remindLbl;          //扫描提示语
    IBOutlet UIButton *m_inputBtn;          //手动输入按钮
    
    IBOutlet UIImageView * _bgView;
    IBOutlet UIImageView * _lineView;
    
    ZBarReaderView * m_qrView;  //ZBar二维码读取view
    ZBarCameraSimulator * m_cameraSim;
    
    MBProgressHUD * m_hud;
    NSString * m_strSN;            // 识别好的序列号
    NSString * _strVerifyCode;     // 识别的验证码
    NSString * _strModel;          // 识别的设备型号
    
    NSString *m_strAESVersion;     //识别设备AES加密
    NSString *m_strDetectorSubType;   //识别探测器类型
    
    //标示A1设备关联扫描,默认为NO
    BOOL m_isA1AssociateScanning;//场景:从A1详情界面进入扫描界面
    NSArray *m_detectorlist; ////存储A1已关联的探测器,应用场景同m_isA1AssociateScanning
    CDeviceInfo *m_deviceA1; //存储A1设备数据,应用场景同m_isA1AssociateScanning
}

@property (nonatomic, strong) ZBarReaderView * m_qrView;
@property (nonatomic, weak) IBOutlet UILabel  *m_remindLbl;
@property (nonatomic, copy) NSString * m_strSN;
@property (nonatomic, copy) NSString * strVerifyCode;
@property (nonatomic, copy) NSString * strModel;
@property (nonatomic, copy) NSString * m_strAESVersion;
@property (nonatomic, copy) NSString * m_strDetectorSubType;

@property BOOL m_isA1AssociateScanning;
@property (nonatomic, strong) NSArray *m_detectorlist;
@property (nonatomic, strong) CDeviceInfo *m_deviceA1;

- (IBAction)OnClickBack;

- (IBAction)onClickTorchBtn;

//初始化控件
- (void)initCtrl;
//从二维码中获取序列号
- (NSString * )snFromQRcode: (NSString *) strQRcode;

// 返回上层
- (void)back;

@end