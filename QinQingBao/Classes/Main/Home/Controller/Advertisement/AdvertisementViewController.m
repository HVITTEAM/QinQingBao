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
    UIScrollView *bgScrollview;
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
    
    [self initScrollView];
    
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

-(void)initScrollView
{
    bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
    bgScrollview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgScrollview];
}

-(void)initNavgation
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_icon.png"
                                                                 highImageName:@"back_icon.png"
                                                                        target:self action:@selector(back)];
}

-(void)initData
{
    UIImageView *lastimg;
    //按摩推拿
    if (self.type == 5)
    {
        UIImage *img;
        if (self.type == 3)
            img = [UIImage imageNamed:@"heartmanager.jpg"];
        else if (self.type == 4)
            img = [UIImage imageNamed:@"bloodp.jpg"];
        else if (self.type == 5)
            img = [UIImage imageNamed:@"massage.jpg"];
        CGSize size = img.size;
        //缩放比例
        float scalePro = MTScreenW / size.width;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        imageView.x = 0;
        imageView.y = CGRectGetMaxY(lastimg.frame);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.width = MTScreenW;
        imageView.height = size.height * scalePro;
        
        [bgScrollview addSubview:imageView];
        bgScrollview.contentSize = CGSizeMake(MTScreenW,  CGRectGetMaxY(imageView.frame));
        lastimg = imageView;
        
        return;
    }
    //轮播广告图片
    HomePicModel *item = self.selectedItem;
    self.title  = item.title;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_WebImg,item.bc_article_url]];
    webv = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webv.y = 40;
    NSURLRequest *request = [NSURLRequest requestWithURL:iconUrl];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    webv.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
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
