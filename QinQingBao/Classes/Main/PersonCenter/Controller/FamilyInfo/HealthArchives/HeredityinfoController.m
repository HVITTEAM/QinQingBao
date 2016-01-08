//
//  HeredityinfoController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/29.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "HeredityinfoController.h"

@interface HeredityinfoController ()

@end

@implementation HeredityinfoController

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
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonItem *item0 = [HMCommonItem itemWithTitle:@"高血压" icon:nil];
    item0.subtitle = [self.heredityVO.hypertension isEqualToString:@"1"] ? @"有" : @"无";
    HMCommonItem *item1 = [HMCommonItem itemWithTitle:@"高血脂" icon:nil];
    item1.subtitle = [self.heredityVO.hyperlipemiars isEqualToString:@"1"] ? @"有" : @"无";
    HMCommonItem *item2 = [HMCommonItem itemWithTitle:@"糖尿病" icon:nil];
    item2.subtitle = [self.heredityVO.diabetes isEqualToString:@"1"] ? @"有" : @"无";
    HMCommonItem *item3 = [HMCommonItem itemWithTitle:@"冠心病" icon:nil];
    item3.subtitle = [self.heredityVO.coronary isEqualToString:@"1"] ? @"有" : @"无";
    HMCommonItem *item4 = [HMCommonItem itemWithTitle:@"脑血管意外" icon:nil];
    item4.subtitle = [self.heredityVO.cerebrovascular isEqualToString:@"1"] ? @"有" : @"无";
    HMCommonItem *item7 = [HMCommonItem itemWithTitle:@"精神分裂症" icon:nil];
    item7.subtitle = [self.heredityVO.schizophrenia isEqualToString:@"1"] ? @"有" : @"无";
    group.items = @[item0,item1,item2,item3,item4,item7];
}

@end
