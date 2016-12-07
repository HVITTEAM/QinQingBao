//
//  QuestionResultController3.m
//  QinQingBao
//
//  Created by shi on 2016/11/7.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "QuestionResultController3.h"
#import "ArchivesCell.h"
#import "QuestionResultCell.h"
#import "ArchiveDataListModel.h"
#import "ScanCodesViewController.h"
#import "HealthArchiveViewController.h"

@interface QuestionResultController3 ()

@property (strong, nonatomic) NSMutableArray *dataProvider;

@property (strong, nonatomic) ArchiveDataListModel *selectedArchiveData;

@property (assign, nonatomic) NSInteger selectedIdx;

@end

@implementation QuestionResultController3

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评估结果";
    
    self.tableView.separatorColor = [UIColor colorWithRGB:@"dcdcdc"];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [self getFooterView];
    
    self.selectedIdx = -1;
    
    [self loadArchiveDataList];
}

#pragma mark - 协议方法
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.truename && self.truename.length > 0 ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section == 0) {
        QuestionResultCell *resultCell = [QuestionResultCell createCellWithTableView:tableView];
        
        [resultCell setTextWithDangercoefficient:self.r_dangercoefficient advise:self.hmd_advise];
        
        return resultCell;
        
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
                [self addArchiveWhitCode:code];
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
        
        return archivesCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self tableView:tableView cellForRowAtIndexPath:indexPath].height;
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
/**
 *  创建底部确定按钮
 */
- (UIView *)getFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 150)];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, MTScreenW - 20, 40)];
    [btn1 setTitle:@"确定归档" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor colorWithRGB:@"94bf36"];
    btn1.layer.cornerRadius = 8.0f;
    [btn1 addTarget:self action:@selector(confirmArchiveAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(btn1.frame) + 10, MTScreenW - 20, 40)];
    [btn2 setTitle:@"默默忽略" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor colorWithRGB:@"94bf36"] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.layer.cornerRadius = 8.0f;
    [btn2 addTarget:self action:@selector(ignoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn2];
    
    return self.truename && self.truename.length > 0 ? nil : footerView;
}

/**
 *  忽略
 */
- (void)ignoreAction:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  确认归档
 */
- (void)confirmArchiveAction:(UIButton *)sender
{
    if ([SharedAppUtil defaultCommonUtil].userVO.key.length <= 0) {
        return;
    }
    
    if (!self.selectedArchiveData) {
        [NoticeHelper AlertShow:@"请先选择需要归档人员" view:nil];
        return;
    }
    
    NSMutableDictionary *params = [@{
                                     @"client":@"ios",
                                     @"key":[SharedAppUtil defaultCommonUtil].userVO.key
                                     }mutableCopy];
    params[@"fmno"] = self.selectedArchiveData.fmno;
    
    for (NSString *rid in self.r_ids) {
        params[@"r_id"] = rid;
        [CommonRemoteHelper RemoteWithUrl:URL_Add_qsreport_fm parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
            NSLog(@"%@",dict);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
    NSArray *vcs = self.navigationController.viewControllers;
    if (self.truename.length <= 0){
        if (vcs.count > 5) {
            [self.navigationController popToViewController:vcs[1] animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
        
        if ([dict[@"code"] integerValue] != 0 && [dict[@"code"] integerValue] != 17001) {
            [NoticeHelper AlertShow:@"errorMsg" view:self.view];
        }
        
        NSArray *arr = [ArchiveDataListModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        self.dataProvider = [[NSMutableArray alloc] initWithArray:arr];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud removeFromSuperview];
        [NoticeHelper AlertShow:MTServiceError view:nil];
    }];
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
        [NoticeHelper AlertShow:MTServiceError view:nil];
    }];
    
}

@end
