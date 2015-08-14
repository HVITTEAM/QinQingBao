//
//  RegistViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()<UITextFieldDelegate>
{
    float timesec;
    
    NSString *btnTitle;
    
    NSTimer *timer;

}

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
    self.agreementBtn.selected = YES;
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.editing = NO;
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
- (IBAction)getVerificationCode:(id)sender
{
    MTSMSHelper *helper = [[MTSMSHelper alloc] init];
    [helper getCheckcode:self.phoneNumText.text];
    helper.sureSendSMS = ^{
        [self countdownHandler];
    };
}

#pragma mark 倒计时模块

/**
 *  倒计时
 */
-(void)countdownHandler
{
    timesec = 60.0f;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

-(void)timerFireMethod:(NSTimer *)theTimer
{
    if (timesec == 1) {
        [theTimer invalidate];
        timesec = 60;
        [self.verBtn setTitle:@"获取验证码" forState: UIControlStateNormal];
        [self.verBtn setTitleColor:HMColor(69, 134, 229) forState:UIControlStateNormal];
        [self.verBtn setEnabled:YES];
    }else
    {
        timesec--;
        NSString *title = [NSString stringWithFormat:@"%.f秒后重发",timesec];
        [self.verBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.verBtn setEnabled:NO];
        [self.verBtn setTitle:title forState:UIControlStateNormal];
    }
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

#pragma mark 解决键盘遮挡文本框

-(void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    CGRect keyboardFrame = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyBoardH = keyboardFrame.size.height;
    CGFloat keyBoardToTop = MTScreenH - self.keyBoardH;
    NSInteger animationCurve =[[dict objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration =  [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect currentTextFrame = [self.view convertRect:self.currentText.frame fromView:self.txtview];
    CGFloat currentTextToTop = CGRectGetMaxY(currentTextFrame);
    
    if (keyBoardToTop - currentTextToTop < 0) {
        [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
            
            self.view.bounds = CGRectMake(0, (keyBoardToTop-currentTextToTop), MTScreenW, MTScreenH);
            
        } completion:nil];
    }
}

-(void)keyBoardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.bounds = CGRectMake(0, 0, MTScreenW, MTScreenH);
    }];
    
}


@end
