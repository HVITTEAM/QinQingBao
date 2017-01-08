//
//  Gene_DetectionViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/8.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import "Gene_DetectionViewController.h"
#import "RepotDetailCell.h"
#import "GeneDetectionCell.h"

@interface Gene_DetectionViewController ()

@end

@implementation Gene_DetectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
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
    return _modelData.entry_content.gene_detection.count + 1;
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
    return section == 0 ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    GeneDetectionCell *geneDetectionCell = [tableView dequeueReusableCellWithIdentifier:@"TargetDetailCell"];
    if(geneDetectionCell == nil)
        geneDetectionCell = [GeneDetectionCell geneDetectionCell];
    
    RepotDetailCell *repotDetailCell = [tableView dequeueReusableCellWithIdentifier:@"RepotDetailCell"];
    repotDetailCell = [RepotDetailCell repotDetailCell];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        repotDetailCell.textLabel.text = @"检测报告结论";
        repotDetailCell.textLabel.textColor = [UIColor blackColor];
        repotDetailCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell = repotDetailCell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        repotDetailCell.paragraphValue = self.modelData.check_conclusion;
        cell = repotDetailCell;
    }
    else
    {
        GenesModel *item = _modelData.entry_content.gene_detection[indexPath.section - 1];
        geneDetectionCell.dataItem = item;
        geneDetectionCell.paragraphValue = item.ycjd_detail;
        cell = geneDetectionCell;
    }
    
    //设置cell的边框
    if (indexPath.row == 0)
    {
        repotDetailCell.borderType = MTCellBorderTypeTOP;
    }
    else if (indexPath.row ==  [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1)
    {
        repotDetailCell.borderType = MTCellBorderTypeBottom;
    }
    else
    {
        repotDetailCell.borderType = MTCellBorderTypeTOPNone;
    }
    
    return cell;
    
}
@end
