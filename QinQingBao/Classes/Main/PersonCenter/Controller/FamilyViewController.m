//
//  FamilyViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "FamilyViewController.h"

@interface FamilyViewController ()

@end

@implementation FamilyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self setupGroups];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"我的家属";
    self.view.backgroundColor = HMGlobalBg;
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
    
//    [self setPlaceHolderview];
    
    //刷新表格
    [self.tableView reloadData];
}


-(void)setPlaceHolderview
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.view.width - 100)/2, (self.view.height - 100)/3, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

- (void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    HMCommonArrowItem *version = [HMCommonArrowItem itemWithTitle:@"老张" icon:@"pc_accout.png"];
    // newFriend.destVcClass = [MyAccountViewController class];
    version.operation = ^{
    };
    
    HMCommonArrowItem *help = [HMCommonArrowItem itemWithTitle:@"老王" icon:@"app.png"];
    
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"二大爷" icon:@"app.png"];
    
    group.items = @[version,help,advice];
}


@end
