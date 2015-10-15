//
//  RealPlayViewController.m
//  VideoGo
//
//  Created by yudan on 14-5-17.
//
//

#import "RealPlayViewController.h"

#import <Accelerate/Accelerate.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AVFoundation/AVFoundation.h>

#import "TipsPublicView.h"
#import "CAttention.h"
#import "RecordingBtnView.h"
#import "IntercomView.h"
#import "RealFluxDataView.h"
#import "RealView.h"
#import "VideoGoDef.h"

#import "YSPlayerController.h"
#import "YSDemoDataModel.h"

#import "YSCommonMethods.h"
#import "UIImage+ImageEffects.h"
#import "YSCheckSMSCodeViewController.h"
#import "CaptureViewController.h"




#define REAL_GUIDE_VIEW                 1001
#define REAL_GUIDE_NEXT_BTN             1002

#define  ALERT_RETRY_ADMIN_PASSWORD_TAG      1003
#define  ALERT_RETRY_SAFEMODE_PASSWORD_TAG   1004
#define  TSALERT_VIEW_SAFEMODE_TAG           1005
#define  TSALERT_VIEW_ADMIN_PASSWORD_TAG     1006
#define  PTZVIEW_BGVIEW_TAG                  1007
#define  PTZVIEW_FLIP_BTN                    1008
#define  PTZVIEW_FLIP_ACTIVITY               1009

#define  ALERT_SHARE_WECHAT_VERIFYCOE_TAG    2000

#define  VIEW_NOTOUCH_TAG                    6001

#define PLAYBTN_HEIGHT                  64
#define SHARECTRL_BTN_HEIGHT            50
#define FS_PLAYBTN_HEIGHT               50
#define CAMERALIST_TABLEVIEW_HEIGHT     60
#define PTZ_CTRLVIEW_WIDTH              155
#define SHAREINFO_VIEW_HEIGHT           55

extern long g_lRealTotleFlux;


@interface RealPlayViewController () <YSPlayerControllerDelegate, UIAlertViewDelegate>
{
    RealView             *_realView;               // 播放视图
    
    TipsPublicView       *_titleView;              // 标题视图
    
    UIView               *_ctrlView;               // 控制视图
    UIScrollView         *_toolbarBgView;
    UIView               *_toolbarView;
    UIButton             *_mailBtn;
    UIButton             *_intercomBtn;
    UIButton             *_captureBtn;
    RecordingBtnView     *_recordBtn;
    UIButton             *_videoQualityBtn;
    UIButton             *_shareBtn;
    UIButton             *_ptzCtrlBtn;
    UIView               *_fsToolbarView;
    UIButton             *_fsStopBtn;
    UIButton             *_fsCaptureBtn;
    RecordingBtnView     *_fsRecordBtn;
    RealFluxDataView     *_fsRealFluxView;
    UILabel              *_fsFluxLab;
    
    
    YSPlayerController   *_realCtrl;              // 播放控制层
    YSPlayerMessageType   _realState;             // 预览状态
    BOOL                  _bRecording;            // 是否录像中
    BOOL                  _isIntercomAvailable;   // 设备是否支持对讲
    //    BOOL                  _isIntercom;            // 是否在进行对讲
    BOOL  _isSupportPtz;
    NSInteger _intercomType;
    
    float                 _fVideoRate;            // 播放视图宽高比
    BOOL                  _bFullScreen;           // 是否全屏显示中
    BOOL                  _bStopForDisappear;     // 是否是暂时性退出预览
    
    NSCondition          *_intercomCondition;     // 对讲锁
    
    CMMotionManager      *_motionManager;         // 加速计控制对象
    
    BOOL                  _bEnableShowAlertView;  // 是否允许弹出框
    BOOL                  _shouldActivePlay;      // 激活app是否需要恢复播放
    
    long                  _lTotleStreamLen;       // 当前总流量
    long                  _l3GStreamLen;          // 3G下流量之和
    
    BOOL                 _bStatusBarHide;         // 状态栏是否隐藏
    
    int _videoLevel;
    
    CGFloat sizeWidth;
    
    BOOL isstop;
    
    NSMutableArray *imageArr;
    
}

@property (nonatomic, assign) BOOL              bPlaying;
@property (nonatomic, assign) BOOL              bRecording;
@property (nonatomic, strong) IntercomView     *intercomView;
@property (nonatomic, strong) MBProgressHUD    *hud;
@property (nonatomic, copy) NSString *safeKey;
@property (nonatomic, copy) NSString *recordPicPath;

//视频保存路径 by dxw
@property (nonatomic, copy) NSString *recordPath;

@property (nonatomic, strong) NSArray *videoLevels;
@property (nonatomic, strong) UISwitch *soundSwitch;

@end

@implementation RealPlayViewController

@synthesize cameraInfo = _cameraInfo;
@dynamic bPlaying;
@dynamic bRecording;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sizeWidth = [UIScreen mainScreen].bounds.size.width;
    
    imageArr = [ArchiverCacheHelper getLocaldataBykey:Capture_Archiver_Key filePath:Capture_Archiver_Path];
    if (!imageArr)
        imageArr  = [[NSMutableArray alloc] init];
    
    [self initData];
    [self initView];
    
    // 加速计对象
    _motionManager = [[CMMotionManager alloc] init];
    [YSCommonMethods resetOritationWithMotion:_motionManager];
    
    _videoLevel = HighQuality;
    
    [self realPlay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.soundSwitch];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:UIBarButtonItemStyleDone target:self action:@selector(showImageHandler)];
    
}

