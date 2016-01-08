//
//  MTProgressWebViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/30.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "MTProgressWebViewController.h"
#import "WebViewJavascriptBridge.h"


@interface MTProgressWebViewController ()
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIWebView *webView;
    
}
@property (nonatomic, retain) WebViewJavascriptBridge *bridge;

@end

@implementation MTProgressWebViewController

//-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
////        self.hidesBottomBarWhenPushed = YES;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[UIApplication sharedApplication].
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.navigationController.navigationBar addSubview:_progressView];
    
    [self addEventListener];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

/**
 * 添加js交互监听
 **/
-(void)addEventListener
{
    //js 交互
    [WebViewJavascriptBridge enableLogging];
    
    if (!_bridge) {
        _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            NSString *str = [NSString stringWithFormat:@"%@",data];
            if ([str isEqualToString:@"0"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([str isEqualToString:@"1"]) {
                LoginViewController *login = [[LoginViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
                [[SharedAppUtil defaultCommonUtil].tabBar presentViewController:nav animated:YES completion:nil];
                login.backHiden = NO;
            }
        }];
    }
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    [_progressView removeFromSuperview];
//    
//    [self clearCookies];
//}

/**
 *清空手机端访问网页的cookie
 **/
-(void)clearCookies
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}

-(void)setUrl:(NSString *)url
{
    _url = url;
}

-(void)initData
{
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    NSURL *iconUrl = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:iconUrl cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0f];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    
    webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 20)];
    view.backgroundColor = MTNavgationBackgroundColor;
    [self.view addSubview:view];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

@end
