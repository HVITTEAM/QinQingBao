//
//  UpdatePwdViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "UpdatePwdViewController.h"

@interface UpdatePwdViewController ()
{
    float timesec;
    
    NSString *btnTitle;
    
    NSTimer *timer;
    
}

@end

@implementation UpdatePwdViewController

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
    self.title = @"修改密码";
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
    tel.buttonClickBlock = ^(UIButton *btn){
        if (self.tel.rightText.text.length != 11)
            return [NoticeHelper AlertShow:@"请输入正确的电话号码" view:self.view];
        
        [self.view endEditing:YES];
        [[MTSMSHelper sharedInstance] getCheckcode:self.tel.rightText.text];
        [MTSMSHelper sharedInstance].sureSendSMS = ^{
            [NoticeHelper AlertShow:@"验证码发送成功,请查收！" view:self.view];
            [self countdownHandler];
        };
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
    if(self.nowPwd.rightText.text != self.old.rightText.text )
        return [NoticeHelper AlertShow:@"两次密码输入不同!" view:self.view];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Forgot parameters: @{@"mobile" : self.tel.rightText.text,
                                                               @"code" : self.code.rightText.text,
                                                               @"password" : self.old.rightText.text,
                                                               @"password_confirm" : self.nowPwd.rightText.text}
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
                                         [NoticeHelper AlertShow:@"修改成功！" view:self.view];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [NoticeHelper AlertShow:@"注册失败!" view:self.view];
                                 }];
    
}

@end