- (void)dealloc
{
    [self stopPlay];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
    [self moveCtrl];
    
    if (_bStopForDisappear)
    {
        [self realPlay];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 关闭对讲
    if ([_realCtrl isIntercom])
    {
        [self stopIntercom];
        [self closeIntercomView];
    }
    
    [_realCtrl stopRecord];
    
    // 如果视频开启中，停止播放
    if (_realState == YSPlayerMsgRealPlaySuccess)
    {
        [_realCtrl stopRealPlay];
    }
    
    if (_realState != YSPlayerMsgRealPlayStop)
    {
        [_realCtrl stopRealPlay];
        _bStopForDisappear = YES;
    }
    else
    {
        _bStopForDisappear = NO;
    }
}

- (void)appWillResignActive
{
    if (_realState == YSPlayerMsgRealPlaySuccess)
    {
        ALCcontext *alcContext = alcGetCurrentContext();
        
        if (NULL != alcContext) {
            alcMakeContextCurrent(NULL);
        }
    }
    
    // 关闭对讲
    if ([_realCtrl isIntercom])
    {
        [_realCtrl stopIntercom];
        [self closeIntercomView];
    }
    
    if (_realState != YSPlayerMsgRealPlayStop && _realState != YSPlayerMsgRealPlayDeviceOffline && _realState != YSPlayerMsgRealPlayNoPermission)
    {
        [_realCtrl stopRealPlay];
        _shouldActivePlay = YES;
    }
    
}

- (void)appDidBecomeActive
{
    if (_shouldActivePlay)
    {
        [self realPlay];
        _shouldActivePlay = NO;
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (!_realView.fullScreenBtn)
        return;
    NSLog(@"%f和%f",self.view.width,self.view.height);
    
}

//视图旋转方向发生改变时会自动调用
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

#pragma mark -
#pragma mark ui methods

- (CGFloat)navBarHeight
{
    if (IS_IOS7_OR_LATER)
    {
        return 64;
    }
    
    return 0;
}

/**
 *  初始化视图
 */
- (void)initView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.view.backgroundColor = UIColorFromRGB(0xeaeaea, 1.0f);
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //    _titleView = [[TipsPublicView alloc] initWithFrame:CGRectMake(0, gfStatusBarSpace, sizeWidth, 44) withTitle:_cameraInfo.cameraName];
    //    [_titleView addBackBtnTouchEvent:self action:@selector(onClickBackBtn)];
    
    self.title = _cameraInfo.cameraName;
    
    int nHeight = (int)(sizeWidth / _fVideoRate);
    _realView = [[RealView alloc] initWithFrame:CGRectMake(0, [self navBarHeight], sizeWidth ,(float)nHeight)];
    
    
    [_realView addTarget:self action:@selector(onClickPlayBtn:) forEventEX:REALVIEW_EVENT_PLAYBTNTOUCHUPINSIDE];
    [_realView addTarget:self action:@selector(onClickStopBtn:) forEventEX:REALVIEW_EVENT_STOPBTNTOUCHUPINSIDE];
    [_realView addTarget:self action:@selector(oneTapView:) forEventEX:REALVIEW_EVENT_ONETAPVIEW];
    [_realView addTarget:self action:@selector(onTouchThumbnil:) forEventEX:REALVIEW_EVENT_THUMBNAILTOUCH];
    [_realView addTarget:self action:@selector(onRealViewZoomUp:) forEventEX:REALVIEW_EVENT_ZOOMUP];
    [_realView addTarget:self action:@selector(onRealViewZoomOff:) forEventEX:REALVIEW_EVENT_ZOOMOFF];
    __weak __typeof(YSPlayerController)*realCtrlSelf = _realCtrl;
    __weak __typeof(YSCameraInfo)*cameraSelf = _cameraInfo;
    _realView.changeVideoQualityClick = ^(NSInteger type){
        [realCtrlSelf changeRealPlayVideoLevelWithCameraId:cameraSelf.cameraId videoLevel:type];
    };
    _realView.changeVoiceClick= ^(BOOL ison){
        [realCtrlSelf setAudioOpen:ison];
    };
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(RealView)*weakrealView = _realView;
    _realView.changeFullClick= ^(BOOL isfull){
        weakSelf.navigationController.navigationBarHidden = isfull;
        if (isfull)
            [YSCommonMethods forbitRotatePortraitOrientation:UIInterfaceOrientationLandscapeLeft];
        else
            [YSCommonMethods forbitRotatePortraitOrientation];
        weakrealView.y = isfull ? 0 : [weakSelf navBarHeight];
        weakrealView.height = isfull ? weakSelf.view.height : (float)nHeight;
        weakrealView.width= weakSelf.view.width;
        [SharedAppUtil defaultCommonUtil].tabBarController.tabBar.hidden = isfull;
    };
    
    [self.view addSubview:_realView];
    
    int nCtrlViewY = _realView.frame.origin.y + _realView.frame.size.height;
    _ctrlView = [[UIView alloc] initWithFrame:CGRectMake(0, nCtrlViewY, sizeWidth, screenSize.height - nCtrlViewY)];
    _ctrlView.backgroundColor = UIColorFromRGB(0xf2eff6, 1.0f);
    [self.view addSubview:_ctrlView];
    
    _toolbarBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (_ctrlView.frame.size.height-PLAYBTN_HEIGHT-44)/2, _ctrlView.frame.size.width, PLAYBTN_HEIGHT)];
    _toolbarBgView.backgroundColor = [UIColor clearColor];
    _toolbarBgView.showsVerticalScrollIndicator = NO;
    _toolbarBgView.showsHorizontalScrollIndicator = NO;
    _toolbarBgView.contentSize = CGSizeMake(1000, PLAYBTN_HEIGHT);
    _toolbarBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [_ctrlView addSubview:_toolbarBgView];
    
    _toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeWidth, PLAYBTN_HEIGHT)];
    _toolbarView.backgroundColor = [UIColor clearColor];
    [_toolbarBgView addSubview:_toolbarView];
    
    _intercomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT)];
    [_intercomBtn setBackgroundImage:[UIImage imageNamed:@"talk.png"] forState:UIControlStateNormal];
    [_intercomBtn setBackgroundImage:[UIImage imageNamed:@"talk.png"] forState:UIControlStateHighlighted];
    [_intercomBtn setBackgroundImage:[UIImage imageNamed:@"talk_disable.png"] forState:UIControlStateDisabled];
    [_intercomBtn addTarget:self action:@selector(onClickIntercomBtn) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:_intercomBtn];
    
    UIImage * imgCapture = [UIImage imageNamed:@"play-previously.png"];
    _captureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT)];
    [_captureBtn setBackgroundImage:imgCapture forState:UIControlStateNormal];
    [_captureBtn setBackgroundImage:[UIImage imageNamed:@"play-previously.png"] forState:UIControlStateHighlighted];
    [_captureBtn setBackgroundImage:[UIImage imageNamed:@"previously_disable.png"] forState:UIControlStateDisabled];
    [_captureBtn addTarget:self action:@selector(onClickCaptureBtn) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:_captureBtn];
    
    _recordBtn = [[RecordingBtnView alloc] initWithFrame:CGRectMake(0, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT)];
    [_recordBtn addBtnClickEvent:self sel:@selector(onClickRecordBtn)];
    [_toolbarView addSubview:_recordBtn];
    
    _videoQualityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT)];
    [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"hd.png"] forState:UIControlStateNormal];
    [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"hd.png"] forState:UIControlStateHighlighted];
    [_videoQualityBtn addTarget:self action:@selector(onClickVideoQualityBtn) forControlEvents:UIControlEventTouchUpInside];
    //    [_toolbarView addSubview:_videoQualityBtn];
    
    _ptzCtrlBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT)];
    [_ptzCtrlBtn setBackgroundImage:[UIImage imageNamed:@"play_ptz.png"] forState:UIControlStateNormal];
    [_ptzCtrlBtn setBackgroundImage:[UIImage imageNamed:@"play_ptz.png"] forState:UIControlStateHighlighted];
    [_ptzCtrlBtn setBackgroundImage:[UIImage imageNamed:@"play_ptz_disable.png"] forState:UIControlStateDisabled];
    [_ptzCtrlBtn addTarget:self action:@selector(onClickPtzCtrlBtn) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:_ptzCtrlBtn];
    
    _fsToolbarView = [[UIView alloc] initWithFrame:CGRectMake(90, sizeWidth - FS_PLAYBTN_HEIGHT - 15, screenSize.height - 90, FS_PLAYBTN_HEIGHT)];
    _fsToolbarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_fsToolbarView];
    _fsToolbarView.alpha = 0.0f;
    
    int nLeft = 5;
    int nBtnSpace = 20;
    _fsStopBtn = [[UIButton alloc] initWithFrame:CGRectMake(nLeft, 0, FS_PLAYBTN_HEIGHT, FS_PLAYBTN_HEIGHT)];
    [_fsStopBtn setBackgroundImage:[UIImage imageNamed:@"full_stop.png"] forState:UIControlStateNormal];
    [_fsStopBtn setBackgroundImage:[UIImage imageNamed:@"full_stop_sel.png"] forState:UIControlStateHighlighted];
    [_fsStopBtn addTarget:self action:@selector(onClickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_fsToolbarView addSubview:_fsStopBtn];
    
    nLeft += FS_PLAYBTN_HEIGHT + nBtnSpace;
    _fsCaptureBtn = [[UIButton alloc] initWithFrame:CGRectMake(nLeft, 0, FS_PLAYBTN_HEIGHT, FS_PLAYBTN_HEIGHT)];
    [_fsCaptureBtn setBackgroundImage:[UIImage imageNamed:@"full_previously.png"] forState:UIControlStateNormal];
    [_fsCaptureBtn setBackgroundImage:[UIImage imageNamed:@"full_previously_sel.png"] forState:UIControlStateHighlighted];
    [_fsCaptureBtn addTarget:self action:@selector(onClickCaptureBtn) forControlEvents:UIControlEventTouchUpInside];
    [_fsToolbarView addSubview:_fsCaptureBtn];
    
    nLeft += FS_PLAYBTN_HEIGHT + nBtnSpace;
    _fsRecordBtn = [[RecordingBtnView alloc] initWithFrame:CGRectMake(nLeft, 0, FS_PLAYBTN_HEIGHT, FS_PLAYBTN_HEIGHT)];
    [_fsRecordBtn setRecordingButtonImage:[UIImage imageNamed:@"full_video_now.png"] highlightImage:[UIImage imageNamed:@"full_video_now_sel.png"]];
    [_fsRecordBtn setButtonImage:[UIImage imageNamed:@"full_video.png"] highlightImage:[UIImage imageNamed:@"full_video_sel.png"]];
    [_fsRecordBtn addBtnClickEvent:self sel:@selector(onClickRecordBtn)];
    [_fsToolbarView addSubview:_fsRecordBtn];
    
    nLeft = _fsToolbarView.frame.size.width - 90 - FS_PLAYBTN_HEIGHT;
    
    _fsRealFluxView = [[RealFluxDataView alloc] initWithFrame:CGRectMake(nLeft, 0, FS_PLAYBTN_HEIGHT, FS_PLAYBTN_HEIGHT)];
    _fsRealFluxView.backgroundColor = [UIColor clearColor];
    _fsFluxLab = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, _fsRealFluxView.frame.size.width - 4, _fsRealFluxView.frame.size.height - 20)];
    _fsFluxLab.backgroundColor = [UIColor clearColor];
    _fsFluxLab.font = [UIFont systemFontOfSize:10.0f];
    _fsFluxLab.numberOfLines = 2;
    _fsFluxLab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    _fsFluxLab.textAlignment = NSTextAlignmentCenter;
    [_fsRealFluxView addSubview:_fsFluxLab];
    [_fsToolbarView addSubview:_fsRealFluxView];
    
    _fsFluxLab.text = @"0k/s\n0MB";
    
    [self.view sendSubviewToBack:_ctrlView];
    
}

