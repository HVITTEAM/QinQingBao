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
@property (strong,nonatomic)NSMutableArray *dataProvider;

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
    
    [self loadArchiveDataList];
    
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
    [btn addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    
    UIButton *btn0 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + 20, 20, MTScreenW/2 - 30, 40)];
    [btn0 setTitle:@"+ 新建档案" forState:UIControlStateNormal];
    btn0.backgroundColor = HMColor(140, 185, 50);
    btn0.layer.cornerRadius = 4.0f;
    btn0.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn0 addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn0];
    
    self.tableView.tableFooterView = bottomView;
}

- (void)loadArchiveDataList
{
    NSDictionary *params = @{ @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                             @"page":@"100",
                             @"p":@"1"};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_bingding_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [hud removeFromSuperview];
        
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:@"errorMsg" view:self.view];
        }
        
        NSArray *arr = [ArchiveDataListModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        self.dataProvider = [[NSMutableArray alloc] initWithArray:arr];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArchivesPersonCell *cell = [ArchivesPersonCell createCellWithTableView:tableView];
    
    ArchiveDataListModel *item = self.dataProvider[indexPath.section];

    cell.titleLb.text = item.truename;
    cell.subTitleLb.text = item.mobile;
    cell.badgeIcon.hidden = YES;
    
    NSURL *iconUrl = [NSURL URLWithString:item.avatar];
    [cell.imgView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"pc_user"]];
    
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
    HealthArchiveViewController *healthArchiveVC = [[HealthArchiveViewController alloc] init];
    healthArchiveVC.selectedListModel = self.dataProvider[indexPath.section];
    healthArchiveVC.addArchive = NO;
    [self.navigationController pushViewController:healthArchiveVC animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveDataListModel *item = self.dataProvider[indexPath.section];

    [tableView setEditing:NO animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定解除档案绑定？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteArchiveWhitCode:item.fmno];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解绑";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark button method

-(void)scan
{
    ScanCodesViewController *scanCodeVC = [[ScanCodesViewController alloc] init];
    scanCodeVC.getcodeClick = ^(NSString *code){
        [self addArchiveWhitCode:code];
    };
    [self.navigationController pushViewController:scanCodeVC animated:YES];

}

-(void)add
{
    HealthArchiveViewController *vc = [[HealthArchiveViewController alloc] init];
    vc.addArchive = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 通过扫描二维码添加档案
 */
-(void)addArchiveWhitCode:(NSString *)code
{
    NSDictionary *params = @{ @"client":@"ios",
                              @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                              @"fmno":code};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Bingding_fm parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [hud removeFromSuperview];
        
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
        
        [self loadArchiveDataList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];

}

/**
 解绑档案
 */
-(void)deleteArchiveWhitCode:(NSString *)code
{
    NSDictionary *params = @{ @"client":@"ios",
                              @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                              @"fmno":code};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Un_bingding_fm parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [hud removeFromSuperview];
        
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
        
        [self loadArchiveDataList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
    
}
@end
