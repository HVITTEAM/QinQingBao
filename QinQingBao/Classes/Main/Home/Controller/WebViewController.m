//
//  WebViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/16.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "WebViewController.h"
#import "NJKWebViewProgressView.h"

@interface WebViewController ()

@end

@implementation WebViewController
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIWebView *web;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
    web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:web];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    web.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self loadGoogle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

-(void)loadGoogle
{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
    [web loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)initNavgation
{
    //    self.title = @"广告界面";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"default_common_navibar_prev_normal.png"
                                                                 highImageName:@"default_common_navibar_prev_highlighted.png"
                                                                        target:self action:@selector(back)];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
