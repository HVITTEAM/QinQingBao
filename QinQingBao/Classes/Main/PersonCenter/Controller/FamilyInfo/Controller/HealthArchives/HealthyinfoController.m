//
//  HealthyinfoController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/29.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "HealthyinfoController.h"
#import "HealthyDetailController.h"


@interface HealthyinfoController ()

@end

@implementation HealthyinfoController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGroups];
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
    for (HealthyinfoModel *item in self.dataProvider)
    {
        HMCommonGroup *group = [HMCommonGroup group];
        HMCommonArrowItem *item0 = [HMCommonArrowItem itemWithTitle:item.healthyreport icon:nil];
        item0.operation = ^()
        {
            HealthyDetailController *VC = [[HealthyDetailController alloc] init];
            VC.healthyVO = item;
            [self.nav pushViewController:VC animated:YES];
        };
        group.items = @[item0];
        [self.groups addObject:group];
    }
}

@end
