//
//  DetailInfoViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/15.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "DetailInfoViewController.h"

@interface DetailInfoViewController ()
{
    NSMutableArray *dataProvider;
}

@end

@implementation DetailInfoViewController

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
    self.title = @"家属基本信息";
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
    
    //刷新表格
    [self.tableView reloadData];
}


- (void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 设置组的所有行数据
    HMCommonItem *item0 = [HMCommonItem itemWithTitle:@"姓名" icon:@""];
    item0.subtitle = self.itemInfo.member_truename;
    
    HMCommonItem *item1 = [HMCommonItem itemWithTitle:@"年龄" icon:@""];
    NSString *str = [NoticeHelper intervalSinceNowByyear:self.itemInfo.member_birthday];
    item1.subtitle = str;
    
    HMCommonItem *item2 = [HMCommonItem itemWithTitle:@"联系电话" icon:@""];
    item2.subtitle = self.itemInfo.member_mobile;
    
    HMCommonItem *item3 = [HMCommonItem itemWithTitle:@"常住地址" icon:@""];
    item3.subtitle = [NSString stringWithFormat:@"%@%@",self.itemInfo.totalname,self.itemInfo.member_areainfo];
    
    group.items = @[item0,item1,item2,item3];
}


@end
