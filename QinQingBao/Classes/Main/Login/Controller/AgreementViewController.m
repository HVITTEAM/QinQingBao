//
//  AgreementViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/11.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"寸欣健康协议";
    self.view.backgroundColor = [UIColor whiteColor];

    self.webv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH)];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"agreement" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URL_Agreement]];
    [self.webv loadRequest:req];

    [self.view addSubview:self.webv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