/**
 *  初始化数据
 */
- (void)initData
{
    _fVideoRate = 16/9.0f;  // 标准CIF视频宽高比
    _bFullScreen = NO;
    _bEnableShowAlertView = YES;
    _shouldActivePlay = NO;
    g_lRealTotleFlux = 0;
    
    _intercomType = 0;
    
    _intercomCondition = [[NSCondition alloc] init];
    
    _realCtrl = [[YSPlayerController alloc] initWithDelegate:self];
    
}

/**
 *  窗口位置刷新
 */
- (void)moveCtrl
{
    // 竖屏下按钮控制
    int nBtnSpace = (sizeWidth - PLAYBTN_HEIGHT*3)/4;
    int nLeft = nBtnSpace;
    int nBtnCount = 3;
    
    if (_isIntercomAvailable)
    {
        _intercomBtn.frame = CGRectMake(nLeft, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT);
        _intercomBtn.hidden = NO;
        nLeft += PLAYBTN_HEIGHT + nBtnSpace;
        nBtnCount++;
    }
    else
    {
        _intercomBtn.hidden = YES;
    }
    _captureBtn.frame = CGRectMake(nLeft, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT);
    nLeft += PLAYBTN_HEIGHT + nBtnSpace;
    
    _recordBtn.frame = CGRectMake(nLeft, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT);
    nLeft += PLAYBTN_HEIGHT + nBtnSpace;
    
    _videoQualityBtn.frame = CGRectMake(nLeft, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT);
    _videoQualityBtn.hidden = NO;
    nLeft += PLAYBTN_HEIGHT + nBtnSpace;
    
    _ptzCtrlBtn.frame = CGRectMake(nLeft, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT);
    _ptzCtrlBtn.hidden = NO;
    nLeft += PLAYBTN_HEIGHT + nBtnSpace;
    ++nBtnCount;
    
    _toolbarView.frame = CGRectMake(0, 0, PLAYBTN_HEIGHT*nBtnCount + nBtnSpace*(nBtnCount+0.4), PLAYBTN_HEIGHT);
    _toolbarBgView.contentSize = CGSizeMake(_toolbarView.frame.size.width, PLAYBTN_HEIGHT);
    
    _ptzCtrlBtn.hidden = YES;
    if(_isSupportPtz){
        _ptzCtrlBtn.hidden = NO;
    }
}

/**
 *  视图刷新
 */
- (void)updateUI
{
    if (!_bFullScreen)
    {
        [self hideFSCtrlView:NO];
        
        _titleView.hidden = NO;
        _ctrlView.hidden = NO;
        _fsToolbarView.hidden = YES;
        _fsToolbarView.alpha = 0.0f;
    }
    else
    {
        [self hideFSCtrlView:YES];
        
        _titleView.hidden = YES;
        _ctrlView.hidden = YES;
        _fsToolbarView.hidden = NO;
    }
    
    // vedio quality
    if (_videoLevel == HighQuality)
    {
        [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"hd.png"] forState:UIControlStateNormal];
        [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"hd.png"] forState:UIControlStateHighlighted];
        [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"hd_disable.png"] forState:UIControlStateDisabled];
    }
    else if (_videoLevel == MiddleQuality)
    {
        [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"balanced.png"] forState:UIControlStateNormal];
        [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"balanced.png"] forState:UIControlStateHighlighted];
        [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"balanced_disable.png"] forState:UIControlStateDisabled];
    }
    else if (_videoLevel == LowQuality)
    {
        [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"flunet.png"] forState:UIControlStateNormal];
        [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"flunet.png"] forState:UIControlStateHighlighted];
        [_videoQualityBtn setBackgroundImage:[UIImage imageNamed:@"flunet_disable.png"] forState:UIControlStateDisabled];
    }
    
    if (_realState == YSPlayerMsgRealPlaySuccess)
    {
        _captureBtn.enabled = YES;
        [_recordBtn enableBtn:YES];
        _mailBtn.enabled = YES;
        _intercomBtn.enabled = YES;
        _videoQualityBtn.enabled = YES;
        _shareBtn.enabled = YES;
        _ptzCtrlBtn.enabled = YES;
    }
    else if (_realState == YSPlayerMsgRealPlayStop)
    {
        _captureBtn.enabled = NO;
        [_recordBtn enableBtn:NO];
        _mailBtn.enabled = YES;
        _intercomBtn.enabled = NO;
        _videoQualityBtn.enabled = YES;
        _shareBtn.enabled = YES;
        _ptzCtrlBtn.enabled = NO;
        
        _fsToolbarView.alpha = 0.0f;
    }
    else if (_realState == YSPlayerMsgRealPlayDeviceOffline || _realState == YSPlayerMsgRealPlayNoPermission)
    {
        _captureBtn.enabled = NO;
        [_recordBtn enableBtn:NO];
        _mailBtn.enabled = NO;
        _intercomBtn.enabled = NO;
        _videoQualityBtn.enabled = NO;
        _shareBtn.enabled = NO;
        _ptzCtrlBtn.enabled = NO;
    }
    else if (_realState == YSPlayerMsgRealPlayStart)
    {
        _captureBtn.enabled = NO;
        [_recordBtn enableBtn:NO];
        _mailBtn.enabled = NO;
        _intercomBtn.enabled = NO;
        _videoQualityBtn.enabled = NO;
        _shareBtn.enabled = YES;
        _ptzCtrlBtn.enabled = NO;
    }
    else
    {
        _captureBtn.enabled = NO;
        [_recordBtn enableBtn:NO];
        _mailBtn.enabled = NO;
        _intercomBtn.enabled = NO;
        _videoQualityBtn.enabled = NO;
        _shareBtn.enabled = NO;
        _ptzCtrlBtn.enabled = NO;
    }
    
    if (!_bRecording)
    {
        [_realView stopRecording];
        [_recordBtn stopRecording];
        [_fsRecordBtn stopRecording];
    }
    
    
}

