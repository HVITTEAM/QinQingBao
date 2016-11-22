//
//  PayResultViewController.m
//  QinQingBao
//
//  Created by shi on 2016/11/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PayResultViewController.h"
#import "ArchivesCell.h"
#import "ArchiveDataListModel.h"
#import "ScanCodesViewController.h"
#import "HealthArchiveViewController.h"

@interface PayResultViewController ()

@property (strong, nonatomic) NSMutableArray *dataProvider;

@property (strong, nonatomic) ArchiveDataListModel *selectedArchiveData;

@property (assign, nonatomic) NSInteger selectedIdx;

@end

@implementation PayResultViewController
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"指定受检人";
    
    self.tableView.separatorColor = [UIColor colorWithRGB:@"dcdcdc"];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [self getFooterView];
    
    self.selectedIdx = -1;
    
    [self loadArchiveDataList];
}

- (NSMutableArray *)dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[NSMutableArray alloc] init];
    }
    
    return _dataProvider;
}

#pragma mark - 协议方法
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section == 0) {
        static NSString *payResultCellId = @"payResultCell";
        UITableViewCell *payResultCell = [tableView dequeueReusableCellWithIdentifier:payResultCellId];
        if (!payResultCell) {
            payResultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payResultCellId];
            payResultCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *resultLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, MTScreenW, 25)];
            resultLb.textColor = [UIColor colorWithRGB:@"94bf36"];
            resultLb.font = [UIFont systemFontOfSize:21];
            resultLb.textAlignment = NSTextAlignmentCenter;
            [payResultCell.contentView addSubview:resultLb];
            resultLb.text = @"订单已支付成功!";
            
            UILabel *promptLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(resultLb.frame) + 10, MTScreenW, 25)];
            promptLb.textColor = [UIColor colorWithRGB:@"666666"];
            promptLb.font = [UIFont systemFontOfSize:14];
            promptLb.textAlignment = NSTextAlignmentCenter;
            [payResultCell.contentView addSubview:promptLb];
            promptLb.text = @"请指定受检人或创建受检人健康档案";
        }
        return payResultCell;
        
    }else if(indexPath.section == 1 && indexPath.row == 0){
        
        static NSString *titleCellId = @"titleCell";
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
        if (!titleCell) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellId];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            titleCell.textLabel.font = [UIFont systemFontOfSize:14];
            titleCell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
            titleCell.layoutMargins = UIEdgeInsetsZero;
        }
        titleCell.textLabel.text = @"我的亲友";
        return titleCell;
        
    }else{
        ArchivesCell *archivesCell = [ArchivesCell createCellWithTableView:tableView];
        archivesCell.scanBlock = ^{
            ScanCodesViewController *scanCodeVC = [[ScanCodesViewController alloc] init];
            scanCodeVC.hidesBottomBarWhenPushed = YES;
            scanCodeVC.getcodeClick = ^(NSString *code){
                [[[UIAlertView alloc] initWithTitle:@"扫码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            };
            [weakSelf.navigationController pushViewController:scanCodeVC animated:YES];
        };
        
        archivesCell.addNewArchivesBlock = ^{
            HealthArchiveViewController *addHealthArchiveVC = [[HealthArchiveViewController alloc] init];
            addHealthArchiveVC.addArchive = YES;
            [weakSelf.navigationController pushViewController:addHealthArchiveVC animated:YES];
        };
        
        archivesCell.tapArchiveBlock = ^(NSUInteger idx){
            weakSelf.selectedArchiveData = weakSelf.dataProvider[idx];
            weakSelf.selectedIdx = idx;
            [weakSelf.tableView reloadData];
        };
        
        archivesCell.relativesArr = self.dataProvider;
        archivesCell.selectedIdx = self.selectedIdx;
        
        return archivesCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        return 40;
        
    }else{
        return [ArchivesCell cellHeight];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - 私有方法
- (UIView *)getFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 150)];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, MTScreenW - 20, 40)];
    [btn1 setTitle:@"指定受检人" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor colorWithRGB:@"94bf36"];
    btn1.layer.cornerRadius = 8.0f;
    [btn1 addTarget:self action:@selector(specifiedPeopleAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(btn1.frame) + 10, MTScreenW - 20, 40)];
    [btn2 setTitle:@"默默忽略" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor colorWithRGB:@"94bf36"] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.layer.cornerRadius = 8.0f;
    [btn2 addTarget:self action:@selector(ignoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn2];
    
    return footerView;
}

/**
 *  忽略
 */
- (void)ignoreAction:(UIButton *)sender
{
    [NoticeHelper AlertShow:@"你已经忽略了" view:nil];
}

/**
 *  指定受检人
 */
- (void)specifiedPeopleAction:(UIButton *)sender
{
    if ([SharedAppUtil defaultCommonUtil].userVO.key.length <= 0) {
        return;
    }
    
    if (!self.selectedArchiveData) {
        [NoticeHelper AlertShow:@"请先选择指定受检人" view:nil];
        return;
    }
    
    NSMutableDictionary *params = [@{
                                     @"client":@"ios",
                                     @"key":[SharedAppUtil defaultCommonUtil].userVO.key
                                     }mutableCopy];
    params[@"fmno"] = self.selectedArchiveData.fmno;
    params[@"wid"] = @"";
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Add_workinfo_fm parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [hud removeFromSuperview];
        
        if([dict[@"code"] integerValue] != 0){
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            return;
        }
        
        [NoticeHelper AlertShow:@"成功" view:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:@"指定受检人失败" view:nil];
    }];
}

/**
 *  加载联系人档案
 */
- (void)loadArchiveDataList
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates])
        return;
    
    NSDictionary *params = @{
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                             @"page":@"100",
                             @"p":@"1"
                             };
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

@end
