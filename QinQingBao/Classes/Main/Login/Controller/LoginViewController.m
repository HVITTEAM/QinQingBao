//
//  LoginViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//


#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)

#import "LoginViewController.h"
#import "RegistViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

- (IBAction)loginNow:(id)sender;
- (IBAction)regist:(id)sender;
- (IBAction)backPassword:(id)sender;
- (IBAction)sigleTapBackgrouned:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.layer.masksToBounds = YES;
    
    self.accountText.delegate = self;
    self.passwordText.delegate = self;
   
    self.navigationItem.title = @"登陆";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma UITextField delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentText = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentText = nil;
}

- (IBAction)sigleTapBackgrouned:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)loginNow:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)regist:(id)sender {
    RegistViewController *registVC = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:registVC animated:YES];
    
}

- (IBAction)backPassword:(id)sender {
}



-(void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    CGRect keyboardFrame = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyBoardH = keyboardFrame.size.height;
    CGFloat keyBoardToTop = kScreenHeight - self.keyBoardH;
    NSInteger animationCurve =[[dict objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration =  [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect currentTextFrame = [self.view convertRect:self.currentText.frame fromView:self.txtview];
    CGFloat currentTextBottomToTop = CGRectGetMaxY(currentTextFrame);
    
    if (keyBoardToTop - currentTextBottomToTop < 0) {
        [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
            
            self.view.bounds = CGRectMake(0, -(keyBoardToTop-currentTextBottomToTop)+30, kScreenWidth, kScreenHeight);
            
        } completion:nil];
    }
    
}

-(void)keyBoardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.bounds = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
    
}




@end
