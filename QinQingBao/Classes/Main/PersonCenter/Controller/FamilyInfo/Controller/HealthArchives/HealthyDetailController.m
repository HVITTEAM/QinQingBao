//
//  HealthyDetailController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/29.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "HealthyDetailController.h"

@interface HealthyDetailController ()

@end

@implementation HealthyDetailController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@健康报告",self.healthyVO.healthyreport];
}

-(void)setHealthyVO:(HealthyinfoModel *)healthyVO
{
    _healthyVO = healthyVO;
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
    HMCommonGroup *group = [HMCommonGroup group];
    HMCommonItem *item0 = [HMCommonItem itemWithTitle:@"健康报告" icon:nil];
    item0.subtitle = self.healthyVO.healthyreport;
    HMCommonItem *item1 = [HMCommonItem itemWithTitle:@"检查时间" icon:nil];
    item1.subtitle = self.healthyVO.htime;
    HMCommonItem *item2 = [HMCommonItem itemWithTitle:@"餐后血糖" icon:nil];
    item2.subtitle = [NSString stringWithFormat:@"%@mmol/L",self.healthyVO.chxt];
    HMCommonItem *item3 = [HMCommonItem itemWithTitle:@"空腹血糖" icon:nil];
    item3.subtitle = [NSString stringWithFormat:@"%@mmol/L",self.healthyVO.kfxt];
    HMCommonItem *item4 = [HMCommonItem itemWithTitle:@"总胆固醇" icon:nil];
    item4.subtitle = [NSString stringWithFormat:@"%@mmol/L",self.healthyVO.zdgc];
    HMCommonItem *item5 = [HMCommonItem itemWithTitle:@"高密度胆固醇" icon:nil];
    item5.subtitle = [NSString stringWithFormat:@"%@mmol/L",self.healthyVO.gmddgc];
    HMCommonItem *item6 = [HMCommonItem itemWithTitle:@"低密度胆固醇" icon:nil];
    item6.subtitle = [NSString stringWithFormat:@"%@mmol/L",self.healthyVO.dmddgc];
    HMCommonItem *item7 = [HMCommonItem itemWithTitle:@"血清肌酐" icon:nil];
    item7.subtitle = [NSString stringWithFormat:@"%@mmol/L",self.healthyVO.xqjq];
    HMCommonItem *item8 = [HMCommonItem itemWithTitle:@"微量尿白蛋白" icon:nil];
    item8.subtitle = [NSString stringWithFormat:@"%@mmol/L",self.healthyVO.wlnbdb];
    group.items = @[item0,item1,item2,item3,item4,item5,item6,item7,item8];
    [self.groups addObject:group];
}

@end