/**
 *  显示视频质量切换视图
 */
- (void)showVideoQualityView
{
    CGRect rcCtrl = _ctrlView.frame;
    
    UIView * qualityView = [[UIView alloc] initWithFrame:CGRectMake(0, rcCtrl.size.height, rcCtrl.size.width, rcCtrl.size.height)];
    qualityView.backgroundColor = [UIColor clearColor];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, qualityView.frame.size.width, qualityView.frame.size.height)];
    bgView.image = [[self getImageFromView:_ctrlView] applyExtraLightEffect];
    [qualityView addSubview:bgView];
    
    UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(rcCtrl.size.width - 50, 0, 50, 50)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"play_close.png"] forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"play_close_sel.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(onClickCloseView:) forControlEvents:UIControlEventTouchUpInside];
    [qualityView addSubview:closeBtn];
    
    NSMutableArray * arrBtn = [[NSMutableArray alloc] initWithCapacity:3];
    
    if (0 < [self.videoLevels count] && [[self.videoLevels objectAtIndex:0] intValue] != 0)
    {
        UIButton * flunetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT)];
        [flunetBtn setBackgroundImage:[UIImage imageNamed:@"flunet.png"] forState:UIControlStateNormal];
        [flunetBtn setBackgroundImage:[UIImage imageNamed:@"flunet_sel.png"] forState:UIControlStateHighlighted];
        [flunetBtn setBackgroundImage:[UIImage imageNamed:@"flunet_sel.png"] forState:UIControlStateSelected];
        [flunetBtn addTarget:self action:@selector(onClickQualitySelect:) forControlEvents:UIControlEventTouchUpInside];
        flunetBtn.tag = LowQuality;
        [qualityView addSubview:flunetBtn];
        
        //        if (_cameraInfo.m_iResLevel == LowQuality)
        //        {
        //            flunetBtn.selected = YES;
        //        }
        //        else
        //        {
        //            flunetBtn.selected = NO;
        //        }
        
        [arrBtn addObject:flunetBtn];
    }
    
    if (1 < [self.videoLevels count] && [[self.videoLevels objectAtIndex:1] intValue] != 0)
    {
        UIButton * balancedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT)];
        [balancedBtn setBackgroundImage:[UIImage imageNamed:@"balanced.png"] forState:UIControlStateNormal];
        [balancedBtn setBackgroundImage:[UIImage imageNamed:@"balanced_sel.png"] forState:UIControlStateHighlighted];
        [balancedBtn setBackgroundImage:[UIImage imageNamed:@"balanced_sel.png"] forState:UIControlStateSelected];
        [balancedBtn addTarget:self action:@selector(onClickQualitySelect:) forControlEvents:UIControlEventTouchUpInside];
        balancedBtn.tag = MiddleQuality;
        [qualityView addSubview:balancedBtn];
        
        //        if (_cameraInfo.m_iResLevel == MiddleQuality)
        //        {
        //            balancedBtn.selected = YES;
        //        }
        //        else
        //        {
        //            balancedBtn.selected = NO;
        //        }
        
        [arrBtn addObject:balancedBtn];
    }
    
    if (2 < [self.videoLevels count] && [[self.videoLevels objectAtIndex:2] intValue] != 0)
    {
        UIButton * hdBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT)];
        [hdBtn setBackgroundImage:[UIImage imageNamed:@"hd.png"] forState:UIControlStateNormal];
        [hdBtn setBackgroundImage:[UIImage imageNamed:@"hd_sel.png"] forState:UIControlStateHighlighted];
        [hdBtn setBackgroundImage:[UIImage imageNamed:@"hd_sel.png"] forState:UIControlStateSelected];
        [hdBtn addTarget:self action:@selector(onClickQualitySelect:) forControlEvents:UIControlEventTouchUpInside];
        hdBtn.tag = HighQuality;
        [qualityView addSubview:hdBtn];
        
        //        if (_cameraInfo.m_iResLevel == HighQuality)
        //        {
        //            hdBtn.selected = YES;
        //        }
        //        else
        //        {
        //            hdBtn.selected = NO;
        //        }
        
        [arrBtn addObject:hdBtn];
    }
    
    int nBtnCount = (int)[arrBtn count];
    int nSpace = (sizeWidth - PLAYBTN_HEIGHT*nBtnCount - 8)/(nBtnCount + 1);
    int nLeft = nSpace + 4;
    int nTop = (qualityView.frame.size.height - PLAYBTN_HEIGHT) / 2;
    
    for (int i=0; i<nBtnCount; i++)
    {
        UIButton * btn = [arrBtn objectAtIndex:i];
        btn.frame = CGRectMake(nLeft, nTop, PLAYBTN_HEIGHT, PLAYBTN_HEIGHT);
        
        nLeft += PLAYBTN_HEIGHT + nSpace;
    }
    
    [arrBtn removeAllObjects];
    
    [_ctrlView addSubview:qualityView];
    qualityView.tag = VIEW_NOTOUCH_TAG;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    
    qualityView.frame = CGRectMake(0, 0, rcCtrl.size.width, rcCtrl.size.height);
    
    [UIView commitAnimations];
    
}

/**
 *  显示对讲视图
 */
- (void)showIntercomView:(BOOL)bDenosing
{
    
    CGRect rcCtrl = _ctrlView.frame;
    
    UIView * intercomView = [[UIView alloc] initWithFrame:CGRectMake(0, rcCtrl.size.height, rcCtrl.size.width, rcCtrl.size.height)];
    intercomView.backgroundColor = [UIColor clearColor];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, intercomView.frame.size.width, intercomView.frame.size.height)];
    bgView.image = [[self getImageFromView:_ctrlView] applyExtraLightEffect];
    [intercomView addSubview:bgView];
    
    IntercomView * itView = [[IntercomView alloc] initWithFrame:CGRectMake(0, 0, rcCtrl.size.width, rcCtrl.size.height)];
    itView.realCtrl = _realCtrl;
    if (bDenosing)
    {
        itView.intercomType = INTERCOM_TYPE_DUPLEX;
    }
    else
    {
        itView.intercomType = INTERCOM_TYPE_SEMIDUPLEX;
    }
    [itView initView];
    [intercomView addSubview:itView];
    self.intercomView = itView;
    
    UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(rcCtrl.size.width - 50, 0, 50, 50)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"play_close.png"] forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"play_close_sel.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(onClickCloseIntercomView) forControlEvents:UIControlEventTouchUpInside];
    [intercomView addSubview:closeBtn];
    
    [_ctrlView addSubview:intercomView];
    intercomView.tag = VIEW_NOTOUCH_TAG;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35f];
    
    intercomView.frame = CGRectMake(0, 0, rcCtrl.size.width, rcCtrl.size.height);
    
    [UIView commitAnimations];
    
}


