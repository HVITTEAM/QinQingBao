//
//  UnusualReportViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/6.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import "UnusualReportViewController.h"
#import "TargetDetailCell.h"

@interface UnusualReportViewController ()

@end

@implementation UnusualReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
}

-(void)setDataProvider:(NSArray<GenesModel *> *)dataProvider
{
    _dataProvider = dataProvider;
}

-(void)initTableView
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return  cell.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataProvider.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TargetDetailCell *targetDetailCell = [tableView dequeueReusableCellWithIdentifier:@"MTTargetDetailCell"];
    if(targetDetailCell == nil)
        targetDetailCell = [TargetDetailCell targetDetailCell];
    
    GenesModel *item = self.dataProvider[indexPath.section];
    targetDetailCell.dataItem = item;
    return targetDetailCell;
}

@end
