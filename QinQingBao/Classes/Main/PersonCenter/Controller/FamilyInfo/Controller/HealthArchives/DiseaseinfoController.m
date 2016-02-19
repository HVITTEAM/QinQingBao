//
//  DiseaseinfoController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/29.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "DiseaseinfoController.h"

@interface DiseaseinfoController ()

@end

@implementation DiseaseinfoController
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
    for (DiseaseinfoModel *item in self.dataProvider)
    {
        HMCommonGroup *group = [HMCommonGroup group];
        HMCommonItem *item0 = [HMCommonItem itemWithTitle:@"疾病名称" icon:nil];
        item0.subtitle = item.diseasename;
        HMCommonItem *item1 = [HMCommonItem itemWithTitle:@"发送时间" icon:nil];
        item1.subtitle = item.begintime;
        HMCommonItem *item2 = [HMCommonItem itemWithTitle:@"结束时间" icon:nil];
        item2.subtitle = item.endtime;
        HMCommonItem *item3 = [HMCommonItem itemWithTitle:@"住院情况" icon:nil];
        item3.subtitle = item.hospitalization;
        HMCommonItem *item4 = [HMCommonItem itemWithTitle:@"转归情况" icon:nil];
        item4.subtitle = item.outcome;
        group.items = @[item0,item1,item2];
        [self.groups addObject:group];
    }
}
@end
