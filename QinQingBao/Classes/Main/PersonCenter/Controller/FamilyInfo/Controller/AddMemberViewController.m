//
//  AddMemberViewController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "AddMemberViewController.h"

#import "BasicInfoViewController.h"
#import "AddDeviceViewController.h"

#import "ScanCodesViewController.h"

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
    self.title = @"添加亲友";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
    
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
    telfield.placeholder = @"设备的SIM卡号/IMEI码";
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
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenH, 140)];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((MTScreenW - 230)/2, -10, 230, 30)];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"infoimg.png"]];
    img.frame = CGRectMake(lab.x - 20, -5, 20, 20);
    lab.userInteractionEnabled = NO;
    lab.font = [UIFont systemFontOfSize:12];
    lab.text = @"可扫描设备条形码/二维码获取设备识别码";
    lab.textColor = HMColor(234, 100, 65);
    lab.textAlignment = NSTextAlignmentCenter;
    [footview addSubview:lab];
    [footview addSubview:img];
    
    // 1.创建按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame), MTScreenW, 50)];
    
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
    [changeType setTitle:@"新购买的设备？请先登记" forState:UIControlStateNormal];
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
    AddDeviceViewController *view = [[AddDeviceViewController alloc] init];
    view.isFromStart = YES;
    [self.navigationController pushViewController:view animated:YES];
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
        [NoticeHelper AlertShow:@"请输入家属昵称,必填" view:self.view];
        return;
    }
    else if (self.telfield.rightText.text.length == 0)
    {
        [NoticeHelper AlertShow:@"请输入设备识别码,必填" view:self.view];
        return;
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_bang_add_cnditon_user_device_rel_code parameters: @{@"conditon":self.telfield.rightText.text,
                                                                                              @"rel_name" : self.numfield.rightText.text,
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

//扫描条形码
-(void)scan
{
    ScanCodesViewController *scanCodeVC = [[ScanCodesViewController alloc] init];
    scanCodeVC.getcodeClick = ^(NSString *code){
        self.telfield.rightText.text = code;
    };
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}
@end
