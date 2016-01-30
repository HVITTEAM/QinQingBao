//
//  MTProgressWebViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/30.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "MTProgressWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "MTShoppingCarController.h"
#import "ClassificationViewController.h"
#import "SearchViewController.h"

#import "GoodsTableViewController.h"
#import "GoodsHeadViewController.h"

@interface MTProgressWebViewController ()<UISearchBarDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIWebView *webView;
    
}
@property (nonatomic, retain) WebViewJavascriptBridge *bridge;

@end

@implementation MTProgressWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    
    [self initNavigation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //    [self.navigationController.navigationBar addSubview:_progressView];
    
    [self addEventListener];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    //    self.title = @"商品详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"购物车" style:UIBarButtonItemStylePlain target:self action:@selector(gotoShopCar)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(gotoShopClass)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(100, 20, 150, 37)];
    searchBar.placeholder = @"江山臭豆腐";
    [searchBar setBarStyle:UIBarStyleDefault];
    searchBar.translucent = true;
    //    searchBar.tintColor=[UIColor blueColor];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    UITapGestureRecognizer *searchTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickHandler:)];
    [searchBar addGestureRecognizer:searchTap];
}

-(void)ClickHandler:(UITapGestureRecognizer *)tap
{
    NSLog(@"dian");
}

-(void)gotoShopClass
{
    ClassificationViewController *shopCar = [[ClassificationViewController alloc] init];
    [self.navigationController pushViewController:shopCar animated:YES];
}

-(void)gotoShopCar
{
    MTShoppingCarController *shopCar = [[MTShoppingCarController alloc] init];
    [self.navigationController pushViewController:shopCar animated:YES];
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
                [self presentViewController:nav animated:YES completion:nil];
                login.backHiden = NO;
            }
            else if ([str isEqualToString:@"6"]) {
                ClassificationViewController *class = [[ClassificationViewController alloc] init];
                [self.navigationController pushViewController:class animated:YES];
            }
            else if ([str isEqualToString:@"2"]) {
                if (![SharedAppUtil defaultCommonUtil].userVO )
                    return [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
                MTShoppingCarController *shopCar = [[MTShoppingCarController alloc] init];
                [self.navigationController pushViewController:shopCar animated:YES];
            }
            else if (str.length > 2)
            {
                NSArray *arr = [str componentsSeparatedByString:@"-"];
                switch ([arr[0] integerValue]) {
                    case 7:
                    {
                        GoodsTableViewController *vc = [[GoodsTableViewController alloc] init];
                        vc.gc_id = arr[1];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 8:
                    {
                        GoodsHeadViewController *vc = [[GoodsHeadViewController alloc] init];
                        vc.goodsID = arr[1];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 5:
                    {
                        GoodsTableViewController *vc = [[GoodsTableViewController alloc] init];
                        vc.keyWords = arr[1];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }
            
        }];
    }
}

-(void)handler
{
    MTShoppingCarController *shopCar = [[MTShoppingCarController alloc] init];
    UINavigationController *navShop = [[UINavigationController alloc] initWithRootViewController:shopCar];
    [self.navigationController pushViewController:navShop animated:YES];
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
