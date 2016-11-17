//
//  HealthArchiveListController.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HealthArchiveListController.h"
#import "ArchivesPersonCell.h"
#import "ScanCodesViewController.h"
#import "HealthArchiveViewController.h"
@interface HealthArchiveListController ()

@end

@implementation HealthArchiveListController


-(instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupFooter];
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title  = @"健康档案";
}

#pragma mark - 设置footer View

- (void)setupFooter
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 80)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, MTScreenW/2 - 30, 40)];
    [btn setTitle:@"扫描绑定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 4.0f;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 0.5f;
    [btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    
    UIButton *btn0 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + 20, 20, MTScreenW/2 - 30, 40)];
    [btn0 setTitle:@"+ 新建档案" forState:UIControlStateNormal];
    btn0.backgroundColor = HMColor(140, 185, 50);
    btn0.layer.cornerRadius = 4.0f;
    btn0.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn0 addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn0];
    
    self.tableView.tableFooterView = bottomView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArchivesPersonCell *cell = [ArchivesPersonCell createCellWithTableView:tableView];
    cell.titleLb.text = @"王大爷";
    cell.subTitleLb.text = @"2016-11-16";
    cell.badgeIcon.hidden = YES;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    InterveneController *interveneVC = [[InterveneController alloc] init];
    //    view.wid = model.wid;
    //    [self.navigationController pushViewController:interveneVC animated:YES];
}

#pragma mark button method

-(void)scan
{
    ScanCodesViewController *scanCodeVC = [[ScanCodesViewController alloc] init];
    scanCodeVC.getcodeClick = ^(NSString *code){
        [[[UIAlertView alloc] initWithTitle:@"扫码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    };
    [self.navigationController pushViewController:scanCodeVC animated:YES];

}

-(void)add
{
    HealthArchiveViewController *vc = [[HealthArchiveViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
