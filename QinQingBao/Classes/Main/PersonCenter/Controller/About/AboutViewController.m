//
//  AboutViewController.m
//  GPSNavDemo
//
//  Created by 董徐维 on 15/4/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutusViewController.h"
#import "FeedbackViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initView];
    
    [self setupFooter];
    
    [self setupGroups];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"关于APP";
    self.view.backgroundColor = HMGlobalBg;
}

-(void)initView
{
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    logo.frame = CGRectMake(self.view.width/2 - 55, 40, 110, 60);
    
    UIImageView *advlogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"advlogo.png"]];
    advlogo.frame = CGRectMake(self.view.width/2 - 60, CGRectGetMaxY(logo.frame) + 5, 120, 15);

    UIView *view = [[UIView alloc] init];
    view.height = 160;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = kAppVersion;
    lab.textColor = MTNavgationBackgroundColor;
    lab.font = [UIFont fontWithName:@"Helvetica" size:13];
    CGSize size = [lab.text sizeWithAttributes:@{NSFontAttributeName:lab.font}];
    lab.width = size.width;
    lab.height = size.height;
    lab.x = advlogo.x + advlogo.width/2 - lab.width/2;
    lab.y = CGRectGetMaxY(advlogo.frame) + 10;
    [view addSubview:lab];
    [view addSubview:advlogo];
    [view addSubview:logo];

    
    self.tableView.tableHeaderView = view;
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    //每次刷新数据源的时候需要将数据源清空
    [self.groups removeAllObjects];
    
    //重置数据源
    [self setupGroup0];
    
    //刷新表格
    [self.tableView reloadData];
}

- (void)setupFooter
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - 100, MTScreenW, 50)];
    
    UILabel *lab = [[UILabel alloc] init];
    
    lab.text = @"服务热线: 400-151-2626";
    lab.font = [UIFont fontWithName:@"Helvetica" size:12];

    lab.textColor = MTNavgationBackgroundColor;
    CGSize size = [lab.text sizeWithAttributes:@{NSFontAttributeName:lab.font}];
    lab.width = size.width;
    lab.height = size.height;
    lab.x = self.view.width/2 - lab.width/2;
    lab.y = 0;
    [view addSubview:lab];
    
    UILabel *lab0 = [[UILabel alloc] init];
    lab0.text = @"浙江海予信息技术有限公司版权所有";
    lab0.font = [UIFont fontWithName:@"Helvetica" size:12];
    lab0.textColor = MTNavgationBackgroundColor;
    CGSize size0 = [lab0.text sizeWithAttributes:@{NSFontAttributeName:lab0.font}];
    lab0.width = size0.width;
    lab0.height = size0.height;
    lab0.x = self.view.width/2 - lab0.width/2;
    lab0.y = CGRectGetMaxY(lab.frame) + 10;
    [view addSubview:lab0];
    
    [self.tableView addSubview:view];
}

- (void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    HMCommonItem*version = [HMCommonItem itemWithTitle:@"当前版本" icon:@"ic_version_update.png"];
    version.subtitle = kAppVersion;
    
    HMCommonArrowItem *help = [HMCommonArrowItem itemWithTitle:@"关于我们" icon:@"ic_use_help.png"];
    help.destVcClass = [AboutusViewController class];
    
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"意见反馈" icon:@"ic_feedback.png"];
    advice.destVcClass = [FeedbackViewController class];
    
    group.items = @[help];
}

@end
