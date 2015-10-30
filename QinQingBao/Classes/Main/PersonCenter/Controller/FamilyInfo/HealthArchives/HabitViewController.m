//
//  HabitViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/10/28.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "HabitViewController.h"

@interface HabitViewController ()

@end

@implementation HabitViewController

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
    
    /**血型 血型     0 O型、       1 A型、        2 B型、     3 AB型、   4 RH型；**/
    /**吸烟年限 0不吸 1 一年 2 两年 3 三年 4 三年以上 **/
    /**吸烟频次 0不吸 1经常 2偶尔 3少许**/
    /**饮酒频次 0不饮 1 经常 2偶然 3少许**/
    /**饮酒类型 0不饮 1 红酒 2白酒 3 黄酒**/
    /**运动时长 0不运动 1经常 2偶尔 3少许 **/
    /**运动频次 0不运动 1经常 2偶尔 3少许**/
    /**睡眠质量 0不好 1好 2一般 **/
    /**睡眠时长 **/
    
    HMCommonItem *item0 = [HMCommonItem itemWithTitle:@"血型" icon:nil];
    item0.subtitle = [self getBlood:self.habitVO.blood];
    HMCommonItem *item1 = [HMCommonItem itemWithTitle:@"吸烟年限" icon:nil];
    item1.subtitle = [self getSmokeyears:self.habitVO.smokeyears];
    HMCommonItem *item2 = [HMCommonItem itemWithTitle:@"吸烟频次" icon:nil];
    item2.subtitle = [self getSmokefrequency:self.habitVO.smokefrequency];
    HMCommonItem *item3 = [HMCommonItem itemWithTitle:@"饮酒频次" icon:nil];
    item3.subtitle = [self getDrinkfrequency:self.habitVO.drinkfrequency];
    HMCommonItem *item4 = [HMCommonItem itemWithTitle:@"饮酒类型" icon:nil];
    item4.subtitle = [self getDrinktype:self.habitVO.drinktype];
    HMCommonItem *item7 = [HMCommonItem itemWithTitle:@"运动时长" icon:nil];
    item7.subtitle = [self getSportduration:self.habitVO.sportduration];
    HMCommonItem *item8 = [HMCommonItem itemWithTitle:@"运动频次" icon:nil];
    item8.subtitle = [self getSportfrequency:self.habitVO.sportfrequency];
    HMCommonItem *item9 = [HMCommonItem itemWithTitle:@"睡眠质量" icon:nil];
    item9.subtitle = [self getSleepquality:self.habitVO.sleepquality];
    HMCommonItem *item10 = [HMCommonItem itemWithTitle:@"睡眠时长" icon:nil];
    item10.subtitle = [self.habitVO.sleepduration isEqualToString:@""] ? @"无" : [NSString stringWithFormat:@"%@小时",self.habitVO.sleepduration];
    group.items = @[item0,item1,item2,item3,item4,item7,item8,item9,item10];
}

-(NSString *)getBlood:(NSString *)value
{
    if ([value isEqualToString:@"0"])
        return @"O型";
    else if ([value isEqualToString:@"1"])
        return @"A型";
    else if ([value isEqualToString:@"2"])
        return @"B型";
    else if ([value isEqualToString:@"3"])
        return @"AB型";
    else if ([value isEqualToString:@"4"])
        return @"RH型";
    else
        return @"无";
}

-(NSString *)getSmokeyears:(NSString *)value
{
    if ([value isEqualToString:@"0"])
        return @"不吸";
    else if ([value isEqualToString:@"1"])
        return @"一年";
    else if ([value isEqualToString:@"2"])
        return @"两年";
    else if ([value isEqualToString:@"3"])
        return @"三年";
    else if ([value isEqualToString:@"4"])
        return @"四年以上";
    else
        return @"无";
}

-(NSString *)getSmokefrequency:(NSString *)value
{
    if ([value isEqualToString:@"0"])
        return @"不吸";
    else if ([value isEqualToString:@"1"])
        return @"经常";
    else if ([value isEqualToString:@"2"])
        return @"偶尔";
    else if ([value isEqualToString:@"3"])
        return @"少许";
    else
        return @"无";
}

-(NSString *)getDrinkfrequency:(NSString *)value
{
    if ([value isEqualToString:@"0"])
        return @"不饮";
    else if ([value isEqualToString:@"1"])
        return @"经常";
    else if ([value isEqualToString:@"2"])
        return @"偶尔";
    else if ([value isEqualToString:@"3"])
        return @"少许";
    else
        return @"无";
}

-(NSString *)getDrinktype:(NSString *)value
{
    if ([value isEqualToString:@"0"])
        return @"不饮";
    else if ([value isEqualToString:@"1"])
        return @"红酒";
    else if ([value isEqualToString:@"2"])
        return @"白酒";
    else if ([value isEqualToString:@"3"])
        return @"黄酒";
    else
        return @"无";
}

-(NSString *)getSportduration:(NSString *)value
{
    if ([value isEqualToString:@"0"])
        return @"不运动";
    else if ([value isEqualToString:@"1"])
        return @"经常";
    else if ([value isEqualToString:@"2"])
        return @"偶尔";
    else if ([value isEqualToString:@"3"])
        return @"少许";
    else
        return @"无";
}

-(NSString *)getSportfrequency:(NSString *)value
{
    if ([value isEqualToString:@"0"])
        return @"不运动";
    else if ([value isEqualToString:@"1"])
        return @"经常";
    else if ([value isEqualToString:@"2"])
        return @"偶尔";
    else if ([value isEqualToString:@"3"])
        return @"少许";
    else
        return @"无";
}

-(NSString *)getSleepquality:(NSString *)value
{
    if ([value isEqualToString:@"0"])
        return @"不好";
    else if ([value isEqualToString:@"1"])
        return @"好";
    else if ([value isEqualToString:@"2"])
        return @"一般";
    else
        return @"无";
}

@end
