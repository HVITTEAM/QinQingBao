//
//  WifiAddDeviceViewController.m
//  VideoGo
//
//  Created by yudan on 14-4-8.
//
//

#import "WifiAddDeviceViewController.h"

#import "YSMobilePages.h"

#import "YSDemoDataModel.h"
#import "CAttention.h"
#import "TipsPublicView.h"
#import "CSNAddByQRcodeViewController.h"

#import "EzvizSimpleWifi.h"
#import "BonjourBrowser.h"

#import "CMyCameraListViewController.h"


#define UIColorFromRGB(rgbValue, alp)	[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 \
alpha:alp]



#define TIPS_VIEW_HEIGHT        200

#define CLOUD_SELECT_BTNTAG     6001


@interface WifiAddDeviceViewController () <UIAlertViewDelegate, BonjourBrowserDelegate>
{
    TipsPublicView         *_titleView;
    UIView                 *_tipsView;
    UIView                 *_failedView;
    
    UIView                 *_circleView;
    UIImageView            *_circleLayerView;    // 图片动画视图
    UIImageView            *_circleBgView;       // 图片背景
    CAShapeLayer           *_layer;              // 动画层
    CAShapeLayer           *_bgLayer;            // 背景层，用于解决动画分布
    
    EzvizSimpleWifi        *_simpleWifi;
    BonjourBrowser         *_bonjour;
    
    BOOL                    _bEnableShowAlert;   // 是否可以显示alertView
    MBProgressHUD          *_hud;

    CGFloat sizeWidth;
}

@property (nonatomic, retain) CAShapeLayer * layer;
@property (nonatomic, retain) CAShapeLayer * bgLayer;

@property (nonatomic, retain) YSMobilePages *mp;


@end

@implementation WifiAddDeviceViewController

@synthesize strSsid = _strSsid;
@synthesize strKey = _strKey;
@synthesize strSn = _strSn;
@synthesize strVerify = _strVerify;
@synthesize layer = _layer;
@synthesize bgLayer = _bgLayer;
@synthesize bSupportNet = _bSupportNet;
@synthesize enState = _enState;
@synthesize strAESVersion = _strAESVersion;
@synthesize strModel = _strModel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _enState = STATE_NONE;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sizeWidth = [UIScreen mainScreen].bounds.size.width;
    
    // key为空可以传个任意字符过去
    if ([self.strKey length] == 0)
    {
        self.strKey = @"smile";
    }
    
    [self initView];
    
    if (_enState == STATE_NONE)
    {
        _simpleWifi = [[EzvizSimpleWifi alloc] init];
        
        if ([self.strAESVersion length] > 5)
        {
            //支持AES加密设备
            [_simpleWifi startWifiConfig:self.strSsid addKey:self.strKey secretKey:self.strSn];
        }
        else
        {
            //截止app2.2版本以前的设备
            [_simpleWifi startWifiConfig:self.strSsid andKey:self.strKey];
        }
     
        _bonjour = [[BonjourBrowser alloc] initForType:kBoujourSearchType
                                              inDomain:kBoujourSearchDomain
                                               timeout:BONJOURSEARCH_DEFAULT_TIMEOUT];
        _bonjour.delegate = self;
        [_bonjour startBonjour];
    }
    
    [self showTipsView];
    
    YSMobilePages *mobilePage = [[YSMobilePages alloc] init];
    self.mp = mobilePage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)dealloc
{
    [_simpleWifi stopWifiConfig];
    _bonjour.delegate = nil;
    [_bonjour stopBonjour];
}

- (void)viewWillAppear:(BOOL)animated
{
    _bEnableShowAlert = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    _bEnableShowAlert = NO;
}


- (void)initView
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    float statusbarHeight = (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? 20.0f : 0.0f);
    
#else
    float statusbarHeight = 0.0;