-(UIImage *)getImageFromView:(UIView *)orgView
{
    UIGraphicsBeginImageContext(orgView.bounds.size);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)onClickBackBtn
{
    [_realCtrl stopRealPlay];
    
    // 关闭设备常亮
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    // 停止加速计统计
    [_motionManager stopAccelerometerUpdates];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)onClickIntercomBtn
{
    // 判断ios7下麦克风权限
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
    {
        //requestRecordPermission
        [[AVAudioSession sharedInstance] requestRecordPermission:
         ^(BOOL granted) {
             if (!granted)
             {
                 [[[UIAlertView alloc] initWithTitle:nil message:@"萤石云视频需要访问您的麦克风。\n请在设置->隐私->麦克风中启用您的麦克风。" delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil] show];
             }
         }];
    }
    
    if (YSPlayerMsgRealPlaySuccess == _realState)
    {
        self.hud = [CAttention createWaitViewtoText:NSLocalizedString(@"开启对讲...", nil) toView:self.view];
        [self.view addSubview:self.hud];
        [self.hud show:YES];
        
        [_realCtrl setAudioOpen:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           BOOL bDenosing = YES; // 默认对讲开启全双工
                           if (_intercomType == 3)
                           {// 对讲只支持半双工
                               bDenosing = NO;
                           }
                           
                           BOOL bRet = [_realCtrl startIntercom:bDenosing];
                           
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [self.hud hide:YES];
                                              [self.hud removeFromSuperview];
                                              self.hud = nil;
                                              
                                              if (bRet)
                                              {
                                                  if (bDenosing)
                                                  {
                                                      [CAttention showCustomAutoHiddenAttention: NSLocalizedString(@"对讲开启成功, 你现在可以说话了.", nil)
                                                                                         toView:[UIApplication sharedApplication].keyWindow
                                                                                      toYOffset:0
                                                                                     toFontSize:nil
                                                                              toIsDimBackground:NO];
                                                  }
                                                  
                                                  [self showIntercomView:bDenosing];
                                                  
                                              }
                                              else
                                              {
                                                  
                                                  [CAttention showCustomAutoHiddenAttention:@"对讲开启失败"
                                                                                     toView:self.view
                                                                                  toYOffset:0
                                                                                 toFontSize:nil
                                                                          toIsDimBackground:NO];
                                              }
                                          });
                       });
    }
    
}

- (void)onClickCaptureBtn
{
    //百度
    if (YSPlayerMsgRealPlaySuccess == _realState)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        NSDate * date = [NSDate date];
        
        NSString *imgname = [dateFormatter stringFromDate:date];
        
        NSString *strPicName = [NSString stringWithFormat:@"%@_%@.jpg", [dateFormatter stringFromDate:date], _cameraInfo.deviceId];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString * strTimeInfo = [dateFormatter stringFromDate:date];
        NSRange rangeY = {0, 4};
        NSString *strYear = [strTimeInfo substringWithRange:rangeY];
        NSRange rangeM = {5, 2};
        NSString *strMonth = [strTimeInfo substringWithRange:rangeM];
        NSRange rangeD = {8, 2};
        NSString *strDay = [strTimeInfo substringWithRange:rangeD];
        NSString * strPicFolder = [YSCommonMethods configFilePath:[NSString stringWithFormat:@"/%@/%@/%@/", strYear, strMonth, strDay]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:strPicFolder])
        {
            if (![YSCommonMethods createFolderAtPath:strPicFolder])
            {
                return;
            }
        }
        
        // 图路径
        NSString *picPath = [NSString stringWithFormat:@"%@%@", strPicFolder, strPicName];
        
        if ([_realCtrl captureWithPath:picPath])
        {
            [_realView showThumbnail:picPath andThumbType:ThumbnailCapture];
            
            UIImage *img = [UIImage imageWithContentsOfFile:picPath];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"%@.jpg",imgname]];
            BOOL result = [UIImagePNGRepresentation(img)writeToFile: filePath    atomically:YES];  // 写入本地沙盒
            if (result)
            {
                
                UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
                
                
                NSDictionary *dict =  @{@"time" : imgname,
                                        @"path" : filePath};
                [imageArr addObject:dict];
                [ArchiverCacheHelper saveNSMutableArrayToLoacl:imageArr key:Capture_Archiver_Key filePath:Capture_Archiver_Path];
            }
        }
        else
        {
            // 提示信息
            [CAttention showAutoHiddenAttention:NSLocalizedString(@"抓图失败", nil) toView:self.view];
        }
    }
}

- (void)onClickRecordBtn
{
    if (YSPlayerMsgRealPlaySuccess == _realState)
    {
        if (_bRecording)
        {
            if ([_realCtrl stopRecord])
            {
                [_recordBtn stopRecording];
                [_fsRecordBtn stopRecording];
                [_realView stopRecording];
                
                UISaveVideoAtPathToSavedPhotosAlbum(_recordPath, self, nil, nil);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功，请在本地相册中查看！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                [_realView showThumbnail:_recordPicPath andThumbType:ThumbnailRecord];
                
                _bRecording = NO;
            }
            else
            {
                [CAttention showAutoHiddenAttention:NSLocalizedString(@"停止录像失败", nil) toView:self.view];
            }
        }
        else
        {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
            NSDate * date = [NSDate date];
            NSString *strPicName = [NSString stringWithFormat:@"%@_%@.jpg", [dateFormatter stringFromDate:date], _cameraInfo.deviceId];
            NSString *recordFileName = [NSString stringWithFormat:@"%@_%@_%d.mov", _cameraInfo.deviceId,
                                        _cameraInfo.cameraName, (int)_cameraInfo.cameraNo];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * strTimeInfo = [dateFormatter stringFromDate:date];
            NSRange rangeY = {0, 4};
            NSString *strYear = [strTimeInfo substringWithRange:rangeY];
            NSRange rangeM = {5, 2};
            NSString *strMonth = [strTimeInfo substringWithRange:rangeM];
            NSRange rangeD = {8, 2};
            NSString *strDay = [strTimeInfo substringWithRange:rangeD];
            NSString * strPicFolder = [YSCommonMethods configFilePath:[NSString stringWithFormat:@"/%@/%@/%@/", strYear, strMonth, strDay]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:strPicFolder])
            {
                if (![YSCommonMethods createFolderAtPath:strPicFolder])
                {
                    return;
                }
            }
            
            self.recordPicPath = [NSString stringWithFormat:@"%@%@", strPicFolder, strPicName];
            NSString *recordPath = [NSString stringWithFormat:@"%@%@", strPicFolder, recordFileName];
            
            if ([_realCtrl startRecordWithRecordPath:recordPath capturePath:_recordPicPath])
            {
                [_recordBtn startRecording];
                [_fsRecordBtn startRecording];
                [_realView startRecording];
                
                _recordPath = recordPath;
                _bRecording = YES;
            }
            else
            {
                [CAttention showAutoHiddenAttention:NSLocalizedString(@"开始录像失败", nil) toView:self.view];
            }
        }
    }
}

