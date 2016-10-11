//
//  LoginViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "UpdatePwdViewController.h"
#import "JPUSHService.h"
#import "MobileBindingView.h"
#import "BBSUserModel.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *accountText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

//容纳文本输入框的UIView
@property (strong, nonatomic) IBOutlet UIView *txtview;
//当前正在使用的文本输入框
@property (strong,nonatomic)UITextField *currentText;
//键盘高度
@property(assign,nonatomic)CGFloat keyBoardH;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //    self.navigationController.navigationBarHidden = YES;
    //
    //    //取消导航栏下方黑线
    //    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
    //        NSArray *list=self.navigationController.navigationBar.subviews;
    //        for (id obj in list) {
    //            if ([obj isKindOfClass:[UIImageView class]]) {
    //                UIImageView *imageView=(UIImageView *)obj;
    //                NSArray *list2=imageView.subviews;
    //                for (id obj2 in list2) {
    //                    if ([obj2 isKindOfClass:[UIImageView class]]) {
    //                        UIImageView *imageView2=(UIImageView *)obj2;
    //                        imageView2.hidden=YES;
    //                    }
    //                }
    //            }
    //        }
    //    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //解除键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupUI
{
    //设置登录按钮外观
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.layer.masksToBounds = YES;
    
    self.accountText.delegate = self;
    self.passwordText.delegate = self;
    
    //设置导航栏
    UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:HMColor(244, 143, 54) forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [registBtn addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:registBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [backBtn setTitleColor:HMColor(244, 143, 54) forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_dismissItem.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [backBtn addTarget:self action:@selector(backHanlder:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    if (!self.backHiden)
        self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = @"登录";
}


#pragma mark UITextField协议方法
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

#pragma UITextField delegate method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.accountText)
    {
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
    }
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (textField == self.accountText)
    {
        if (proposedNewLength > 11)
            return NO;//限制长度
    }
    return YES;
}

/**
 *  单击背景取消键盘
 */
- (IBAction)sigleTapBackgrouned:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - 登录、注册、取回密码
/**
 *  登录
 */
- (IBAction)loginNow:(id)sender
{
    if (![self checkForm])
    {
        [NoticeHelper AlertShow:@"请输入完整信息" view:self.view];
    }
    else
    {
        [self.view endEditing:YES];
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_Login_New parameters: @{@"username" : self.accountText.text,
                                                                      @"password" : [SecurityUtil encryptMD5String:self.passwordText.text],
                                                                      @"client" : @"ios",
                                                                      @"sys" : @"2"}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             [NoticeHelper AlertShow:@"登录成功！" view:self.view];
                                             NSDictionary *di = [dict objectForKey:@"datas"];
                                             UserModel *vo = [UserModel objectWithKeyValues:di];
                                             vo.logintype = @"0";
                                             vo.member_mobile = self.accountText.text;
                                             vo.pwd = [self.passwordText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                             [self loginResultSetData:vo];
                                             NSLog(@"寸欣健康登录成功！");
                                             [self loginBBS:vo];
                                         }
                                         [HUD removeFromSuperview];
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                         [self.view endEditing:YES];
                                     }];
    }
}

// 尝试登录bbs
-(void)loginBBS:(UserModel *)vo
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_loginToOtherSys parameters: @{@"key" :vo.key,
                                                                            @"client" : @"ios",
                                                                            @"targetsys" : @"4"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     NSLog(@"%@",dict);
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         NSLog(@"BBS登录失败！");
                                     }
                                     else
                                     {
                                         NSLog(@"BBS登录成功！");

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

/**
 *  跳转到注册界面
 */
- (IBAction)regist:(id)sender
{
    RegistViewController *registVC = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    registVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registVC animated:YES];
}

/**
 *  找回密码
 */
- (IBAction)backPassword:(id)sender
{
    UpdatePwdViewController *updateView = [[UpdatePwdViewController alloc]init];
    [self.navigationController pushViewController:updateView animated:YES];
}

/**
 * 检查表单是否填写正确
 */
-(BOOL)checkForm
{
    if (self.accountText.text.length == 0)
        return NO;
    else if (self.passwordText.text.length == 0)
        return NO;
    else
        return YES;
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
    CGFloat currentTextBottomToTop = CGRectGetMaxY(currentTextFrame);
    
    if (keyBoardToTop - currentTextBottomToTop < 0) {
        [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
            
            self.view.bounds = CGRectMake(0, -(keyBoardToTop-currentTextBottomToTop)+30, MTScreenW, MTScreenH);
            
        } completion:nil];
    }
}

