//
//  AddMemberViewController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "AddMemberViewController.h"

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
    HMCommonButtonItem *numfield = [HMCommonButtonItem itemWithTitle:@"确认客户号" icon:nil];
    numfield.placeholder = @"请输入9位个人客户号";
    self.numfield = numfield;
    
    numfield.buttonClickBlock = ^(UIButton *btn){
        NSLog(@"----点击了确认按钮-");
        self.telfield.rightText.text = @"15261212811";
        self.telfield.rightText.clearButtonMode =  UITextFieldViewModeNever;
    };
    
    numfield.operation = ^{
        NSLog(@"----点击了n---%@",self.numfield.rightText.text);
    };
    
    HMCommonTextfieldItem *telfield = [HMCommonTextfieldItem itemWithTitle:@"手机号码" icon:nil];
    telfield.placeholder = @"紧急联系人电话号码";
    self.telfield = telfield;
    self.telfield.rightText.userInteractionEnabled = NO;
    telfield.operation = ^{
        NSLog(@"----点击了n---");
    };
    
    // 2.设置组的所有行数据
    HMCommonButtonItem *codefield = [HMCommonButtonItem itemWithTitle:@"获取验证码" icon:nil];
    codefield.placeholder = @"请输入验证码";
    self.codefield = codefield;
    
    codefield.buttonClickBlock = ^(UIButton *btn){
        NSLog(@"----点击了获取验证码按钮-");
        getCodeBtn = btn;
        [self sendMsg];
    };
    
    group.items = @[numfield,telfield,codefield];
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

# pragma  mark

-(void)sureHandler:(id)sender
{
    
}

-(void)sendMsg
{
    if (self.telfield.rightText.text.length != 11)
        [NoticeHelper AlertShow:@"请输入正确的手机号码" view:self.view];
    else
        [self countdownHandler];
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
@end
