//
//  AboutViewController.m
//  GPSNavDemo
//
//  Created by 董徐维 on 15/4/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
//    [self initView];
    
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
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    img.x = (MTScreenW - img.width)/2;
    img.y = 25;

    UIView *view = [[UIView alloc] init];
    view.height = 150;
    [view addSubview:img];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"v1.0.0";
    lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    lab.textColor = [UIColor grayColor];
    CGSize size = [lab.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lab.width = size.width;
    lab.height = size.height;
    lab.x = img.x + img.width/2 - lab.width/2;
    lab.y = CGRectGetMaxY(img.frame);
    [view addSubview:lab];
    
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
    // 1.创建按钮
    UIButton *logout = [[UIButton alloc] init];
    
    // 2.设置属性
    logout.titleLabel.font = [UIFont systemFontOfSize:16];
    [logout setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [logout setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    //    [logout addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    logout.height = 50;
    
    self.tableView.tableFooterView = logout;
    
}
- (void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];

    // 设置组的所有行数据
    HMCommonArrowItem *version = [HMCommonArrowItem itemWithTitle:@"版本更新" icon:@"pc_accout.png"];
    // newFriend.destVcClass = [MyAccountViewController class];
    version.operation = ^{
    };
    
    HMCommonArrowItem *help = [HMCommonArrowItem itemWithTitle:@"使用帮助" icon:@"app.png"];
    
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"意见反馈" icon:@"app.png"];

    group.items = @[version,help,advice];
}



# pragma  mark 返回上一界面

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
