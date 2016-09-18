//
//  DiscoveryViewController.m
//  QinQingBao
//
//  Created by shi on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "LoopImageView.h"
#import "ScrollMenuTableCell.h"
#import "CommunityViewController.h"

@interface DiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *healthCommunityDatas;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    UITextField *searhField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MTScreenW - 20, 30)];
    searhField.placeholder = @"输入搜索关键字";
    searhField.borderStyle = UITextBorderStyleRoundedRect;
    searhField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searhField.font = [UIFont systemFontOfSize:14];
    searhField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
    imgView.backgroundColor = [UIColor redColor];
    imgView.image = [UIImage imageNamed:@"lockIcon"];
    [leftView addSubview:imgView];
    searhField.leftView = leftView;
    self.navigationItem.titleView = searhField;
    
    UITableView *tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - 64) style:UITableViewStyleGrouped];
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.backgroundColor = HMGlobalBg;
    [self.view addSubview:tbv];
    self.tableView = tbv;
    
    LoopImageView *loopView = [[LoopImageView alloc] init];
    loopView.bounds = CGRectMake(0, 0, MTScreenW, (int)(MTScreenW / 3));
    loopView.imageUrls = @[
                           @"http://www.xxjxsj.cn/article/uploadpic/2012-4/201241221251481736.jpg",
                           @"http://www.pptbz.com/pptpic/UploadFiles_6909/201203/2012031220134655.jpg",
                           @"http://img.taopic.com/uploads/allimg/130711/318756-130G1222R317.jpg",
                           @"http://pic14.nipic.com/20110610/7181928_110502231129_2.jpg"
                           ];

    tbv.tableHeaderView = loopView;
    
    self.healthCommunityDatas = [@[@{KScrollMenuTitle:@"健康资讯",KScrollMenuImg:@"healthNews_icon"},
                                  @{KScrollMenuTitle:@"心脑血管",KScrollMenuImg:@"heart_brain_icon"},
                                  @{KScrollMenuTitle:@"易疲劳",KScrollMenuImg:@"fatigue_icon"},
                                  @{KScrollMenuTitle:@"减肥瘦身",KScrollMenuImg:@"reduceWeight_icon"},
                                   @{KScrollMenuTitle:@"易疲劳",KScrollMenuImg:@"fatigue_icon"},
                                   @{KScrollMenuTitle:@"减肥瘦身",KScrollMenuImg:@"reduceWeight_icon"}
                                  ]copy];
    
}

- (NSMutableArray *)healthCommunityDatas
{
    if (!_healthCommunityDatas) {
        _healthCommunityDatas = [[NSMutableArray alloc] init];
    }
    
    return _healthCommunityDatas;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0){
        static NSString *cellId = @"titleCellId";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = @"健康服务";
                break;
            case 1:
                cell.textLabel.text = @"健康圈";
                break;
            default:
                cell.textLabel.text = @"热门帐号";
                break;
        }
        
    }else if (indexPath.row == 1 && indexPath.section != 2){
        ScrollMenuTableCell * menuCell = [ScrollMenuTableCell createCellWithTableView:tableView];
        menuCell.selectMenuItemCallBack = ^(NSInteger idx){
            CommunityViewController *communityVC = [[CommunityViewController alloc] init];
            [weakSelf.navigationController pushViewController:communityVC animated:YES];
        };
        menuCell.row = 1;
        menuCell.col = 4;
        menuCell.colSpace = 10;
        if (indexPath.section == 0) {
            menuCell.margin = UIEdgeInsetsMake(10, 10, 10, 10);
            menuCell.shouldShowIndicator = NO;
            menuCell.datas = @[@{KScrollMenuTitle:@"健康检测",KScrollMenuImg:@"healthTesting_icon"},
                               @{KScrollMenuTitle:@"基因检测",KScrollMenuImg:@"gene_icon"},
                               @{KScrollMenuTitle:@"超声理疗",KScrollMenuImg:@"Ultrasonic_icon"},
                               @{KScrollMenuTitle:@"健康计划",KScrollMenuImg:@"healthPan_icon"}
                               ];
        }else{

            if (self.healthCommunityDatas.count > 4) {
                menuCell.shouldShowIndicator = YES;
                menuCell.margin = UIEdgeInsetsMake(10, 10, 0, 10);
            }else{
                menuCell.shouldShowIndicator = NO;
                menuCell.margin = UIEdgeInsetsMake(10, 10, 10, 10);
            }
            menuCell.datas = self.healthCommunityDatas;
        }
        
        cell = menuCell;
    }else{
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"asdfsadf"];
        cell.textLabel.text = @"hello";
    }

    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 36;
    }else if (indexPath.section == 1) {
        if (self.healthCommunityDatas.count > 4) {
            return 120;
        }
    }
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

@end
