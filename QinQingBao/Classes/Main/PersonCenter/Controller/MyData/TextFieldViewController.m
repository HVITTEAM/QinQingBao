//
//  TextFieldViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "TextFieldViewController.h"
#import "HMCommonTextfieldItem.h"

@interface TextFieldViewController ()

@end

@implementation TextFieldViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.groups removeAllObjects];
    
    [self initNavigation];
    
    [self setupGroups];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
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
    self.title = [self.dict valueForKey:@"title"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClickHandler)];
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup];
}

- (void)setupGroup
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    HMCommonTextfieldItem *oldpwd = [HMCommonTextfieldItem itemWithTitle:[self.dict valueForKey:@"text"] icon:nil];
    oldpwd.placeholder = [self.dict valueForKey:@"placeholder"];
    group.items = @[oldpwd];
    
    [self.tableView reloadData];
}

-(void)doneClickHandler
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
