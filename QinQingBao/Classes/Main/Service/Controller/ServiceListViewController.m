//
//  ServiceListViewController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceListViewController.h"

@interface ServiceListViewController ()

@end

@implementation ServiceListViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setDataProvider:(NSMutableArray *)dataProvider
{
    _dataProvider = dataProvider;
    if (_dataProvider.count == 0)
        [NoticeHelper AlertShow:@"暂无数据" view:self.view];
    [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataProvider.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ListViewCellId = @"ListViewCellId";
    ServiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ServiceListCell" owner:nil options:nil];
        cell = [nibs lastObject];
        // 设置背景view
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    [cell setitemWithData:self.dataProvider[indexPath.row]];
    return  cell;
}

/**
 点击菜单切换视图
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController *palceView = [[OrderDetailViewController alloc] init];
    [self.navigationController pushViewController:palceView animated:YES];
}

# pragma  mark 返回上一界面

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
