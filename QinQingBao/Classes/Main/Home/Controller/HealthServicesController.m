//
//  HealthServicesController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/10.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HealthServicesController.h"

@interface HealthServicesController ()

@end

@implementation HealthServicesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"健康服务";
    
    [self initTableviewSkin];
}


/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *listViewCellstr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listViewCellstr];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listViewCellstr];
        cell.textLabel.text = @"症状自查";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.checkVC)
        self.checkVC = [[CheckSelfViewController alloc] init];
    [self.navigationController pushViewController: self.checkVC animated:YES];

}


@end
