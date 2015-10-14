//
//  WifiInfoViewController.m
//  VideoGo
//
//  Created by yudan on 14-4-4.
//
//

#import "WifiInfoViewController.h"

#import <SystemConfiguration/CaptiveNetwork.h>


#import "TipsPublicView.h"
#import "WifiAddDeviceViewController.h"
#import "ResetDeviceTipsViewController.h"



@interface WifiInfoViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    TipsPublicView         *_titleView;
    UITableView            *_tableView;
    UIView                 *_finishView;
    UIView                 *_tipsView;
    
    NSString               *_strSsid;
    
    CGFloat sizeWidth;
}

@property (nonatomic, retain) UITextField * ssidField;
@property (nonatomic, retain) UITextField * keyField;
@property (nonatomic, copy) NSString * strSsid;
@property (nonatomic, retain) UIView * finishView;
@property (nonatomic, retain) UIAlertView * alertView;

@end

@implementation WifiInfoViewController

@synthesize strSsid = _strSsid;
@synthesize finishView = _finishView;
@synthesize strSn = _strSn;
@synthesize strVerify = _strVerify;
@synthesize bForAddDevice = _bForAddDevice;
@synthesize strAESVersion = _strAESVersion;
@synthesize strModel = _strModel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bForAddDeivce = YES;
        _bSupportNet = YES;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _bForAddDeivce = YES;
        _bSupportNet = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    float statusbarHeight = (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? 20.0f : 0.0f);
#else
    float statusbarHeight = 0.0;
#endif
    
    NSString *strTitle = nil;
    
    sizeWidth = [UIScreen mainScreen].bounds.size.width;
    
    if ([self.strModel length] >0 )
    {
        //扫描带设备型号
        strTitle = [NSString stringWithFormat:@"%@(1/2)",NSLocalizedString(@"auto_wifi_title_connect_to_network", nil)];
    }
    else
    {
        strTitle = [NSString stringWithFormat:@"%@(2/3)",NSLocalizedString(@"auto_wifi_title_connect_to_network", nil)];
    }
    
    
    
    _titleView = [[TipsPublicView alloc] initWithFrame:CGRectMake(0, statusbarHeight, sizeWidth, 44) withTitle:strTitle];
    [_titleView addBackBtnTouchEvent:self action:@selector(onClickBackBtn)];
    [self.view addSubview:_titleView];
    
    if (!_bForAddDevice)
    {
        _titleView.tipsLab.text = NSLocalizedString(@"配置Wi-Fi", nil);
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _titleView.frame.origin.y+_titleView.frame.size.height, sizeWidth, gfScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.keyField becomeFirstResponder];
    [self wifiConnectTips];
}



- (void)appWillBecomeActive
{
    [self wifiConnectTips];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)onClickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickHowReset
{
    ResetDeviceTipsViewController * resetDevice = [[ResetDeviceTipsViewController alloc] init];
    [self presentViewController:resetDevice animated:YES completion:^{
        
    }];  
    
}

- (void)wifiConnectTips
{
    NSDictionary *ifs = [self currentNetworkInfo];
    self.strSsid = [ifs objectForKey:@"SSID"];
    self.ssidField.text = self.strSsid;
    
    if ([self.strSsid length] == 0)
    {
        if (self.alertView == nil)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"需要将手机连接到Wi-Fi"
                                                                  message:@"请到“设置”-“Wi-Fi”功能中开启Wi-Fi并连接到网络"
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                        otherButtonTitles: nil];
            
            [alertView show];
            
            self.alertView = alertView;
        }
    }
    if([self.strSsid isEqualToString:@"ys7-yd-2217-dj"]){
        self.keyField.text = @"DeJohn2015";
    }else{
        self.keyField.text = @"hik12345+";
    }
}

- (id)currentNetworkInfo
{
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge_transfer NSArray *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [(NSDictionary *)info count])
        {
            break;
        }
    }
    return info;
}