#endif
    
    NSString *strTitle = nil;
    
    if ([self.strModel length] >0 )
    {
        //扫描带设备型号
        strTitle = [NSString stringWithFormat:@"%@(2/2)", @"设备添加"];
    }
    else
    {
        strTitle = [NSString stringWithFormat:@"%@(3/3)", @"设备添加"];
    }
    
    _titleView = [[TipsPublicView alloc] initWithFrame:CGRectMake(0, statusbarHeight, sizeWidth, 44) withTitle:strTitle];
    [_titleView addBackBtnTouchEvent:self action:@selector(onClickBackBtn)];
    [self.view addSubview:_titleView];
    
    float circleTop = _titleView.frame.origin.y + _titleView.frame.size.height + 75;
    if (gfScreenHeight < 560)
    {
        circleTop = _titleView.frame.origin.y + _titleView.frame.size.height + 16;
    }
    
    _circleView = [[UIView alloc] initWithFrame:CGRectMake((sizeWidth - 210)/2.0f, circleTop, 210, 210)];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _circleView.frame.size.width, _circleView.frame.size.height)];
    [_circleView addSubview:_circleBgView];
    _circleLayerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _circleView.frame.size.width, _circleView.frame.size.height)];
    [_circleView addSubview: _circleLayerView];
    [self.view addSubview:_circleView];
    
    // 动画image
    _circleBgView.image = [UIImage imageNamed:@"circle_bg.png"];
    _circleLayerView.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"circle1.png"],
                                        [UIImage imageNamed:@"circle2.png"],
                                        [UIImage imageNamed:@"circle3.png"],
                                        [UIImage imageNamed:@"circle4.png"],
                                        nil];
    _circleLayerView.animationDuration     = 3.0f;
    _circleLayerView.animationRepeatCount  = 0;
    [_circleLayerView startAnimating];
    
    // 动画layer
    self.layer = [CAShapeLayer layer];
    self.layer.fillColor = [UIColor clearColor].CGColor;
    self.layer.strokeColor = UIColorFromRGB(0x1b9ee2, 1.0f).CGColor;
    self.layer.lineWidth = 3.0f;
    self.layer.frame=_circleBgView.bounds;
    [_circleBgView.layer addSublayer:self.layer];
    
    if (_enState != STATE_LINE)
    {
        self.bgLayer = [CAShapeLayer layer];
        self.bgLayer.fillColor = [UIColor clearColor].CGColor;
        self.bgLayer.strokeColor = UIColorFromRGB(0x1b9ee2, 1.0f).CGColor;
        self.bgLayer.lineWidth = 3.0f;
        self.bgLayer.frame=_circleBgView.bounds;
        [_circleBgView.layer addSublayer:self.bgLayer];
    }
    
    // 提示文字视图
    _tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, _circleView.frame.origin.y + _circleView.frame.size.height + 15, sizeWidth, TIPS_VIEW_HEIGHT)];
    _tipsView.backgroundColor = [UIColor clearColor];
    UILabel * tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, sizeWidth-40, 80)];
    tipsLab.numberOfLines = 0;
    tipsLab.lineBreakMode = NSLineBreakByWordWrapping;
    tipsLab.font = [UIFont systemFontOfSize:16.0f];
    tipsLab.textColor = UIColorFromRGB(0x444444, 1.0f);
    tipsLab.backgroundColor = [UIColor clearColor];
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.tag = 1001;
    [_tipsView addSubview:tipsLab];
    [self.view addSubview:_tipsView];
}

- (void)onClickBackBtn
{
    if (![_bonjour isBonjouring])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"添加过程稍稍有点漫长，耐心等一会儿哦~"
                                                         delegate:self
                                                cancelButtonTitle:@"退出"
                                                otherButtonTitles:@"等待", nil];
        
        alert.tag = 1001;
        [alert show];
    }
    
}

- (void)onClickRetryBtn
{
    [self showTipsView];
    
    _circleLayerView.image = nil;
    _circleLayerView.animationImages = [NSArray arrayWithObjects:
                                        [UIImage imageNamed:@"circle1.png"],
                                        [UIImage imageNamed:@"circle2.png"],
                                        [UIImage imageNamed:@"circle3.png"],
                                        [UIImage imageNamed:@"circle4.png"],
                                        nil];
    _circleLayerView.animationDuration     = 3.0f;
    _circleLayerView.animationRepeatCount  = 0;
    [_circleLayerView startAnimating];
    
    switch (_enState)
    {
        case STATE_NONE:
        {
            if (self.strAESVersion)
            {
                //支持AES加密设备
                [_simpleWifi startWifiConfig:self.strSsid addKey:self.strKey secretKey:self.strSn];
            }
            else
            {
                //截止app2.2版本以前的设备
                [_simpleWifi startWifiConfig:self.strSsid andKey:self.strKey];
            }
            [_bonjour startBonjour];
        }
            break;
        case STATE_WIFI:
        {
            [_bonjour startBonjour];
        }
            break;
        default:
            break;
    }
}