- (void)onClickVideoQualityBtn
{
    [self showVideoQualityView];
}

- (void)onClickCloseView:(id)sender
{
    UIView * superView = [sender superview];
    
    [UIView animateWithDuration:0.3 animations:^{
        superView.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, superView.frame.size.height);
    } completion:^(BOOL finished) {
        [superView removeFromSuperview];
    }];
    
}

- (void)closeTagView
{
    UIView * view = (UIView *)[_ctrlView viewWithTag:VIEW_NOTOUCH_TAG];
    if (view)
    {
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, view.frame.size.height);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

- (void)onClickCloseIntercomView
{
    [self stopIntercom];
}

- (void)onClickQualitySelect:(id)sender
{
    
    [self procVideoQualitySet:sender];
}

// 视频质量设置进程函数
- (void)procVideoQualitySet:(id)sender
{
    UIButton * qualityBtn = (UIButton *)sender;
    int nQuality = (int)qualityBtn.tag;
    
    [_realCtrl changeRealPlayVideoLevelWithCameraId:_cameraInfo.cameraId videoLevel:nQuality];
    
}


#pragma mark ptzCtrl methods

- (void)onClickPtzCtrlBtn
{
    [self showPtzCtrlView];
}

/**
 *  云台控制视图
 */
- (void)showPtzCtrlView
{
    if (_ctrlView.bounds.origin.y > 0.00000001f || _ctrlView.bounds.origin.y < -0.00000001f)
    {
        CGRect bounds = _ctrlView.bounds;
        bounds.origin.y = 0.0f;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        
        _ctrlView.bounds = bounds;
        
        [UIView commitAnimations];
        
        usleep(200 * 1000);
    }
    
    CGRect rcCtrl = _ctrlView.frame;
    
    UIView * ptzCtView = [[UIView alloc] initWithFrame:CGRectMake(0, rcCtrl.size.height, rcCtrl.size.width, rcCtrl.size.height)];
    ptzCtView.backgroundColor = [UIColor clearColor];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ptzCtView.frame.size.width, ptzCtView.frame.size.height)];
    bgView.image = [[self getImageFromView:_ctrlView] applyExtraLightEffect];
    [ptzCtView addSubview:bgView];
    
    UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(rcCtrl.size.width - 50, 0, 50, 50)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"play_close.png"] forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"play_close_sel.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(onClickCloseView:) forControlEvents:UIControlEventTouchUpInside];
    [ptzCtView addSubview:closeBtn];
    
    UIView * ptzView = [[UIView alloc] initWithFrame:CGRectMake((ptzCtView.frame.size.width - PTZ_CTRLVIEW_WIDTH) / 2, (ptzCtView.frame.size.height - PTZ_CTRLVIEW_WIDTH) / 2, PTZ_CTRLVIEW_WIDTH, PTZ_CTRLVIEW_WIDTH)];
    ptzView.backgroundColor = [UIColor clearColor];
    [ptzCtView addSubview:ptzView];
    
    UIImageView * ptzSelView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PTZ_CTRLVIEW_WIDTH, PTZ_CTRLVIEW_WIDTH)];
    ptzSelView.image = [UIImage imageNamed:@"ptz_bg.png"];
    [ptzView addSubview:ptzSelView];
    ptzSelView.tag = PTZVIEW_BGVIEW_TAG;
    
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (PTZ_CTRLVIEW_WIDTH-70)/2, (PTZ_CTRLVIEW_WIDTH-70)/2, 70)];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    [leftBtn addTarget:self action:@selector(onTouchDownPtzLeftBtn:) forControlEvents:UIControlEventTouchDown];
    [leftBtn addTarget:self action:@selector(onTouchUpPtzLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn addTarget:self action:@selector(onTouchUpPtzLeftBtn:) forControlEvents:UIControlEventTouchUpOutside];
    [ptzView addSubview:leftBtn];
    
    UIButton * topBtn = [[UIButton alloc] initWithFrame:CGRectMake((PTZ_CTRLVIEW_WIDTH-70)/2, 0,(PTZ_CTRLVIEW_WIDTH-70)/2, 70)];
    [topBtn setBackgroundColor:[UIColor clearColor]];
    [topBtn addTarget:self action:@selector(onTouchDownPtzUpBtn:) forControlEvents:UIControlEventTouchDown];
    [topBtn addTarget:self action:@selector(onTouchUpPtzUpBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topBtn addTarget:self action:@selector(onTouchUpPtzUpBtn:) forControlEvents:UIControlEventTouchUpOutside];
    [ptzView addSubview:topBtn];
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake((PTZ_CTRLVIEW_WIDTH-70)/2 + 70, (PTZ_CTRLVIEW_WIDTH-70)/2, (PTZ_CTRLVIEW_WIDTH-70)/2, 70)];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn addTarget:self action:@selector(onTouchDownPtzRightBtn:) forControlEvents:UIControlEventTouchDown];
    [rightBtn addTarget:self action:@selector(onTouchUpPtzRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(onTouchUpPtzRightBtn:) forControlEvents:UIControlEventTouchUpOutside];
    [ptzView addSubview:rightBtn];
    
    UIButton * bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake((PTZ_CTRLVIEW_WIDTH-70)/2, (PTZ_CTRLVIEW_WIDTH-70)/2 + 70, (PTZ_CTRLVIEW_WIDTH-70)/2, 70)];
    [bottomBtn setBackgroundColor:[UIColor clearColor]];
    [bottomBtn addTarget:self action:@selector(onTouchDownPtzDownBtn:) forControlEvents:UIControlEventTouchDown];
    [bottomBtn addTarget:self action:@selector(onTouchUpPtzDownBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn addTarget:self action:@selector(onTouchUpPtzDownBtn:) forControlEvents:UIControlEventTouchUpOutside];
    [ptzView addSubview:bottomBtn];
    
    UIButton * ptzFlipBtn = [[UIButton alloc] initWithFrame:CGRectMake((PTZ_CTRLVIEW_WIDTH - 70)/2, (PTZ_CTRLVIEW_WIDTH - 70)/2, 70, 70)];
    [ptzFlipBtn setBackgroundImage:[UIImage imageNamed:@"ptz_turn.png"] forState:UIControlStateNormal];
    [ptzFlipBtn setBackgroundImage:[UIImage imageNamed:@"ptz_turn_sel.png"] forState:UIControlStateHighlighted];
    [ptzFlipBtn addTarget:self action:@selector(onClickPtzFlipBtn:) forControlEvents:UIControlEventTouchUpInside];
    [ptzView addSubview:ptzFlipBtn];
    ptzFlipBtn.tag = PTZVIEW_FLIP_BTN;
    
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint center = ptzFlipBtn.center;
    center.x += 1;
    activity.center = center;
    activity.hidesWhenStopped = YES;
    [ptzView addSubview:activity];
    activity.tag = PTZVIEW_FLIP_ACTIVITY;
    activity.hidden = YES;
    
    [_ctrlView addSubview:ptzCtView];
    ptzCtView.tag = VIEW_NOTOUCH_TAG;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    
    ptzCtView.frame = CGRectMake(0, 0, rcCtrl.size.width, rcCtrl.size.height);
    
    [UIView commitAnimations];
}

