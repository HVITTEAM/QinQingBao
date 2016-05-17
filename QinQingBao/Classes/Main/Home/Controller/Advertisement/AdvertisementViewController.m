//
//  AdvertisementViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/8.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AdvertisementViewController.h"
#import "HomePicModel.h"
#import "NJKWebViewProgressView.h"

@interface AdvertisementViewController ()
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIWebView *webv;
}

@end

@implementation AdvertisementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_progressView removeFromSuperview];
}


-(void)initNavgation
{
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_dismissItem.png"
                                                                 highImageName:@"btn_dismissItem_highlighted.png"
                                                                        target:self action:@selector(back)];
}

-(void)initData
{
    //轮播广告图片
    HomePicModel *item = self.selectedItem;
    self.title  = item.title;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_WebImg,item.bc_article_url]];
    webv = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webv.backgroundColor = [UIColor redColor];
    NSURLRequest *request = [NSURLRequest requestWithURL:iconUrl];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    webv.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, 0, MTScreenW, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [webv loadRequest:request];
    [self.view addSubview:webv];
    NSLog(@"%@",iconUrl);
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
//    self.title = [webv stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
