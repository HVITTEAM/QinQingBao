//
//  HealthBloodPressureViewController.m
//  QinQingBao
//
//  Created by shi on 15/8/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HealthBloodPressureViewController.h"
#import "MoreChartDataViewController.h"
#import "BloodCell.h"
#import "ChartCell.h"
#import "PromptCell.h"
#import "HealthTipCell.h"

@interface HealthBloodPressureViewController ()

@end

@implementation HealthBloodPressureViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/** 屏蔽tableView的样式 */
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    //设置表视图属性
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)setDataProvider:(NSMutableArray *)dataProvider
{
    _dataProvider = dataProvider;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0 ||section==2)
        return 1;
    else
        return self.dataProvider.count > 5 ? 6 : self.dataProvider.count + 1;
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
        cell.type = self.type;
        [cell setDataProvider:self.dataProvider];
        return cell;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0 )
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
            commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            commoncell.textLabel.font = [UIFont systemFontOfSize:14];
            commoncell.textLabel.textColor = [UIColor orangeColor];
            commoncell.textLabel.text = @"更多数据";
            return commoncell;
        }
        else
        {
            BloodCell *cell = [tableView dequeueReusableCellWithIdentifier:celldata];
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"BloodCell" owner:nil options:nil] lastObject];
            }
            cell.type = self.type;
            [cell setItem:self.dataProvider[indexPath.row - 1]];
            return cell;
        }
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        MoreChartDataViewController *moreData = [[MoreChartDataViewController alloc] init];
        if ([self.title rangeOfString:@"心率"].location != NSNotFound)
        {
            moreData.type = ChartTypeHeart;
        }
        else if ([self.title rangeOfString:@"血压"].location != NSNotFound)
        {
            moreData.type = ChartTypeBlood;
        }
        moreData.dataProvider = self.dataProvider;
        [self.navigationController pushViewController:moreData animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
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
