//
//  OrderDetailViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initTableviewSkin];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"服务详情";
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ServiceHeadView" owner:nil options:nil];
    self.tableView.tableHeaderView = [nibs lastObject];
    self.tableView.tableHeaderView.backgroundColor = HMGlobalBg;
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 180;
    else if (indexPath.row == 1)
        return 160;
    else
        return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!self.headView)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PlaceOrderView" owner:self options:nil];
        self.headView = [nib lastObject];
        __weak OrderDetailViewController *weakself  = self;
        self.headView.submitClick = ^(UIButton *button){
            [weakself submitClickHandler];
        };
    }
    return self.headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    EvaluationCell *evacell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    BusinessInfoCell *bucell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    
    if (indexPath.row == 0)
    {
        if (evacell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"EvaluationCell" owner:self options:nil];
            evacell = [nib lastObject];
            evacell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return  evacell;
    }
    if (indexPath.row == 1)
    {
        if (bucell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"BusinessInfoCell" owner:self options:nil];
            bucell = [nib lastObject];
            bucell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return  bucell;
    }
    
    else
    {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
            cell.textLabel.text = @"test";
        }
        return  cell;
    }
}

/**
 *  下单
 */
-(void)submitClickHandler
{
    if(!self.submitController)
        self.submitController = [[OrderSubmitController alloc] init];
    [self.navigationController pushViewController:self.submitController animated:YES];
}


@end
