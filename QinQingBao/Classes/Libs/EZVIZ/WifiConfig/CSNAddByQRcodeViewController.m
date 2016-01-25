//
//  CSNAddByQRcodeViewController.m
//  VideoGo
//
//  Created by yd on 12-11-23.
//
//

#import "CSNAddByQRcodeViewController.h"

#import "YSMobilePages.h"

#import "YSDemoDataModel.h"
#import "CAttention.h"
#import "VideoListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WifiInfoViewController.h"

@interface CSNAddByQRcodeViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
{
    IBOutlet UILabel       *_titleLab;
    
    AVCaptureSession       *_captionSession;
    AVCaptureVideoPreviewLayer   *_videoPreviewLayer;
    UIView                 *_apiQrView;
}

@property (nonatomic, retain) YSMobilePages *mp;

@end

@implementation CSNAddByQRcodeViewController

@synthesize m_qrView;
@synthesize m_strSN;
@synthesize strVerifyCode = _strVerifyCode;
@synthesize strModel = _strModel;
@synthesize m_remindLbl;
@synthesize m_strAESVersion;
@synthesize m_strDetectorSubType;
@synthesize m_isA1AssociateScanning;
@synthesize m_deviceA1;
@synthesize m_detectorlist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_isA1AssociateScanning = NO; //默认从app首页导航栏进入扫描
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _titleLab.text = @"扫描二维码";
    
