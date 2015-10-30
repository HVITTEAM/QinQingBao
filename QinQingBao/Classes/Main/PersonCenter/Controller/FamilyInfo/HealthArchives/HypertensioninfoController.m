//
//  HypertensioninfoController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/29.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "HypertensioninfoController.h"
#import "MedicineinfoModel.h"

@interface HypertensioninfoController ()

@end

@implementation HypertensioninfoController

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
    
    self.tableView.sectionFooterHeight = 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(section == 0 )
//        return nil;
//    UILabel *lab = [[UILabel alloc] init];
//    lab.text = @"当前用药情况";
//    lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
//    lab.textColor = [UIColor grayColor];
//    lab.frame = CGRectMake(30, 10, 100, 23);
//    return lab;
//}
//
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if(section == 0 )
//        return 0;
//    return 40;
//}
- (void)setupGroup0
{
    HMCommonGroup *group = [HMCommonGroup group];
    HMCommonItem *item0 = [HMCommonItem itemWithTitle:@"患高血压日期" icon:nil];
    item0.subtitle = self.hyoertensionVO.hydate;
    HMCommonItem *item1 = [HMCommonItem itemWithTitle:@"是否用药" icon:nil];
    item1.subtitle = [self.hyoertensionVO.have_medicate isEqualToString:@"0"] ? @"否" : @"有";
    HMCommonItem *item2 = [HMCommonItem itemWithTitle:@"疗效及副作用" icon:nil];
    item2.subtitle = self.hyoertensionVO.side_effect;
    HMCommonItem *item3 = [HMCommonItem itemWithTitle:@"最高收缩压" icon:nil];
    item3.subtitle = self.hyoertensionVO.systolic_blood_pressure;
    HMCommonItem *item4 = [HMCommonItem itemWithTitle:@"最高舒张压" icon:nil];
    item4.subtitle = self.hyoertensionVO.diastolic;
    HMCommonItem *item5 = [HMCommonItem itemWithTitle:@"高血压等级" icon:nil];
    item5.subtitle = self.hyoertensionVO.hypertension_rating;
    HMCommonItem *item6 = [HMCommonItem itemWithTitle:@"风险等级" icon:nil];
    item6.subtitle = self.hyoertensionVO.risk_Level;
    group.items = @[item0,item1,item2,item3,item4,item5,item6];
    [self.groups addObject:group];
    
    for (MedicineinfoModel *item in self.hyoertensionVO.medicineinfo)
    {
        HMCommonGroup *group = [HMCommonGroup group];
        group.header = @"当前用药情况";
        HMCommonItem *item0 = [HMCommonItem itemWithTitle:@"药物名称" icon:nil];
        item0.subtitle = item.medname;
        HMCommonItem *item1 = [HMCommonItem itemWithTitle:@"剂量" icon:nil];
        item1.subtitle = item.dose;
        HMCommonItem *item2 = [HMCommonItem itemWithTitle:@"用药时间" icon:nil];
        item2.subtitle = item.date;
        group.items = @[item0,item1,item2];
        [self.groups addObject:group];
    }
}


@end
