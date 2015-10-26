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
    [self.view endEditing:YES];
    [[MTSMSHelper sharedInstance] getCheckcode:self.phoneNumText.text];
    [MTSMSHelper sharedInstance].sureSendSMS = ^{
        [NoticeHelper AlertShow:@"验证码发送成功,请查收！" view:self.view];
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
- (IBAction)agreement:(id)sender
{
    self.agreementBtn.selected = !self.agreementBtn.selected;
}

/**
 *  立即进行注册
 *
 */
- (IBAction)registNow:(id)sender
{
    if (![self checkForm])
    {
        [NoticeHelper AlertShow:@"请输入完整信息！" view:self.view];
        return;
    }
    else
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [CommonRemoteHelper RemoteWithUrl:URL_Register parameters: @{@"mobile" : self.phoneNumText.text,
                                                                     @"password" : [SecurityUtil encryptMD5String:self.passwordText.text],
                                                                     @"password_confirm" : [SecurityUtil encryptMD5String:self.passwordText.text],
                                                                     @"code" : self.VerNumText.text,
                                                                     @"client" : @"ios"}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         [HUD removeFromSuperview];
                                         [self.view endEditing:YES];
                                         
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             [NoticeHelper AlertShow:@"注册成功！" view:self.view];
                                             NSDictionary *di = [dict objectForKey:@"datas"];
                                             UserModel *vo = [UserModel objectWithKeyValues:di];
                                             [SharedAppUtil defaultCommonUtil].userVO = vo;
                                             [ArchiverCacheHelper saveObjectToLoacl:vo key:User_Archiver_Key filePath:User_Archiver_Path];
                                             [MTControllerChooseTool setRootViewController];
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                         [NoticeHelper AlertShow:@"注册失败!" view:self.view];
                                     }];
    }
}

/**
 * 检查表单是否填写正确
 */
-(BOOL)checkForm
{
    if (self.phoneNumText.text.length == 0)
        return NO;
    else if (self.VerNumText.text.length == 0)
        return NO;
    else if (self.passwordText.text.length == 0)
        return NO;
    else
        return YES;
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumText || textField == self.VerNumText) {
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
    }
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (textField == self.phoneNumText)
    {
        if (proposedNewLength > 11)
            return NO;//限制长度
    }
    else  if (textField == self.VerNumText)
    {
        if (proposedNewLength > 4)
            return NO;//限制长度
    }
    else  if (textField == self.passwordText)
    {
        if (proposedNewLength > 20)
            return NO;//限制长度
    }
    return YES;
}


#pragma mark about keyBoard method
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
