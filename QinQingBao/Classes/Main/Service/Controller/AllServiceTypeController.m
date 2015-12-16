//
//  AllServiceTypeController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/26.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AllServiceTypeController.h"
#import "ServiceTypeModel.h"
#import "ServiceListViewController.h"

@interface AllServiceTypeController ()
{
}

@end

@implementation AllServiceTypeController

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
    self.title = @"更多服务";
    self.view.backgroundColor = HMGlobalBg;
    
    self.tableView.contentInset = UIEdgeInsetsMake(- 35, 0, 0, 0);
    
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
    
    NSMutableArray *itemArr = [[NSMutableArray alloc] init];
    for (ServiceTypeModel *data in self.dataProvider)
    {
        HMCommonArrowItem *item = [HMCommonArrowItem itemWithTitle:data.tname icon:@""];
        item.operation = ^{
            {
                ServiceListViewController *listView = [[ServiceListViewController alloc] init];
                listView.item = data;
                [self.navigationController pushViewController:listView animated:YES];
            }
        };
        [itemArr addObject:item];
    }
    group.items = [itemArr copy];
}


@end
