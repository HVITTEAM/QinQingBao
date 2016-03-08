//
//  DiseaseDetailViewController.m
//  QinQingBao
//
//  Created by shi on 16/1/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//
#define kMarginToSupper 25

#import "InfoDetailViewController.h"
#import "InfoDetailCell.h"
#import "SectionHeaderView.h"
#import "SectionHeaderView.h"

@interface InfoDetailViewController ()

@end

@implementation InfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navTitle;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark -- 协议方法 --
#pragma mark tableView dataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoDetailCell *cell = [[InfoDetailCell alloc] initInfoDetailWithTableView:tableView indexpath:indexPath];
    cell.contentStr = self.detail;
    return cell;
}

#pragma mark tableView delegate

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static InfoDetailCell *cell = nil;
    if (!cell) {
        cell = [[InfoDetailCell alloc] initInfoDetailWithTableView:tableView indexpath:indexPath];
    }
    
    return [cell getCellHeightWithContent:self.detail tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{    
    SectionHeaderView *headView = [SectionHeaderView createSectionHeaderWithSectionName:self.headTitle
                                                            iconName:self.headIconName];

    return headView;
}


@end
