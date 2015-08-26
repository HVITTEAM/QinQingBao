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
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"default_common_navibar_prev_normal.png"
//                                                                 highImageName:@"default_common_navibar_prev_highlighted.png"
//                                                                        target:self action:@selector(back)];
    
    //去掉下一级页面返回按钮上的文本
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:12/255.0 green:167/255.0 blue:161/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
}

/**
 点击菜单切换视图
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.palceView ==  nil)
        self.palceView = [[PlaceOrderController alloc] init];
    [self.navigationController pushViewController:self.palceView animated:YES];
}

# pragma  mark 返回上一界面

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