- (void)onClickConnectedBtn:(id)sender;
{
    UIButton * btn = (UIButton *)sender;
    UIView * lineView = [btn superview];
    
    [UIView animateWithDuration:0.5 animations:^{
        lineView.frame = CGRectMake(0, gfScreenHeight, sizeWidth, gfScreenHeight);
    } completion:^(BOOL finished) {
        [lineView removeFromSuperview];
    }];

    
    _enState = STATE_LINE;
    
    [self onClickRetryBtn];
}

- (void)onClickCancelBtn:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    UIView * lineView = [[btn superview] superview];
    
    [UIView animateWithDuration:0.5 animations:^{
        lineView.frame = CGRectMake(0, gfScreenHeight, sizeWidth, gfScreenHeight);
    } completion:^(BOOL finished) {
        [lineView removeFromSuperview];
    }];
}

- (void)onClickFinishBtn:(id)sender
{
    UIButton * selectBtn = (UIButton *)[self.view viewWithTag:CLOUD_SELECT_BTNTAG];
    
    if (selectBtn.selected)
    {
        [self cloudAction];
    }
    else
    {
        [self backToEnter];
    }
}

- (void)onClickSelectBtn:(id)sender
{
    UIButton * selectBtn = (UIButton *)sender;
    
    selectBtn.selected = !selectBtn.selected;
    
}


#pragma mark -
#pragma mark inner methods


- (void)addDevice
{    
    // 中间页
    __weak typeof(self) handleVC = self;
    [_mp addDevice:self.navigationController
   withAccessToken:[EzvizDemoGlobalKit sharedKit].token
          deviceNo:self.strSn
      validateCode:self.strVerify
        completion:^(NSString *deviceNo) {
            [handleVC go2ListVC];
        }];
}

