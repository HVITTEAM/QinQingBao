//
//  AddMemberViewController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "AddMemberViewController.h"
#import "AddMemberViewController1.h"

#import "BasicInfoViewController.h"

@interface AddMemberViewController ()
{
    
    float timesec;
    
    NSTimer *timer;
    
    UIButton *getCodeBtn;
}

@end

@implementation AddMemberViewController


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
    self.title = @"添加家属";
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup1];
    [self setupFooter];
}

- (void)setupGroup1
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    HMCommonTextfieldItem *numfield = [HMCommonTextfieldItem itemWithTitle:@"亲属昵称" icon:nil];
    numfield.placeholder = @"如:爷爷、奶奶、二大爷等";
    self.numfield = numfield;
    
    numfield.buttonClickBlock = ^(UIButton *btn){
        NSLog(@"----点击了确认按钮-");
        self.telfield.rightText.text = @"15261212811";
        self.telfield.rightText.clearButtonMode =  UITextFieldViewModeNever;
    };
    
    numfield.operation = ^{
        NSLog(@"----点击了n---%@",self.numfield.rightText.text);
    };
    
    HMCommonTextfieldItem *telfield = [HMCommonTextfieldItem itemWithTitle:@"识别码" icon:nil];
    telfield.placeholder = @"已注册的手机号码/身份证号码";
    self.telfield = telfield;
    self.telfield.rightText.userInteractionEnabled = NO;
    telfield.operation = ^{
        NSLog(@"----点击了n---");
    };
    
    // 2.设置组的所有行数据
    HMCommonButtonItem *codefield = [HMCommonButtonItem itemWithTitle:@"验证码" icon:nil];
    codefield.btnTitle = @"获取验证码";
    codefield.placeholder = @"请输入验证码";
    self.codefield = codefield;
    
    codefield.buttonClickBlock = ^(UIButton *btn){
        NSLog(@"----点击了获取验证码按钮-");
        getCodeBtn = btn;
        [self sendMsg];
    };
    
    group.items = @[numfield,telfield];
}

- (void)setupFooter
{
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenH, 110)];
    
    UILabel *lab0 = [[UILabel alloc] init];
    lab0.text = @"说明：验证码发送至被监护老人手机号，有效期为3分钟";
    lab0.font = [UIFont fontWithName:@"Helvetica" size:12];
    lab0.textColor = [UIColor grayColor];
    CGSize size0 = [lab0.text sizeWithAttributes:@{NSFontAttributeName:lab0.font}];
    if (size0.width > MTScreenW *0.8)
    {
        lab0.width = MTScreenW *0.8;
        lab0.height = size0.height *2;
        lab0.numberOfLines = 0 ;
        footview.height = footview.height + size0.height + 10;
    }
    else
    {
        lab0.width = size0.width;
        lab0.height = size0.height;
    }
    
    lab0.x = self.view.width/2 - lab0.width/2;
    lab0.y = 0;
    //    [footview addSubview:lab0];
    
    // 1.创建按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50)];
    
    // 2.设置属性
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [okBtn addTarget:self action:@selector(sureHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    [footview addSubview:okBtn];
    
    UIButton *changeType = [[UIButton alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(okBtn.frame) + 10, 120, 20)];
    changeType.titleLabel.font = [UIFont systemFontOfSize:13];
    [changeType setTitle:@"亲友尚无账号？请先注册" forState:UIControlStateNormal];
    [changeType setTitleColor:MTNavgationBackgroundColor forState:UIControlStateNormal];
    [changeType addTarget:self action:@selector(changeType) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size = [changeType.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:changeType.titleLabel.font}];
    
    changeType.width = size.width;
    changeType.x = MTScreenW - size.width - 10;
    [footview addSubview:changeType];
    
    self.tableView.tableFooterView = footview;
}

-(void)changeType
{
    //    AddMemberViewController1 *vc = [[AddMemberViewController1 alloc] init];
    //    vc.backHandlerClick =  self.backHandlerClick;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    BasicInfoViewController *vc = [[BasicInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  发送短信
 */
-(void)sendMsg
{
    [self.view endEditing:YES];
    if (self.telfield.rightText.text.length != 11)
        [NoticeHelper AlertShow:@"请输入正确的手机号码" view:self.view];
    else
    {
        [[MTSMSHelper sharedInstance] getCheckcode:self.telfield.rightText.text];
        [MTSMSHelper sharedInstance].sureSendSMS = ^{
            [NoticeHelper AlertShow:@"验证码发送成功,请查收！" view:self.view];
            [self countdownHandler];
        };    }
}

-(void)countdownHandler
{
    timesec = 60.0f;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer
{
    if (timesec == 1) {
        [theTimer invalidate];
        timesec = 60;
        [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCodeBtn setEnabled:YES];
    }else
    {
        timesec--;
        NSString *title = [NSString stringWithFormat:@"%.f秒后重发",timesec];
        [getCodeBtn setEnabled:NO];
        [getCodeBtn setTitle:title forState:UIControlStateDisabled];
    }
}


# pragma  mark

/**
 *  确认绑定
 *
 *  @param sender <#sender description#>
 */
-(void)sureHandler:(id)sender
{
    [self.view endEditing:YES];
    if (self.numfield.rightText.text.length == 0)
    {
        [NoticeHelper AlertShow:@"请输入家属昵称" view:self.view];
        return;
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Bang_relation parameters: @{@"mobile" : self.telfield.rightText.text,
                                                                      @"member_id":[SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                      @"rname" : self.numfield.rightText.text,
                                                                      @"client":@"ios",
                                                                      @"key":[SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"绑定成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                         [SharedAppUtil defaultCommonUtil].needRefleshMonitor = YES;
                                         if(self.backHandlerClick)
                                             self.backHandlerClick();
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
    
}
@end
