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
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //设置表视图属性
        self.tableView.backgroundColor = HMGlobalBg;
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //去掉多余的分割线
        self.tableView.tableFooterView = [[UIView alloc] init];
        //导航栏标题
        self.navigationItem.title = @"王大爷";
    }
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0 ||section==2)
        return 1;
    else
        return 5;
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
        return cell;
    }
    else if (indexPath.section == 1) {
        BloodCell *cell = [tableView dequeueReusableCellWithIdentifier:celldata];
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"BloodCell" owner:nil options:nil] lastObject];
        }
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
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
