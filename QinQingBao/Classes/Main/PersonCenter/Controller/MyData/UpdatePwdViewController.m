//
//  UpdatePwdViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "UpdatePwdViewController.h"
#import "JPUSHService.h"

@interface UpdatePwdViewController ()<UIAlertViewDelegate>
{
    float timesec;
    
    NSString *btnTitle;
    
    NSTimer *timer;
    
}

@end


@implementation UpdatePwdViewController


-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initNavigation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
    
    [self setupGroups];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = HMStatusCellMargin;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(HMStatusCellMargin - 35, 0, 0, 0);
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"找回密码";
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
        [self.tel.btn setTitle:@"获取验证码" forState: UIControlStateNormal];
        [self.tel.btn setTitleColor:HMColor(69, 134, 229) forState:UIControlStateNormal];
        [self.tel.btn setEnabled:YES];
    }else
    {
        timesec--;
        NSString *title = [NSString stringWithFormat:@"%.f秒后重发",timesec];
        [self.tel.btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.tel.btn setEnabled:NO];
        [self.tel.btn setTitle:title forState:UIControlStateNormal];
    }
}


# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup];
    [self setupFooter];
}

- (void)setupGroup
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    HMCommonButtonItem *tel = [HMCommonButtonItem itemWithTitle:@"电话号码" icon:nil];
    tel.btnTitle = @"获取验证码";
    tel.buttonClickBlock = ^(UIButton *btn)
    {
        if (self.tel.rightText.text.length != 11)
            return [NoticeHelper AlertShow:@"请输入正确的电话号码" view:self.view];
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_GetForgotCode parameters: @{@"mobile" : self.tel.rightText.text}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         [HUD removeFromSuperview];
                                         [self.view endEditing:YES];
                                         if (dict == nil)
                                             return [NoticeHelper AlertShow:@"未知错误！" view:self.view];
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             [NoticeHelper AlertShow:@"验证码发送成功,请查收！" view:self.view];
                                             [self countdownHandler];
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                     }];
        
    };
    tel.placeholder = @"请输入电话号码";
    self.tel = tel;
    
    HMCommonTextfieldItem *code = [HMCommonTextfieldItem itemWithTitle:@"验证码" icon:nil];
    code.placeholder = @"请输入验证码";
    self.code = code;
    
    HMCommonTextfieldItem *oldPwd = [HMCommonTextfieldItem itemWithTitle:@"新的密码" icon:nil];
    oldPwd.secureTextEntry = YES;
    oldPwd.placeholder = @"请输入新密码";
    self.old = oldPwd;
    
    HMCommonTextfieldItem *nowpwd = [HMCommonTextfieldItem itemWithTitle:@"确认密码" icon:nil];
    nowpwd.placeholder = @"请再输入一次新密码";
    nowpwd.secureTextEntry = YES;
    self.nowPwd = nowpwd;
    
    group.items = @[tel,code,oldPwd,nowpwd];
}

- (void)setupFooter
{
    // 1.创建按钮
    UIButton *logout = [[UIButton alloc] init];
    
    // 2.设置属性
    logout.titleLabel.font = [UIFont systemFontOfSize:16];
    [logout setTitle:@"确定" forState:UIControlStateNormal];
    [logout setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [logout addTarget:self action:@selector(sureHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    logout.height = 50;
    
    self.tableView.tableFooterView = logout;
}

-(void)sureHandler:(UIButton *)sender
{
    //去除左右两边空格
    NSString *str1 = [self.nowPwd.rightText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *str2 = [self.old.rightText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (str1.length == 0 || str2.length == 0 ||self.code.rightText.text.length == 0)
        return [NoticeHelper AlertShow:@"请输入完整的信息" view:self.view];
    if (str1.length <6)
        return [NoticeHelper AlertShow:@"密码不能少于6位" view:self.view];
    if(![str1 isEqualToString:str2] )
        return [NoticeHelper AlertShow:@"两次密码输入不同!" view:self.view];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view endEditing:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Forgot parameters: @{@"mobile" : self.tel.rightText.text,
                                                               @"code" : self.code.rightText.text,
                                                               @"password" : [SecurityUtil encryptMD5String:str2],
                                                               @"password_confirm" : [SecurityUtil encryptMD5String:str1]}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [HUD removeFromSuperview];
                                     if (dict == nil)
                                         return [NoticeHelper AlertShow:@"未知错误！" view:self.view];
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作成功，返回登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         alertView.delegate = self;
//                                         [alertView show];
                                         
                                         [self loginWithAccount:self.tel.rightText.text pwd:str1];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [NoticeHelper AlertShow:@"注册失败!" view:self.view];
                                 }];
    
}

-(void)loginWithAccount:(NSString *)tel pwd:(NSString *)pwd
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Login parameters: @{@"username" : tel,
                                                              @"password" : [SecurityUtil encryptMD5String:pwd],
                                                              @"client" : @"ios",
                                                              @"role" : @"0",
                                                              @"imei":[SharedAppUtil defaultCommonUtil].deviceToken == nil ? @"" : [SharedAppUtil defaultCommonUtil].deviceToken}
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
                                         vo.member_mobile = tel;
                                         vo.pwd = [pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                         [self loginResultSetData:vo];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
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
    
    [MTControllerChooseTool setMainViewcontroller];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //设置推送标签和别名
    NSMutableSet *tags = [NSMutableSet set];
    [self setTags:&tags addTag:@""];
    [JPUSHService setTags:tags alias: [NSString stringWithFormat:@"qqb%@",uservo.member_mobile] callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}

#pragma mark - JPush 推送标签和别名
- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag
{
    [*tags addObject:tag];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
