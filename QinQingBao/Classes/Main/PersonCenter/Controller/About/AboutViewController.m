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
    UILabel *lab0 = [[UILabel alloc] init];
    
    // 设置富文本的时候，先设置的先显示，后设置的，如果与先设置的样式不一致，是不会覆盖的，富文本设置的效果具有先后顺序，大家要注意
    
    NSString *string                            = @"寸欣健康";
    
    lab0.text = string;
    lab0.font = [UIFont fontWithName:@"Helvetica-Bold" size:45];
    lab0.textColor = MTNavgationBackgroundColor;
    lab0.textAlignment = NSTextAlignmentCenter;
    CGSize size0 = [lab0.text sizeWithAttributes:@{NSFontAttributeName:lab0.font}];
    lab0.width = self.view.width;
    lab0.height = size0.height;
    lab0.x = self.view.width/2 - lab0.width/2;
    lab0.y = self.navigationController.navigationBar.height;
    
    UIView *view = [[UIView alloc] init];
    view.height = 150;
    
    UILabel *lab = [[UILabel alloc] init];
    
    NSString *string1                            = @"智慧养老服务中心(v1.2.1.7)";

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string1];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor orangeColor]
                             range:NSMakeRange(0, 8)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor lightGrayColor]
                             range:NSMakeRange(8, string1.length - 8)];
   
    
    lab.attributedText = attributedString;
    lab.font = [UIFont fontWithName:@"Helvetica" size:13];
//    lab.textColor = [UIColor orangeColor];
    CGSize size = [lab.text sizeWithAttributes:@{NSFontAttributeName:lab.font}];
    lab.width = size.width;
    lab.height = size.height;
    lab.x = lab0.x + lab0.width/2 - lab.width/2;
    lab.y = CGRectGetMaxY(lab0.frame) + 10;
    [view addSubview:lab];
    [view addSubview:lab0];
    
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
    
    // 设置富文本的时候，先设置的先显示，后设置的，如果与先设置的样式不一致，是不会覆盖的，富文本设置的效果具有先后顺序，大家要注意
    
    NSString *string                            = @"服务热线: 4001512626";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor grayColor]
                             range:NSMakeRange(0, 5)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"Helvetica" size:13]
                             range:NSMakeRange(0, string.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(6, string.length - 6)];
    
    
    
    lab.attributedText = attributedString;
    CGSize size = [lab.text sizeWithAttributes:@{NSFontAttributeName:lab.font}];
    lab.width = size.width;
    lab.height = size.height;
    lab.x = self.view.width/2 - lab.width/2;
    lab.y = 0;
    [view addSubview:lab];
    
    UILabel *lab0 = [[UILabel alloc] init];
    lab0.text = @"注册、登录、绑定等问题，欢迎致电咨询";
    lab0.font = [UIFont fontWithName:@"Helvetica" size:13];
    lab0.textColor = [UIColor grayColor];
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
    version.subtitle = @"v1.1.1.5";
    
    HMCommonArrowItem *help = [HMCommonArrowItem itemWithTitle:@"关于我们" icon:@"ic_use_help.png"];
    help.destVcClass = [AboutusViewController class];
    
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"意见反馈" icon:@"ic_feedback.png"];
    advice.destVcClass = [FeedbackViewController class];
    
    group.items = @[help,advice];
}

@end
