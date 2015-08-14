//
//  RegistViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)

#import "RegistViewController.h"

@interface RegistViewController ()<UITextFieldDelegate>

- (IBAction)getVerificationCode:(id)sender;
- (IBAction)agreement:(id)sender;
- (IBAction)registNow:(id)sender;
- (IBAction)sigleTapBackgrouned:(id)sender;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置phoneNumText，VerNumText,passwordText代理
    self.phoneNumText.delegate = self;
    self.VerNumText.delegate = self;
    self.passwordText.delegate = self;
    
    //更新界面
    [self updateInterface];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 *设置视图中控件的外观属性
 */
-(void)updateInterface
{
    self.verBtn.layer.cornerRadius = 5.0f;
    self.verBtn.layer.masksToBounds = YES;
    self.verBtn.layer.borderWidth = 1.0f;
    self.verBtn.layer.borderColor = [[UIColor redColor] CGColor];
    
    self.registNowBtn.layer.cornerRadius = 5.0f;
    self.registNowBtn.layer.masksToBounds = YES;
    
    self.navigationItem.title = @"注册";
}


/**
 *  获取验证码
 */
- (IBAction)getVerificationCode:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%u",arc4random()%100000] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

/**
 *  阅读并同意协议
 *
 */
- (IBAction)agreement:(id)sender {
    self.agreementBtn.selected = !self.agreementBtn.selected;
}

/**
 *  立即进行注册
 *
 */
- (IBAction)registNow:(id)sender {
    
    [self.view endEditing:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}


#pragma UITextField delegate method
/**
 *UITextField代理方法
 *
 */
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
    self.currentText= nil;
}


#pragma about keyBoard method
- (IBAction)sigleTapBackgrouned:(id)sender {
    [self.view endEditing:YES];
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
    CGFloat currentTextToTop = CGRectGetMaxY(currentTextFrame);
    
    if (keyBoardToTop - currentTextToTop < 0) {
        [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
            
            self.view.bounds = CGRectMake(0, (keyBoardToTop-currentTextToTop), kScreenWidth, kScreenHeight);
            
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
