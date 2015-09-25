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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *listViewCellstr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listViewCellstr];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:listViewCellstr];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"1.png"];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }

    switch (indexPath.section)
    {
        case 0:
            cell.textLabel.text = @"症状自查";
            cell.detailTextLabel.text = @"帮你判断身体的不适";
            break;
        case 1:
            cell.textLabel.text = @"在线提问";
            cell.detailTextLabel.text = @"描述症状,快速解答";
            break;
        case 2:
            cell.textLabel.text = @"签约医生";
            cell.detailTextLabel.text = @"指定社区医生提供健康服务";
            break;
        default:
            break;
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