- (void)go2ListVC{
    for ( UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[CMyCameraListViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (void)inputVerifyAlert
{
    if (!_bEnableShowAlert)
    {
        return;
    }
    
    NSString * strTitle = [NSString stringWithFormat:@"%@", NSLocalizedString(@"Please enter the device verification code.", nil)];
    NSString * strAttention1 = NSLocalizedString(@"auto_wifi_default_verification_code_tip", nil);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:strTitle
                                                         message:strAttention1
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alertView.tag = 2001;
    [alertView show];
}


/**
 *  显示提示界面，根据state可以标示不同的提示语
 */
- (void)showTipsView
{
    _failedView.hidden = YES;
    
    UILabel * tipsLab = (UILabel *)[_tipsView viewWithTag:1001];
    switch(_enState)
    {
        case STATE_NONE:
        {
            tipsLab.text = @"请将手机靠近设备，添加过程大约需要等待1分钟，正在连接wifi请稍候…";
        }
            break;
        case STATE_WIFI:
        case STATE_LINE:
        case STATE_PLAT:
        {
            tipsLab.text = @"正在添加设备，请稍候…";
        }
            break;
        case STATE_SUCC:
        {
            tipsLab.text = @"恭喜你，添加成功！";
        }
            break;
        default:
            break;
    }
    
    _tipsView.hidden = NO;
}

/**
 *  显示失败界面，根据state可以标示不同的失败类型
 */
- (void)showFailedView:(int)nErrorCode
{
    _tipsView.hidden = YES;
    
    [_circleLayerView stopAnimating];
    _circleLayerView.animationImages = nil;
    _circleLayerView.image = [UIImage imageNamed:@"circle_failed.png"];
    
    if (!_failedView)
    {
        _failedView = [[UIView alloc] initWithFrame:CGRectMake(0, _circleView.frame.origin.y + _circleView.frame.size.height + 15, sizeWidth, TIPS_VIEW_HEIGHT)];
        _failedView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_failedView];
        
        UILabel * failedLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, sizeWidth-40, 65)];
        failedLab.numberOfLines = 0;
        failedLab.lineBreakMode = NSLineBreakByWordWrapping;
        failedLab.font = [UIFont systemFontOfSize:16.0f];
        failedLab.textColor = UIColorFromRGB(0x444444, 1.0f);
        failedLab.textAlignment = NSTextAlignmentCenter;
        failedLab.backgroundColor = [UIColor clearColor];
        failedLab.tag = 1001;
        [_failedView addSubview:failedLab];
        
        UIButton * retryBtn = [[UIButton alloc] initWithFrame:CGRectMake(17, _bSupportNet?80:100, sizeWidth-34, 34)];
        [retryBtn setTitle:NSLocalizedString(@"Retry", nil) forState:UIControlStateNormal];
        [retryBtn setBackgroundImage:[UIImage imageNamed:@"button_bule.png"] forState:UIControlStateNormal];
        [retryBtn setBackgroundImage:[UIImage imageNamed:@"button_bule_sel.png"] forState:UIControlStateHighlighted];
        retryBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [retryBtn setTitleColor:UIColorFromRGB(0x40a2ee, 1.0f) forState:UIControlStateNormal];
        [retryBtn addTarget:self action:@selector(onClickRetryBtn) forControlEvents:UIControlEventTouchUpInside];
        [_failedView addSubview:retryBtn];
    }
    
    UILabel * failedLab = (UILabel *)[_failedView viewWithTag:1001];
    UIButton * lineBtn = (UIButton *)[_failedView viewWithTag:1003];
    
    switch (_enState)
    {
        case STATE_NONE:
        {
            failedLab.text = NSLocalizedString(@"Wi-Fi连接失败，请重试或返回检查Wi-Fi密码是否输入正确", nil);
            lineBtn.hidden = NO;
        }
            break;
        case STATE_WIFI:
        case STATE_LINE:
        {
            failedLab.text = NSLocalizedString(@"设备未连接到萤石云，请检查设备所在网络是否能正常上网后重试", nil);
            lineBtn.hidden = YES;
        }
            break;
        case STATE_PLAT:
        {
            // 获取错误码对应的问题提示信息
            if (nErrorCode != 0)
            {
                failedLab.text = @"添加失败";
            }
            else
            {
                failedLab.text = @"添加失败";
            }
            
            lineBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    _failedView.hidden = NO;
}


- (void)showCircleLayer:(CGFloat)fStart withEndAngle:(CGFloat)fEnd
{
    if (fStart > -M_PI/2)
    {
        UIBezierPath *path=[UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(_circleBgView.bounds.size.width/2, _circleBgView.bounds.size.height/2) radius:_circleBgView.bounds.size.width/2 startAngle:-M_PI/2 endAngle:fStart clockwise:YES];
        self.bgLayer.path = path.CGPath;
    }
    else
    {
        self.bgLayer.path = nil;
    }
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(_circleBgView.bounds.size.width/2, _circleBgView.bounds.size.height/2) radius:_circleBgView.bounds.size.width/2 startAngle:fStart endAngle:fEnd clockwise:YES];
    
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=2;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [self.layer addAnimation:bas forKey:@"key"];
    
    self.layer.path=path.CGPath;
    
}

- (void)backToEnter
{
    // 退回到设备添加入口页面
    BOOL bFind = NO;
    NSArray * arrViews = [self.navigationController viewControllers];
    for (NSUInteger i=[arrViews count]-1; i > -1; i--)
    {
        UIViewController * viewController = [arrViews objectAtIndex:i];
        if ([viewController isKindOfClass:[CSNAddByQRcodeViewController class]])
        {
            bFind = YES;
            CSNAddByQRcodeViewController * scanViewController = (CSNAddByQRcodeViewController *)viewController;
            
            if ([scanViewController respondsToSelector:@selector(presentingViewController)] && scanViewController.presentingViewController)
            {
                [scanViewController back];
            }
            else
            {
                if (i > 0)
                {
                    [self.navigationController popToViewController:[arrViews objectAtIndex:i-1] animated:YES];
                }
                else
                {
                    bFind = NO;
                }
            }
            
            break;
        }
    }
    
    if (!bFind)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cloudAction
{
}


#pragma -
#pragma mark - Show/Hide Hud
/** @fn	createWaitViewtoText:
 *  @brief  创建手动隐藏的弱提示界面
 *  @param  text - 显示信息
 *  @return MBProgressHUD - 自定义弱提示界面
 */
- (MBProgressHUD *)createWaitViewtoText:(NSString *)text
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [CAttention createWaitViewtoText:text
                                                   toView:window
                                                toYOffset:0
                                               toFontSize:nil
                                        toIsDimBackground:NO];
    [window addSubview:hud];
    return hud;
}

/** @fn	hideHudView
 *  @brief  隐藏弱提示界面
 *  @param
 *  @return
 */
- (void)hideHudView
{
    if (_hud != nil)
    {
        [CAttention hiddenWaitView:_hud];
        _hud = nil;
    }
}

/** @fn	showCustomAutoHiddenAttention:
 *  @brief  显示自动隐藏的弱提示界面
 *  @param  text - 显示信息
 *  @return
 */
- (void)showCustomAutoHiddenAttention:(NSString *)text
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [CAttention showCustomAutoHiddenAttention:text
                                       toView:window
                                    toYOffset:0
                                   toFontSize:nil
                            toIsDimBackground:NO];
}


