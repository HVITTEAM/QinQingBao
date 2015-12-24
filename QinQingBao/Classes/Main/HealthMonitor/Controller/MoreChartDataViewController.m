//
//  MoreChartDataViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/21.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "MoreChartDataViewController.h"
#import "BloodCell.h"

@interface MoreChartDataViewController ()

@end

@implementation MoreChartDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.title = @"更多数据";
    //设置表视图属性
    self.tableView.backgroundColor = HMGlobalBg;
}

-(void)setDataProvider:(NSMutableArray *)dataProvider
{
    _dataProvider = dataProvider;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataProvider.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *celldata = @"celldata";
    BloodCell *cell = [tableView dequeueReusableCellWithIdentifier:celldata];
    if (!cell)
        cell= [[[NSBundle mainBundle]loadNibNamed:@"BloodCell" owner:nil options:nil] lastObject];
    cell.type = ChartTypeHeart;
    [cell setItem:self.dataProvider[indexPath.row]];
    return cell;
}


@end
