//
//  WebViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/16.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgation];
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURL *url =[NSURL URLWithString:@"http://www.baidu.com"];
    //    NSLog(urlString);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
}

-(void)initNavgation
{
    self.title = @"广告界面";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"default_common_navibar_prev_normal.png"
                                                                 highImageName:@"default_common_navibar_prev_highlighted.png"
                                                                        target:self action:@selector(back)];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
