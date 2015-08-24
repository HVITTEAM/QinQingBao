//
//  HealthPageViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/13.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//  个人健康监测信息

#import "HealthPageViewController.h"
#import "HealthBloodPressureViewController.h"

@interface HealthPageViewController ()

@end

@implementation HealthPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HeartCell" owner:nil options:nil];
        cell = [nibs lastObject];
        // 设置背景view
        cell.backgroundColor = [UIColor clearColor];
        //        cell.selectedBackgroundView = [[UIImageView alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthBloodPressureViewController *bloodPressureVC = [[HealthBloodPressureViewController alloc] initWithNibName:@"HealthBloodPressureViewController" bundle:nil];
    [self.navigationController pushViewController:bloodPressureVC animated:YES];
}

@end
