//
//  HealthBloodPressureViewController.m
//  QinQingBao
//
//  Created by shi on 15/8/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HealthBloodPressureViewController.h"
#import "BloodCell.h"
#import "ChartCell.h"
#import "PromptCell.h"
#import "HealthTipCell.h"

@interface HealthBloodPressureViewController ()

@end

@implementation HealthBloodPressureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/** 屏蔽tableView的样式 */
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    //设置表视图属性
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
}

-(void)setDataProvider:(NSMutableArray *)dataProvider
{
    _dataProvider = dataProvider;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0 ||section==2)
        return 1;
    else
        return self.dataProvider.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellchart = @"cellchart";
    static NSString *cellstring = @"cellstring";
    static NSString *celldata = @"celldata";
    //分区为0时返回表格Cell
    if (indexPath.section == 0) {
        ChartCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellchart];
        if (!cell) {
            cell = [[ChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellchart];
        }
        cell.type = self.type;
        [cell setDataProvider:self.dataProvider];
        return cell;
    }
    else if (indexPath.section == 1) {
        BloodCell *cell = [tableView dequeueReusableCellWithIdentifier:celldata];
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"BloodCell" owner:nil options:nil] lastObject];
        }
        cell.type = self.type;
        [cell setItem:self.dataProvider[indexPath.row]];
        return cell;
    }
    else
    {
        HealthTipCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"HealthTipCell" owner:nil options:nil] lastObject];
        }
        return cell;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 ) {
        return 180.0f;
    }else if (indexPath.section ==1){
        return 40.0f;
    }else if(indexPath.section ==2){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    return 0;
}
@end
