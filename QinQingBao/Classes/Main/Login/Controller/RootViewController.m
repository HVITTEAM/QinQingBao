//
//  RootViewController.m
//  QinQingBao
//
//  Created by shi on 15/8/13.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "RootViewController.h"
#import "RegistViewController.h"
#import "LoginViewController.h"

@interface RootViewController ()

- (IBAction)regist:(id)sender;
- (IBAction)login:(id)sender;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置registBtn、loginBtn两个按钮圆角
    self.registBtn.layer.cornerRadius = 3.0f;
    self.registBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 3.0f;
    self.loginBtn.layer.masksToBounds = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:12/255.0 green:167/255.0 blue:161/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)regist:(id)sender {
    RegistViewController *registVC = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:registVC animated:YES];
}

- (IBAction)login:(id)sender {
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:loginVC animated:YES];
}
@end