#pragma mark - 
#pragma mark tabelview delegate  

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f; //解决iOS7、ios8返回默认高度问题
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 102.0f;
    }
    else
    {
        return 5.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (_finishView)
        {
            return _finishView;
        }
        
        _finishView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeWidth, 102)];
        _finishView.backgroundColor = [UIColor clearColor];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(17, 16, sizeWidth - 34, 34)];
        [btn setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"public_long_btn.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"public_long_btn_sel.png"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"public_long_btn_dis.png"] forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(onClickFinishBtn) forControlEvents:UIControlEventTouchUpInside];
        [_finishView addSubview:btn];
        
        if (_bForAddDevice)
        {
            UILabel * tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 52, sizeWidth - 40, 18)];
            tipsLab.font = [UIFont systemFontOfSize:14.0f];
            tipsLab.backgroundColor = [UIColor clearColor];
            tipsLab.textColor = UIColorFromRGB(0x333333, 1.0f);
            tipsLab.text = NSLocalizedString(@"如果您的设备之前已经被使用，请先复位设备", nil);
            tipsLab.textAlignment = NSTextAlignmentCenter;
            [_finishView addSubview:tipsLab];
            
            UIButton * tipsBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 65, sizeWidth - 40, 34)];
            [tipsBtn setTitle:NSLocalizedString(@"如何复位", nil) forState:UIControlStateNormal];
            [tipsBtn setTitleColor:UIColorFromRGB(0x3333ef, 1.0f) forState:UIControlStateNormal];
            tipsBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [_finishView addSubview:tipsBtn];
            [tipsBtn addTarget:self action:@selector(onClickHowReset) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        return _finishView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strWifi = @"wifi";
    static NSString * strKey = @"key";
    
    UITableViewCell * cell = nil;
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:strWifi];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strWifi];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                
                cell.textLabel.text = @"网络";
                cell.textLabel.textColor = UIColorFromRGB(0x333333, 1.0f);
                
                UITextField * ssidField = [[UITextField alloc] initWithFrame:CGRectMake(108, 10, 200, 24)];
                ssidField.textColor = UIColorFromRGB(0x333333, 1.0f);
                ssidField.font = [UIFont systemFontOfSize:18.0f];
                ssidField.backgroundColor = [UIColor clearColor];
                ssidField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                ssidField.userInteractionEnabled = NO;
                [cell addSubview:ssidField];
                
                self.ssidField = ssidField;
            }
            
            self.ssidField.text = _strSsid;
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:strKey];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strKey];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                
                cell.textLabel.text = NSLocalizedString(@"Password", nil);
                cell.textLabel.textColor = UIColorFromRGB(0x333333, 1.0f);
                
                UITextField * keyField = [[UITextField alloc] initWithFrame:CGRectMake(108, 10, 200, 24)];
                keyField.textColor = UIColorFromRGB(0x333333, 1.0f);
                keyField.font = [UIFont systemFontOfSize:18.0f];
                keyField.backgroundColor = [UIColor clearColor];
                keyField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                [cell addSubview:keyField];
                self.keyField = keyField;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;  
}

- (void)onClickFinishBtn
{
    if ([self.strSsid length] == 0)
    {
        [self wifiConnectTips];
    }
    else
    {
        if(_bForAddDevice){
            WifiAddDeviceViewController * wifiAdd = [[WifiAddDeviceViewController alloc] initWithNibName:nil bundle:nil];
            wifiAdd.strSsid = self.ssidField.text;
            wifiAdd.strKey = self.keyField.text;
            wifiAdd.strSn = self.strSn;
            wifiAdd.strAESVersion = self.strAESVersion;
            wifiAdd.strVerify = self.strVerify;
            wifiAdd.bSupportNet = self.bSupportNet;
            wifiAdd.strModel    = self.strModel;
            
            [self.navigationController pushViewController:wifiAdd animated:YES];
        }else{
            [UIViewController go2FindDevicesViewController:self andParams:@{@"ssid":self.ssidField.text,@"strKey":self.keyField.text}];
        }
    }
}


#pragma mark
#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.alertView = nil;
}


@end
