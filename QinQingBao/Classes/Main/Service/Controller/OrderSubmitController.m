//
//  OrderSubmitController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderSubmitController.h"

@interface OrderSubmitController ()

@end

@implementation OrderSubmitController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
}

-(void)sendMsg
{
    
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"提交订单";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *listViewCellId = @"cell";
    NSString *content = @"contentCell";
    NSString *submit = @"submitcell";
    
    UITableViewCell *contentcell = [tableView dequeueReusableCellWithIdentifier:content];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listViewCellId];
    OrderSubmitCell *submitcell = [tableView dequeueReusableCellWithIdentifier:submit];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listViewCellId];
            cell.textLabel.text = @"服务对象";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return  cell;
    }
    else  if (indexPath.section == 1 && indexPath.row == 0)
    {
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listViewCellId];
            cell.textLabel.text = @"预约时间";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return  cell;
    }
    else  if (indexPath.section == 2 && indexPath.row == 0)
    {
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listViewCellId];
            cell.textLabel.text = @"抵用券";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return  cell;
    }
    else  if (indexPath.section == 3 && indexPath.row == 0)
    {
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listViewCellId];
            cell.textLabel.text = @"订单总价";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        }
        return  cell;
    }
    else  if (indexPath.section == 4 && indexPath.row == 0)
    {
        if (submitcell == nil)
        {
            //提交订单
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"OrderSubmitCell" owner:self options:nil];
            submitcell = [nib lastObject];
            submitcell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak OrderSubmitController *weakself  = self;
            submitcell.payClick = ^(UIButton *button){
                [weakself payClickHandler];
            };
        }
        return  submitcell;
    }
    else
    {
        if (contentcell == nil)
        {
            contentcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:content];
            contentcell.textLabel.text = @"张三";
            contentcell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        }
        return contentcell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 4 && indexPath.row == 0) {
    //        if (!self.payView)
    //            self.payView = [[PayViewController alloc] init];
    //        [self.navigationController pushViewController:self.payView animated:YES];
    //    }
}

-(void)payClickHandler
{
    if (!self.payView)
        self.payView = [[PayViewController alloc] init];
    [self.navigationController pushViewController:self.payView animated:YES];
}
@end
