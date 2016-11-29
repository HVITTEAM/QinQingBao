//
//  ScanCodesViewController.m
//  ScanCode
//
//  Created by shi on 16/2/17.
//  Copyright © 2016年 finefor. All rights reserved.
//

#define kScanFactor 0.6
#define kOffsetToCenter 50

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ScanCodesViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "InputArchiveCodeController.h"

@interface ScanCodesViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    NSString *codeStr;
}

@property(strong,nonatomic)AVCaptureSession * session;

@property(assign,nonatomic)CGRect scannerRect;             //扫描框的范围

@property(strong,nonatomic)UIImageView *scanLine;          //扫描的线

@end

@implementation ScanCodesViewController

#pragma mark -- 生命周期方法 --

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"二维码/条码";

    [self authorizationCheck];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //注册通知，监听应用进入前后台情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterbackground:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self startScanAnimation];
    [self startScanning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self stopScanAnimation];
    [self stopScanning];
}

- (void)authorizationCheck
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        [self initOverlayerView];
                        [self initSession];
                        [self startScanning];
                        [self startScanAnimation];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
                
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            [self initOverlayerView];
            [self initSession];
            [self startScanning];
            [self startScanAnimation];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"无法访问相机,您可以去设置-隐私-相机中允许应用访问相机" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -- 初始化视图及参数 --
/**
 *  创建扫描框
 */
- (void)initOverlayerView
{
    CGFloat scanerW = kScanFactor * MTScreenW;
    CGFloat scanerH = scanerW;
    CGFloat scanerX = (MTScreenW - scanerW) / 2;
    CGFloat scanerY = (MTScreenH - scanerH) / 2 - kOffsetToCenter;
    
    self.scannerRect = CGRectMake(scanerX, scanerY, scanerW, scanerH);
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scanerX, MTScreenH)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(MTScreenW - scanerX, 0, scanerX, MTScreenH)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(scanerX, 0, scanerW, scanerY)];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(scanerX, scanerY + scanerH, scanerW,MTScreenH - scanerY - scanerH)];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //扫描框view
    UIImageView *scanImageView = [[UIImageView alloc] initWithFrame:self.scannerRect];
    scanImageView.image = [UIImage imageNamed:@"scaner"];
    [self.view addSubview:scanImageView];
    
    //扫描的线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(scanerX, scanerY, scanerW, 4)];
    line.image = [UIImage imageNamed:@"scanLine"];
    self.scanLine = line;
    self.scanLine.hidden = YES;
    [self.view addSubview:line];
    
    UILabel *msgLb = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(downView.frame), MTScreenW-60, 60)];
    msgLb.backgroundColor = [UIColor clearColor];
    msgLb.textColor = [UIColor whiteColor];
    msgLb.textAlignment = NSTextAlignmentCenter;
    msgLb.font = [UIFont systemFontOfSize:14];
    msgLb.text = @"将扫描的内容放入框内,即可自动扫描";
    [self.view addSubview:msgLb];
    
    UIButton *backBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =CGRectMake(20, 40, 50, 30);
    [backBtn setTitle:@"返回" forState: UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backBtn setBackgroundColor:[UIColor grayColor]];
    backBtn.layer.cornerRadius = 8;
    backBtn.layer.masksToBounds = YES;
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:backBtn];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"手动输入档案号" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor colorWithRGB:@"333333"] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.layer.cornerRadius = 8.0f;
    btn.frame = CGRectMake((self.view.width - btn.width)/2, self.view.height - 60, btn.width + 20, 40);
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(inputArchiveCode:) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 *  创建会话
 */
-(void)initSession
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if (input) {
        [self.session addInput:input];
    }
    
    if (output) {
        output.rectOfInterest=CGRectMake(self.scannerRect.origin.y / MTScreenH,self.scannerRect.origin.x / MTScreenW,self.scannerRect.size.height / MTScreenH, self.scannerRect.size.width / MTScreenW);
        [self.session addOutput:output];
        
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *codetypes = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [codetypes addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [codetypes addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [codetypes addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [codetypes addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=codetypes;
    }
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
}

#pragma mark -- 协议方法 --
#pragma mark AVCaptureMetadataOutputObjectsDelegate
/**
 *  扫描成功后回调
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        
        [self stopScanAnimation];
        [self stopScanning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        //输出扫描字符串
        NSString *data = metadataObject.stringValue;
        
        codeStr = data;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫码结果" message:data delegate:self cancelButtonTitle:@"重新扫描" otherButtonTitles:@"确定",nil];
        [alert show];
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.getcodeClick)
            self.getcodeClick(codeStr);
    }
    else
    {
        [self startScanAnimation];
        [self startScanning];
    }
}

#pragma mark -- 事件方法 --
/**
 *  应用进入前台重启动画
 */
-(void)appWillEnterForeground:(NSNotification *)notification
{
    [self startScanAnimation];
    [self startScanning];
}

/**
 *  应用进入后台停止动画
 */
-(void)appWillEnterbackground:(NSNotification *)notification
{
    [self stopScanAnimation];
    [self stopScanning];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)inputArchiveCode:(UIButton *)sender
{
    InputArchiveCodeController *inputArchiveCodeVC = [[InputArchiveCodeController alloc] init];
    [self.navigationController pushViewController:inputArchiveCodeVC animated:YES];
}

#pragma mark -- 内部方法 --
/**
 *  开始扫描动画
 */
-(void)startScanAnimation
{
    if (!self.scanLine) {
        return;
    }
    
    [self stopScanAnimation];
    
    self.scanLine.hidden = NO;
    CGRect lineRect = self.scanLine.frame;
    lineRect.origin.y = CGRectGetMaxY(self.scannerRect) - 4;
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.scanLine.frame = lineRect;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  结束扫描动画
 */
-(void)stopScanAnimation
{
    if (!self.scanLine) {
        return;
    }
    
    [self.scanLine.layer removeAllAnimations];
    self.scanLine.hidden = YES;
    self.scanLine.frame = CGRectMake(self.scannerRect.origin.x, self.scannerRect.origin.y, self.scannerRect.size.width, 4);
}

/**
 *  开始扫描
 */
- (void)startScanning
{
    if (!self.session) {
        return;
    }
    
    if (!self.session.isRunning){
        [self.session startRunning];
    }
}

/**
 *  结束扫描动画
 */
- (void)stopScanning
{
    if (!self.session) {
        return;
    }
    
    if (self.session.isRunning) {
        [self.session stopRunning];
    }
}


@end