// 云台控制功能 ptzCtrl
- (void)onTouchDownPtzUpBtn:(id)sender
{
    UIView * ptzCtView = [(UIButton *)sender superview];
    UIImageView * ptzBgView = (UIImageView *)[ptzCtView viewWithTag:PTZVIEW_BGVIEW_TAG];
    ptzBgView.image = [UIImage imageNamed:@"ptz_up_sel.png"];
    
    [YSPlayerController ptzStartUpWithCamera:_cameraInfo.cameraId
                                    cameraNo:_cameraInfo.cameraNo];
}

- (void)onTouchUpPtzUpBtn:(id)sender
{
    UIView * ptzCtView = [(UIButton *)sender superview];
    UIImageView * ptzBgView = (UIImageView *)[ptzCtView viewWithTag:PTZVIEW_BGVIEW_TAG];
    ptzBgView.image = [UIImage imageNamed:@"ptz_bg.png"];
    
    [YSPlayerController ptzStopUpWithCamera:_cameraInfo.cameraId
                                   cameraNo:_cameraInfo.cameraNo];
}

- (void)onTouchDownPtzDownBtn:(id)sender
{
    UIView * ptzCtView = [(UIButton *)sender superview];
    UIImageView * ptzBgView = (UIImageView *)[ptzCtView viewWithTag:PTZVIEW_BGVIEW_TAG];
    ptzBgView.image = [UIImage imageNamed:@"ptz_bottom_sel.png"];
    
    [YSPlayerController ptzStartDownWithCamera:_cameraInfo.cameraId
                                      cameraNo:_cameraInfo.cameraNo];
}

- (void)onTouchUpPtzDownBtn:(id)sender
{
    UIView * ptzCtView = [(UIButton *)sender superview];
    UIImageView * ptzBgView = (UIImageView *)[ptzCtView viewWithTag:PTZVIEW_BGVIEW_TAG];
    ptzBgView.image = [UIImage imageNamed:@"ptz_bg.png"];
    
    [YSPlayerController ptzStopDownWithCamera:_cameraInfo.cameraId
                                     cameraNo:_cameraInfo.cameraNo];
}

- (void)onTouchDownPtzLeftBtn:(id)sender
{
    UIView * ptzCtView = [(UIButton *)sender superview];
    UIImageView * ptzBgView = (UIImageView *)[ptzCtView viewWithTag:PTZVIEW_BGVIEW_TAG];
    ptzBgView.image = [UIImage imageNamed:@"ptz_left_sel.png"];
    
    [YSPlayerController ptzStartLeftWithCamera:_cameraInfo.cameraId
                                      cameraNo:_cameraInfo.cameraNo];
}

- (void)onTouchUpPtzLeftBtn:(id)sender
{
    UIView * ptzCtView = [(UIButton *)sender superview];
    UIImageView * ptzBgView = (UIImageView *)[ptzCtView viewWithTag:PTZVIEW_BGVIEW_TAG];
    ptzBgView.image = [UIImage imageNamed:@"ptz_bg.png"];
    
    [YSPlayerController ptzStopLeftWithCamera:_cameraInfo.cameraId
                                     cameraNo:_cameraInfo.cameraNo];
}

- (void)onTouchDownPtzRightBtn:(id)sender
{
    UIView * ptzCtView = [(UIButton *)sender superview];
    UIImageView * ptzBgView = (UIImageView *)[ptzCtView viewWithTag:PTZVIEW_BGVIEW_TAG];
    ptzBgView.image = [UIImage imageNamed:@"ptz_right_sel.png"];
    
    [YSPlayerController ptzStartRightWithCamera:_cameraInfo.cameraId
                                       cameraNo:_cameraInfo.cameraNo];
}

- (void)onTouchUpPtzRightBtn:(id)sender
{
    UIView * ptzCtView = [(UIButton *)sender superview];
    UIImageView * ptzBgView = (UIImageView *)[ptzCtView viewWithTag:PTZVIEW_BGVIEW_TAG];
    ptzBgView.image = [UIImage imageNamed:@"ptz_bg.png"];
    
    [YSPlayerController ptzStopRightWithCamera:_cameraInfo.cameraId
                                      cameraNo:_cameraInfo.cameraNo];
}

- (void)onClickPtzFlipBtn:(id)sender
{
    UIView * ptzView = (UIView *)[_ctrlView viewWithTag:VIEW_NOTOUCH_TAG];
    UIButton * flipBtn = (UIButton *)[ptzView viewWithTag:PTZVIEW_FLIP_BTN];
    UIActivityIndicatorView * activity = (UIActivityIndicatorView *)[ptzView viewWithTag:PTZVIEW_FLIP_ACTIVITY];
    flipBtn.hidden = YES;
    activity.hidden = NO;
    [activity startAnimating];
    
    [YSPlayerController ptzFlipWithCamera:_cameraInfo.cameraId
                                 cameraNo:_cameraInfo.cameraNo
                                   result:^(NSInteger code) {
                                       if (0 == code)
                                       {
                                           NSLog(@"flip operation success.");
                                       }
                                       else
                                       {
                                           NSLog(@"flip operation failed.");
                                       }
                                       
                                       activity.hidden = YES;
                                       flipBtn.hidden = NO;
                                   }];
    
}



#pragma mark -
#pragma mark realView select

- (void)onClickPlayBtn:(id)sender
{
    [self realPlay];
}

- (void)onClickStopBtn:(id)sender
{
    isstop = !isstop;
    if (isstop)
        [self stopPlay];
    else
        [self realPlay];
}

- (void)oneTapView:(id)sender
{
    if (_realState != YSPlayerMsgRealPlaySuccess)
    {
        return;
    }
    
    if (_bFullScreen && _realState == YSPlayerMsgRealPlaySuccess)
    {
        if (_fsToolbarView.alpha == 1.0f)
        {
            [self hideFSCtrlView:YES];
        }
        else
        {
            [self hideFSCtrlView:NO];
        }
    }
    else
    {
        _realView.stopBarView.hidden = !_realView.stopBarView.hidden;
        [_realView bringSubviewToFront:_realView.stopBarView];
    }
}

- (void)onTouchThumbnil:(id)sender
{
    
}

- (void)onRealViewZoomUp:(id)sender
{
    if (_fsToolbarView.alpha == 1.0f)
    {
        [self hideFSCtrlView:YES];
    }
}

- (void)onRealViewZoomOff:(id)sender
{
    
}

#pragma mark -
#pragma mark inner methods

- (void)hideFSCtrlView:(BOOL)bHide
{
    if (bHide && (!_bStatusBarHide || _fsToolbarView.alpha == 1.0f))
    {
        _fsToolbarView.alpha = 0.0f;
        
        _bStatusBarHide = YES;
    }
    else if (!bHide && (_bStatusBarHide || _fsToolbarView.alpha == 0.0f))
    {
        _fsToolbarView.alpha = 1.0f;
        
        _bStatusBarHide = NO;
    }
    else
    {
        return;
    }
    
    if (IS_IOS7_OR_LATER)
    {
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        {
            [self prefersStatusBarHidden];
            
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            
        }
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:_bStatusBarHide];
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return _bStatusBarHide;
}



#pragma mark -
#pragma mark play methods

- (void)realPlay
{
    
    NSString *accessToken = [[YSDemoDataModel sharedInstance] userAccessToken];
    
    [_realCtrl startRealPlayWithCamera:_cameraInfo.cameraId
                           accessToken:accessToken
                                inView:_realView];
}

- (void)stopPlay
{
    // 停止当前view的预览
    if ([_realCtrl isIntercom])
    {
        [_realCtrl stopIntercom];
    }
    
    [_realCtrl stopRealPlay];
}


