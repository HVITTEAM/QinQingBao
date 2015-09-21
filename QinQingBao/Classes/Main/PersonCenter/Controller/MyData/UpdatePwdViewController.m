//
//  UpdatePwdViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "UpdatePwdViewController.h"

@interface UpdatePwdViewController ()

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
    HMCommonTextfieldItem *oldpwd = [HMCommonTextfieldItem itemWithTitle:@"旧的密码" icon:nil];
    oldpwd.secureTextEntry = YES;
    oldpwd.placeholder = @"请输入旧密码";
    self.oldPwd = oldpwd;
    
    HMCommonTextfieldItem *nowpwd = [HMCommonTextfieldItem itemWithTitle:@"新的密码" icon:nil];
    nowpwd.secureTextEntry = YES;
    nowpwd.placeholder = @"请输入新密码";
    self.nowPwd = nowpwd;
    
    HMCommonTextfieldItem *confirmpwd = [HMCommonTextfieldItem itemWithTitle:@"确认密码" icon:nil];
    confirmpwd.placeholder = @"请再输入一次新密码";
    oldpwd.secureTextEntry = YES;
    self.confirmPwd = confirmpwd;
    
    group.items = @[oldpwd,nowpwd,confirmpwd];
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
    
}

@end