-(void)keyBoardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.bounds = CGRectMake(0, 0, MTScreenW, MTScreenH);
    }];
}


- (void)backHanlder:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 第三方登录

- (IBAction)qqlogin:(id)sender
{
    //SSDKPlatformTypeSinaWeibo 1
    //SSDKPlatformTypeQQ 998
    //SSDKPlatformTypeWechat 997
    UIButton *btn = (UIButton *)sender;
    [ShareSDK getUserInfo:btn.tag
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"uid=%@",user.uid);
             NSLog(@"credential=%@",user.credential);
             NSLog(@"openid=%@",[user.credential.rawData objectForKey:@"openid"]);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             NSLog(@"icon=%@",user.icon);
             NSString *login_type;
             switch (btn.tag) {
                 case SSDKPlatformTypeSinaWeibo:
                     login_type = @"3";
                     break;
                 case SSDKPlatformTypeQQ:
                     login_type = @"1";
                     break;
                 case SSDKPlatformTypeWechat:
                     login_type = @"2";
                     break;
                 default:
                     break;
             }
             [self loginSuccessWithOpenid:user.uid login_type:login_type open_token:user.credential.token mobile:@"" code:@""];
         }
         else
         {
             NSLog(@"%@",error);
         }
     }];
}

/**
 *  第三方登录成功调用后台接口注册账号
 *
 *  @param openid     第三方登录ID
 *  @param login_type 第三方登录类型 分别为 qq：1 微信：2 新浪：3
 *  @param open_token 第三方登录返回的token
 *  @param mobile     电话号码，如果第一次登录则需要
 *  @param code       验证码
 */
-(void)loginSuccessWithOpenid:(NSString *)openid login_type:(NSString *)login_type open_token:(NSString *)open_token mobile:(NSString *)mobile code:(NSString *)code
{
    NSLog(@"adaaaaa%@",openid);
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_LoginByother_new parameters: @{@"open_id" : openid,
                                                                     @"login_type" : login_type,
                                                                     @"open_token" : open_token,
                                                                     @"client" : @"ios",
                                                                     @"mobile":mobile,
                                                                     @"code" :code,
                                                                     @"sys" : @"2"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         if ([codeNum isEqualToString:@"11010"])
                                         {
                                             UIWindow *wd = [UIApplication sharedApplication].keyWindow;
                                             MobileBindingView *bindingView = [MobileBindingView showMobileBindingViewToView:wd];
                                             bindingView.tapConfirmBtnCallBack = ^(NSString *phone,NSString *verificationCode){
                                                 [self loginSuccessWithOpenid:openid login_type:login_type open_token:open_token mobile:phone code:verificationCode];
                                             };
                                             bindingView.tapCancelBtnCallBack = ^(void){
                                                 //清楚第三方的授权信息
                                                 [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                                                 [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                                                 [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                                             };
                                         }
                                         else
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                     }
                                     else
                                     {
                                         [NoticeHelper AlertShow:@"登录成功！" view:self.view];
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         UserModel *vo = [UserModel objectWithKeyValues:di];
                                         vo.logintype = login_type;
                                         vo.member_mobile = mobile;
                                         [self loginResultSetData:vo];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
    
}


/**
 *  登录成功之后需要设置本地登录数据
 *
 *  @param uservo 用户信息model
 */
-(void)loginResultSetData:(UserModel *)uservo
{
    [SharedAppUtil defaultCommonUtil].userVO = uservo;
    [ArchiverCacheHelper saveObjectToLoacl:uservo key:User_Archiver_Key filePath:User_Archiver_Path];
    
    //backHide 是否隐藏左上角的返回按钮 如果是yes的话，说明是在监控和个人中心界面 否则在下单的时候弹出的界面
    if (!self.backHiden)
        [self dismissViewControllerAnimated:YES completion:nil];
    [MTNotificationCenter postNotificationName:MTReLogin object:nil];
    //设置推送标签和别名
    [JPUSHService setTags:nil alias: [NSString stringWithFormat:@"qqb%@",uservo.member_mobile] callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}

#pragma mark - JPush 推送标签和别名

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
@end