#pragma mark
#pragma mark intercom methods
/**
 *  关闭对讲
 */
- (void)stopIntercom
{
    if ([_realCtrl isIntercom])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           BOOL bRet = [_realCtrl stopIntercom];
                           //                           _isIntercom = !bRet;
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (bRet)
                                              {
                                                  [CAttention showCustomAutoHiddenAttention:NSLocalizedString(@"关闭对讲成功.", nil)
                                                                                     toView:[UIApplication sharedApplication].keyWindow
                                                                                  toYOffset:0
                                                                                 toFontSize:nil
                                                                          toIsDimBackground:NO];
                                              }
                                              else
                                              {
                                                  [CAttention showCustomAutoHiddenAttention:NSLocalizedString(@"关闭对讲失败.", nil)
                                                                                     toView:[UIApplication sharedApplication].keyWindow
                                                                                  toYOffset:0
                                                                                 toFontSize:nil
                                                                          toIsDimBackground:NO];
                                              }
                                          });
                       });
    }
}

- (void)closeIntercomView
{
    if (self.intercomView)
    {
        UIView * superView = [self.intercomView superview];
        
        [UIView animateWithDuration:0.3 animations:^{
            superView.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, superView.frame.size.height);
        } completion:^(BOOL finished) {
            [superView removeFromSuperview];
        }];
    }
}


// 对讲异常回调处理
- (void)intercomException
{
    
    [self closeIntercomView];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"网络异常, 关闭对讲", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
    [alertView show];
}

// 对讲时隐私保护开启
- (void)intercomPrivate
{
    [self closeIntercomView];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"用户已开启隐私保护", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - delegate

/**
 *  播放状态回调
 *
 *  @param nStates
 *  @param code
 */
- (void)playerOperationMessage:(YSPlayerMessageType)msgType withValue:(id)value
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch (msgType)
        {
            case YSPlayerMsgCheckFail:
            {
                // value 的错误码值为20005表示验证失败, 其他错误为通用http接口错误
                YSCheckSMSCodeViewController *controller = [[YSCheckSMSCodeViewController alloc] initWithNibName:@"YSCheckSMSCodeViewController"
                                                                                                          bundle:nil];
                controller.type = ScheduleCheck;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case YSPlayerMsgRealPlayStart:
            {
                _realState = YSPlayerMsgRealPlayStart;
                [self updateUI];
                [_realView startPlay];
                _lTotleStreamLen = 0;
                _bRecording = NO;
                
            }
                break;
            case YSPlayerMsgRealPlaySuccess:
            {
                _realState = YSPlayerMsgRealPlaySuccess;
                [self updateUI];
                [_realView playSuccess];
                _bRecording = NO;
                
                // 播放成功，顶级视图不是预览视图，停止预览
                NSArray * arrViewController = [self.navigationController viewControllers];
                if (![[arrViewController objectAtIndex:([arrViewController count] - 1)] isKindOfClass:[RealPlayViewController class]])
                {
                    [self stopPlay];
                }
                
                // 设备常亮
                [UIApplication sharedApplication].idleTimerDisabled = YES;
                
            }
                break;
            case YSPlayerMsgRealPlayFail:
            {
                // 关闭设备常亮
                [UIApplication sharedApplication].idleTimerDisabled = NO;
                
                _bRecording = NO;
                
                // rtsp取流重连失败停止录像
                if (_bRecording)
                {
                    [_realCtrl stopRecord];
                }
                
                _realState = YSPlayerMsgRealPlayFail;
                
                [self updateUI];
                [_realView playFailed:[(NSNumber *)value intValue]];
                
            }
                break;
            case YSPlayerMsgRealPlayStop:
            {
                _realState = YSPlayerMsgRealPlayStop;
                
                [self updateUI];
                
                _bRecording = NO;
                
                
                [self closeTagView];
                
                [_realView stopPlay];
                
                // 关闭设备常亮
                [UIApplication sharedApplication].idleTimerDisabled = NO;
                
            }
                break;
            case YSPlayerMsgRealPlayDeviceOffline:
            {
                _realState = YSPlayerMsgRealPlayDeviceOffline;
                [self updateUI];
                [_realView ShowOfflineTips];
                
                // 关闭设备常亮
                [UIApplication sharedApplication].idleTimerDisabled = NO;
            }
                break;
            case YSPlayerMsgRealPlayNoPermission:
            {
                _realState = YSPlayerMsgRealPlayNoPermission;
                
                [self updateUI];
                [_realView showNoPermissionTips];
                
                //
                [UIApplication sharedApplication].idleTimerDisabled = NO;
                
            }
                break;
            case YSPlayerMsgIntercomException:
            {
                [self intercomException];
            }
                break;
            case YSPlayerMsgIntercomPrivate:
            {
                [self intercomPrivate];
            }
                break;
            case YSPlayerMsgIntercomStopBefore:
            {
                // 对讲界面
                [self closeIntercomView];
                
                // ui重新刷新
                [self updateUI];
            }
                break;
            case YSPlayerMsgIntercomStop:
            {
                // 恢复音频
                //                [_realCtrl AudioCtrl:YES];
                [_realCtrl setAudioOpen:YES];
                
            }
                break;
            case YSPlayerMsgRealPlayReconnecting:
            {
                [_realView ShowReConnectTips];
            }
                break;
            case YSPlayerMsgRealPlayChangeVideoLevel:
            {
                NSNumber *videoLevel = (NSNumber *)value;
                if (videoLevel)
                {
                    _videoLevel = [videoLevel intValue];
                    
                    [self updateUI];
                }
                else
                {
                    // 切换视频质量失败
                }
            }
                break;
            default:
                break;
        }
    });
}

- (void)realPlayDidStartedWithDict:(NSDictionary *)dict
{
    if (dict)
    {
        self.videoLevels = [dict objectForKey:kVideoLevel];
        
        NSNumber *currentVideoLevel = [dict objectForKey:kCurrentVideoLevel];
        if (currentVideoLevel)
        {
            _videoLevel = [currentVideoLevel intValue];
            
            [self updateUI];
        }
        
        NSInteger talk = [[dict objectForKey:kSupportTalk] integerValue];
        if (talk == 1 || talk == 3)
        {
            _isIntercomAvailable = YES;
        }
        else
        {
            _isIntercomAvailable = NO;
        }
        _intercomType = talk;
        
        NSInteger ptz = [[dict objectForKey:kSupportPtz] integerValue];
        
        _isSupportPtz = NO;
        if(ptz == 1){
            _isSupportPtz = YES;
        }
        
        
        [self moveCtrl];
    }
}


/**
 *  对讲声音能量值回调
 *
 *  @param nIntensity 能量值
 */
- (void)intercomIntensity:(unsigned int)nIntensity
{
    [self.intercomView intercomIntensity:nIntensity];
}

- (void)voiceChange:(id)sender
{
    [_realCtrl setAudioOpen:self.soundSwitch.on];
}

#pragma mark - Set & Get Methods

- (UISwitch *)soundSwitch
{
    if(!_soundSwitch)
    {
        _soundSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        _soundSwitch.on = YES;
        [_soundSwitch addTarget:self action:@selector(voiceChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _soundSwitch;
}


-(void)showImageHandler
{
    CaptureViewController *imgeview = [[CaptureViewController alloc] init];
    [self.navigationController pushViewController:imgeview animated:YES];
}


@end