//    UIButton *btnAddDevice = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnAddDevice setFrame:CGRectMake(0, 0, 60, 44)];
//    [btnAddDevice setTitle:@"手动"
//                  forState:UIControlStateNormal];
//    [btnAddDevice setTitleColor:[UIColor blueColor]
//                       forState:UIControlStateNormal];
//    [btnAddDevice addTarget:self
//                     action:@selector(showAddDevicePage)
//           forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddDevice];
//    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showAddDevicePage)];
    
    // 判断是否有摄像机权限
    if([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)] && [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied)
    {
        [CAttention showAutoHiddenAttention:@"你尚未允许此应用程序访问你的相机，请在iPhone的“设置”-“隐私”-“相机”功能中，找到应用程序“萤石云视频”进行更改"
                                     toView:self.view];
    }
    else
    {
        [self initCtrl];
        
        if (TARGET_IPHONE_SIMULATOR)
        {
            m_cameraSim = [[ZBarCameraSimulator alloc] initWithViewController:self];
            m_cameraSim.readerView = m_qrView;
        }
    }
    
    YSMobilePages *mobilePage = [[YSMobilePages alloc] init];
    self.mp = mobilePage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{

    if (_captionSession)
    {
        [_captionSession startRunning];
    }
    else if (m_qrView)
    {
        [m_qrView start];
    }

    self.m_strDetectorSubType = nil;
    [self animationScanLine:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [self animationScanLine:NO];
    
    if (_captionSession)
    {
        [_captionSession stopRunning];
    }
    else if (m_qrView)
    {
        [m_qrView stop];
    }
    
}

#pragma mark Event response

- (IBAction)OnClickBack
{
    [self back];
}

- (IBAction)onClickTorchBtn
{
    AVCaptureDevice * captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice hasTorch])
    {
        int nTorchMode = captureDevice.torchMode;
        nTorchMode++;
        nTorchMode = nTorchMode>1?0:nTorchMode;
        
        [captureDevice lockForConfiguration:nil];
        captureDevice.torchMode = nTorchMode;
        [captureDevice unlockForConfiguration];
        
        switch (nTorchMode)
        {
            case 0:
            {
                [_torchModeBtn setTitle:NSLocalizedString(@"Off", nil) forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [_torchModeBtn setTitle:NSLocalizedString(@"On", nil) forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }

}


- (void)showAddDevicePage
{
    __weak typeof(self) handleVC = self;
    [_mp addDevice:self.navigationController
   withAccessToken:[EzvizDemoGlobalKit sharedKit].token
          deviceNo:@""
      validateCode:@""
        completion:^(NSString *deviceNo) {
            for ( UIViewController *vc in handleVC.navigationController.viewControllers)
            {
                if ([vc isKindOfClass:[VideoListViewController class]])
                {
                    [handleVC.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        }];
}

#pragma mark - user interface

- (void)initCtrl
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    float statusbarHeight = (IS_IOS7_OR_LATER ? 20.0f : 0.0f);
#else
    float statusbarHeight = 0.0;
#endif
    _qrLoadView.frame = CGRectMake(0, 44 + statusbarHeight, 320, 460-44);
    
    // ios7 系统和以下系统二维码扫描使用不同方案
    if (IS_IOS7_OR_LATER)
    {
        if (_apiQrView == nil)
        {
            _apiQrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [_qrLoadView addSubview:_apiQrView];
        }
        
        NSError * error;
        AVCaptureDevice * captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([captureDevice hasTorch])
        {
            [captureDevice lockForConfiguration:nil];
            captureDevice.torchMode = AVCaptureTorchModeOff;
            [captureDevice unlockForConfiguration];
        }
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        if (!input)
        {
            NSLog(@"camera input device get error");
            _apiQrView = nil;
            return;
        }
        
        _captionSession = [[AVCaptureSession alloc] init];
        [_captionSession addInput:input];
        AVCaptureMetadataOutput * captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
//        captureMetadataOutput.rectOfInterest = CGRectMake((480==480?44:90)/_apiQrView.bounds.size.height, 50/_apiQrView.bounds.size.width, 220/_apiQrView.bounds.size.height, 220/_apiQrView.bounds.size.width);
        [_captionSession addOutput:captureMetadataOutput];
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_queue_create("MyQueue", nil)];
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captionSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        _videoPreviewLayer.frame = _apiQrView.layer.bounds;
        [_apiQrView.layer addSublayer:_videoPreviewLayer];
    }
    else
    {
        if (m_qrView == nil)
        {
            m_qrView = [[ZBarReaderView alloc] init];
            m_qrView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [_qrLoadView addSubview:m_qrView];
        }
        m_qrView.zoom = 1.0f;
        m_qrView.readerDelegate = self;
        m_qrView.torchMode = AVCaptureTorchModeOff;
        
        // WTF!  有效区域的算法都奇葩！ y/size.height, x/size.width, height/size.height, width/size.height
        m_qrView.scanCrop = CGRectMake((480==480?44:90)/m_qrView.bounds.size.height,
                                       50/m_qrView.bounds.size.width,
                                       220/m_qrView.bounds.size.height,
                                       220/m_qrView.bounds.size.width);
        
        //ZBarreadview 属性设置
        m_qrView.trackingColor = [UIColor colorWithRed:255/255.0 green:0 blue:0 alpha:1];
    }
    
    [_torchModeBtn setTitle:NSLocalizedString(@"Off", nil) forState:UIControlStateNormal];
    _torchModeBtn.frame = CGRectMake(10, self.view.frame.size.height-28-8, 63, 28);
    UIImage * bgImg = [UIImage imageNamed:NSLocalizedString(@"qrScan_bg_iphone5@2x.png", nil)];
    
    self.m_remindLbl.textColor = UIColorFromRGB(0xcccac7, 1.0f);
    
    if (460 >= 548)
    {
        //4寸屏幕下移m_remindLbl位置
        CGRect rectLbl = self.m_remindLbl.frame;
        rectLbl.origin.y += 35;
        self.m_remindLbl.frame = rectLbl;
    }
    
    //A1设备关联扫描
    if (m_isA1AssociateScanning)
    {
        self.m_remindLbl.text = @"探测器机身上的二维码";//提示语为“探测器机身上的二维码”
        m_inputBtn.hidden     = YES; //隐藏手动输入按钮
    }
    
    if (480 == 480)
    {
        bgImg = [UIImage imageNamed:NSLocalizedString(@"qrScan_bg_iphone4@2x.png", nil)];
    }
    
    _bgView.image = bgImg;
    
}

/**
 *  处理获取到的二维码
 *
 *  @param strQRCode 二维码信息
 */
- (BOOL)dealScanQR:(NSString *)strQRCode
{
    NSLog(@"read QRcode: %@", strQRCode);
    
    //设备二维码名片
    self.m_strSN = [self snFromQRcode: strQRCode];
    
    NSLog(@"read SN: %@, verify is %@, model is %@", self.m_strSN, self.strVerifyCode, self.strModel);
    
    BOOL avaliable = [self.m_strSN length] == 9;
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       if (avaliable)
                       {
                           [self pushToResult];
                       }
                       else
                       {
                           [CAttention showCustomAutoHiddenAttention:NSLocalizedString(@"无法识别的二维码", nil)
                                                              toView:self.view
                                                           toYOffset:-30
                                                          toFontSize:nil
                                                   toIsDimBackground:NO];
                       }
                   });

    return avaliable;
    
}

- (NSString * )snFromQRcode: (NSString *) strQRcode
{
    self.m_strDetectorSubType = nil;
    NSString * strSN = nil;
    NSArray * arrString = [strQRcode componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //空字符串过滤
    NSMutableArray *rcodeMutAry = [NSMutableArray arrayWithArray:arrString];
    NSMutableArray *copyRcodeMutAry = [NSMutableArray arrayWithArray:arrString];
    for (NSString *strMge in copyRcodeMutAry)
    {
        if ([strMge length] <= 1)
        {
            [rcodeMutAry removeObject:strMge];
        }
    }

    NSUInteger nStringCount = [rcodeMutAry count];
    if (nStringCount == 1)
    {
        strSN = [NSString stringWithFormat:@"%@", [rcodeMutAry objectAtIndex:0]];
    }
    else if (nStringCount > 1)
    {
        strSN = [NSString stringWithFormat:@"%@", [rcodeMutAry objectAtIndex:1]];
    }
    else
    {
        self.strVerifyCode = nil;
        self.strModel = nil;
        self.m_strDetectorSubType = nil;
        return nil;
    }
    
    self.strVerifyCode = nil;
    if (nStringCount > 2)
    {
        self.strVerifyCode = [rcodeMutAry objectAtIndex:2];
        if ([self.strVerifyCode length] < 6)
        {
            self.strVerifyCode = nil;
        }
    }
    
    self.strModel = nil;
    if (nStringCount > 3)
    {
        self.strModel = [rcodeMutAry objectAtIndex:3];
    }

    self.m_strDetectorSubType = nil;
    if (nStringCount > 4)
    {
        NSString *tmpstr = [rcodeMutAry objectAtIndex:4];
        if (4 == [tmpstr length]) //探测器子型号为四个字节(T001/K002)
        {
            self.m_strDetectorSubType = tmpstr;
        }
        
    }
    
    return strSN;
}

/*
 * 进入添加设备结果界面
 */
- (void)pushToResult
{
    if (0 == [self.strVerifyCode length] || 0 == [self.strModel length])
    {
        NSLog(@"QRCode info imcompleted.");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"该设备不支持一键配置WIFI"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    WifiInfoViewController * wifiInfo = [[WifiInfoViewController alloc] initWithNibName:nil bundle:nil];
    wifiInfo.strSn = self.m_strSN;
    wifiInfo.strVerify = self.strVerifyCode;
    wifiInfo.strAESVersion = self.m_strAESVersion;
    wifiInfo.bForAddDevice = YES;
    wifiInfo.strModel    = self.strModel;
    [self.navigationController pushViewController:wifiInfo animated:YES];
    
}

/*
 * 判断是否为探测器设备
 */
- (BOOL)isDetectorDevice:(NSString*)deviceModel
{
    if (nil == deviceModel || 0 == [deviceModel length])
    {
        return NO;
    }
    
    //当前只有两款探测器T001/2/3/4、K002,后续添加新款的话当前版本程序将无法兼容
    NSRange rangeT = [deviceModel rangeOfString:@"T0"];
    if (rangeT.length > 0)
    {
        return YES;
    }
    
    NSRange rangeK = [deviceModel rangeOfString:@"K0"];
    if (rangeK.length > 0)
    {
        return YES;
    }
    
    
    return NO;
}


/*
 * 扫描线动画  
 */
- (void)animationScanLine:(BOOL)bEnable
{
    if (bEnable)
    {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        animation.toValue = [NSNumber numberWithFloat:214.0f];
        animation.duration = 3.0f;
        animation.repeatCount = HUGE_VALF;
        animation.removedOnCompletion=NO;
        
        animation.fillMode=kCAFillModeForwards;
        
        [_lineView.layer addAnimation:animation forKey:nil];
    }
    else
    {
        [_lineView.layer removeAllAnimations];
    }
}

// 返回上层
- (void)back
{
    //覆盖式动画
    if([self respondsToSelector:@selector(presentingViewController)])
    {
        if (self.presentingViewController)
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self showAddDevicePage];
}

#pragma mark
#pragma mark ZBar delegate methods

- (void)readerView: (ZBarReaderView *)readerView
    didReadSymbols: (ZBarSymbolSet *)symbols
         fromImage: (UIImage *)image
{    
    NSString * strQRcode = nil;
    for (ZBarSymbol *sym in symbols)
    {
        strQRcode = sym.data;
        break;
    }
    
    if ([strQRcode length] == 0)
    {
        return;
    }
    
    [self dealScanQR:strQRcode];
}


#pragma mark
#pragma mark avcapturemedataoutputobject delete  
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
            NSString * strQRcode = [metadataObj stringValue];
            if ([strQRcode length] == 0)
            {
                return;
            }
            
            [_captionSession stopRunning];
            
            if (![self dealScanQR:strQRcode])
            {
                [_captionSession startRunning];
            }
        }
    }
}

@end