/***
 * 绑定百度失败，提示交互框
 ***/
- (void)bindBaiduFailedAlert:(NSString *)reason
{
    NSString *message = [NSString stringWithFormat:@"%@\n请重试",reason];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"重试", nil];
    alertView.tag = 0x232;
    [alertView show];
}

#pragma mark
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case 1001:
        {
            if (buttonIndex == 0)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 1002:
        {
            if (buttonIndex == 1)
            {
                [self inputVerifyAlert];
            }
            else
            {
                self.strVerify = nil;
                [self showFailedView:0];
            }
        }
            break;
        case 1003:
        {
            if (buttonIndex == 1)
            {
                [self cloudAction];
            }
            else
            {
                [self backToEnter];
            }
        }
            break;
        case 0x232:
        {
            if (buttonIndex == 0) //取消
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            if (buttonIndex == 1)
            {
                //重试
                [self addDevice];;
            }
            break;
            
        }
            case 2001:
        {
            if (buttonIndex == 1)
            {
                self.strVerify = [alertView textFieldAtIndex:0].text;
                
                if ([self.strVerify length] == 0)
                {
                    [self inputVerifyAlert];
                    
                    return;
                }
                else
                {
                    [self addDevice];
                }
            }
            else
            {
                [self showFailedView:0];
            }
        }
            break;
            case 0x001:
        {
            if (1 == buttonIndex)
            {
                [self addDevice];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark
#pragma mark bonjour delegate
/**
 *   完成搜索
 *
 *  @param arrBonjourServer 设备信息集合
 */
- (void)finishSearchBonjourServer:(NSArray *)arrBonjourServer
{
    for (NSString * name in arrBonjourServer)
    {
        NSLog(@"server name: %@", name);
        
        NSRange range = [name rangeOfString:self.strSn];
        if (range.length != 0)
        {
            range = [name rangeOfString:@"&WIFI"];
            if (range.length != 0)
            {
                if (_enState != STATE_WIFI)
                {
                    _enState = STATE_WIFI;
                    
                    [_simpleWifi stopWifiConfig];
                    
                    [self showCircleLayer:-M_PI/2 withEndAngle:M_PI*2/3-M_PI/2];
                    NSLog(@"***** bonjour &WIFI App 1/3 T2'********");
                }
            }
            else
            {
                range = [name rangeOfString:@"&PLAT"];
                if (range.length != 0)
                {
                    if (_enState != STATE_PLAT)
                    {
                        _enState = STATE_PLAT;
                        
                        [self showCircleLayer:M_PI*2/3-M_PI/2 withEndAngle:M_PI*4/3-M_PI/2];
                        
                        [_simpleWifi stopWifiConfig];
                        [_bonjour stopBonjour];
                        
                        NSLog(@"***** bonjour &PLAT App 2/3 T3'********");
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"WIFI 配置成功, 是否继续设备添加"
                                                                       delegate:self
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"确定", nil];
                        alert.tag = 0x001;
                        [alert show];
                    }
                }
            }
            
            [self showTipsView];
        }
    }
}

/**
 *  bonjour搜索超时
 */
- (void)TimeourSearchBonjourServer
{
    NSLog(@"***** bonjour Search Timeout *******");
    
    [_simpleWifi stopWifiConfig];
    [_bonjour stopBonjour];
    
    [self showFailedView:0];
}

@end
