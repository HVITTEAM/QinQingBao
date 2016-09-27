//
//  RegistViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "RegistViewController.h"
#import "AgreementViewController.h"
#import "CompleteInfoController.h"
#import "JPUSHService.h"

@interface RegistViewController ()<UITextFieldDelegate>
{
    float timesec;
    
    NSString *btnTitle;
    
    NSTimer *timer;
    
}


@end

@implementation RegistViewController

- (void)viewDidLoad
{
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
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
    //    self.verBtn.layer.cornerRadius = 5.0f;
    //    self.verBtn.layer.masksToBounds = YES;
    //    self.verBtn.layer.borderWidth = 1.0f;
    //    self.verBtn.layer.borderColor = [[UIColor redColor] CGColor];
    
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



- (IBAction)agreeChange:(id)sender
{
    self.agreementBtn.selected = !self.agreementBtn.selected;
}

/**
 *  阅读并同意协议
 *
 */
- (IBAction)agreement:(id)sender
{
    AgreementViewController *vc = [[AgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  立即进行注册
 *
 */
- (IBAction)registNow:(id)sender
{
    //去除左右两边空格
    NSString *str1 = [self.passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![self checkForm])
    {
        [NoticeHelper AlertShow:@"请输入完整信息！" view:self.view];
        return;
    }
    if(str1.length < 6)
    {
        [NoticeHelper AlertShow:@"密码不能少于6位！" view:self.view];
        return;
    }
    else if (!self.agreementBtn.selected)
    {
        [NoticeHelper AlertShow:@"请阅读并同意亲情宝服务条款！" view:self.view];
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
                                             
                                             [MTNotificationCenter postNotificationName:MTReLogin object:nil];
                                             
                                             [self loginBBS:vo];
                                             //设置推送标签和别名
                                             [JPUSHService setTags:nil alias: [NSString stringWithFormat:@"qqb%@",vo.member_mobile] callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
                                             [self.navigationController.viewControllers[0] dismissViewControllerAnimated:YES completion:nil];
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                         [NoticeHelper AlertShow:@"注册失败!" view:self.view];
                                     }];
    }
}

// 登录bbs
-(void)loginBBS:(UserModel *)vo
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_loginToOtherSys parameters: @{@"key" :vo.key,
                                                                            @"client" : @"ios",
                                                                            @"targetsys" : @"4"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     NSLog(@"%@",dict);
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         // 当目标系统不存在该用户的时候：
                                         if ([codeNum integerValue] == 18001)
                                         {
                                             CompleteInfoController *conplete = [[CompleteInfoController alloc] init];
                                             [self.navigationController pushViewController:conplete animated:YES];
                                         }
                                         else
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                     }
                                     else
                                     {
                                         NSDictionary *datas = [dict objectForKey:@"datas"];
                                         
                                         BBSUserModel *bbsmodel = [[BBSUserModel alloc] init];
                                         bbsmodel.BBS_Key = [datas objectForKey:@"key"];
                                         bbsmodel.BBS_Member_id = [datas objectForKey:@"member_id"];
                                         bbsmodel.BBS_Member_mobile = [datas objectForKey:@"member_mobile"];
                                         bbsmodel.BBS_Sys = [datas objectForKey:@"sys"];
                                         
                                         [SharedAppUtil defaultCommonUtil].bbsVO = bbsmodel;
                                         [ArchiverCacheHelper saveObjectToLoacl:bbsmodel key:BBSUser_Archiver_Key filePath:BBSUser_Archiver_Path];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}


#pragma mark - JPush 推送标签和别名

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
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

#pragma mark - 解决键盘遮挡文本框
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
