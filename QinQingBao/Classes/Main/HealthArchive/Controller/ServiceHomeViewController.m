//
//  ServiceHomeViewController.m
//  QinQingBao
//
//  Created by shi on 2016/11/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ServiceHomeViewController.h"
#import "ArchivesCell.h"
#import "MessageTypeCell.h"

#import "AllQuestionController.h"
#import "InterventionPlanController.h"
#import "ReportListViewController.h"

#import "QuestionResultController3.h"
#import "PayResultViewController.h"
#import "HealthArchiveViewController.h"

#import "ScanCodesViewController.h"

#import "HealthArchiveViewController.h"
#import "ArchiveDataListModel.h"
#import "ReportInterventionModel.h"

@interface ServiceHomeViewController ()
{
    Boolean newWP;
    Boolean newWI;
    
    // 重点提醒
    NSString *importMsgStr;
}

@property (strong,nonatomic)NSMutableArray *dataProvider;

@end

@implementation ServiceHomeViewController

-(instancetype)init
{
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    importMsgStr = @"暂无与您健康相关的提醒需要您关注";
    
    self.dataProvider = [[NSMutableArray alloc] init];
    
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorColor = [UIColor colorWithRGB:@"ebebeb"];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
    
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getServicesData];
    }];
    
    [self.tableView.header beginRefreshing];
    
    [MTNotificationCenter addObserver:self selector:@selector(refleshData:) name:MTRefleshData object:nil];
}

/**
 * 重新登录成功处理事件
 */
-(void)refleshData:(NSNotification *)notification
{
    [self getServicesData];
}

- (void)getServicesData
{
    //判断是否登录
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
    {
        [self.tableView.header endRefreshing];
        [self.dataProvider removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    
    [self loadArchiveDataList];
    
    [self getInterventionPlanList];
    
    [self getImportMsg];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 2;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewCell *cell = nil;
    if ((indexPath.section == 0 || indexPath.section == 2) && indexPath.row == 0) {  //标题
        static NSString *titleCellId = @"titleCell";
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
        if (!titleCell) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellId];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            titleCell.textLabel.font = [UIFont systemFontOfSize:14];
            titleCell.layoutMargins = UIEdgeInsetsZero;
        }
        
        if (indexPath.section == 0) {
            titleCell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
            titleCell.textLabel.text = @"健康档案";
            titleCell.imageView.image = [UIImage imageNamed:@"person.png"];
            
        }else{
            titleCell.textLabel.textColor = [UIColor colorWithRGB:@"fbb03b"];
            titleCell.textLabel.text = @"重点提示";
            titleCell.imageView.image = [UIImage imageNamed:@"warning.png"];
        }
        
        cell = titleCell;
    }else if (indexPath.section == 0 && indexPath.row == 1){ //档案cell
        ArchivesCell *archivesCell = [ArchivesCell createCellWithTableView:tableView];
        archivesCell.scanBlock = ^{
            ScanCodesViewController *scanCodeVC = [[ScanCodesViewController alloc] init];
            scanCodeVC.hidesBottomBarWhenPushed = YES;
            scanCodeVC.getcodeClick = ^(NSString *code){
                if ([SharedAppUtil checkLoginStates])
                {
                    [self addArchiveWhitCode:code];
                }
            };
            [self.parentVC.navigationController pushViewController:scanCodeVC animated:YES];
        };
        
        archivesCell.addNewArchivesBlock = ^{
            if ([SharedAppUtil checkLoginStates])
            {
                HealthArchiveViewController *addHealthArchiveVC = [[HealthArchiveViewController alloc] init];
                addHealthArchiveVC.addArchive = YES;
                [self.parentVC.navigationController pushViewController:addHealthArchiveVC animated:YES];
            }
        };
        archivesCell.tapArchiveBlock = ^(NSUInteger idx){
            HealthArchiveViewController *healthArchiveVC = [[HealthArchiveViewController alloc] init];
            healthArchiveVC.selectedListModel = weakSelf.dataProvider[idx];
            healthArchiveVC.addArchive = NO;
            [self.parentVC.navigationController pushViewController:healthArchiveVC animated:YES];
        };
        
        archivesCell.relativesArr = self.dataProvider;
        
        return archivesCell;
    }else if(indexPath.section == 1){
        MessageTypeCell *typeCell = [tableView dequeueReusableCellWithIdentifier:@"MTMessageTypeCell"];
        
        if (typeCell == nil){
            typeCell =  [MessageTypeCell messageTypeCell];
            typeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            typeCell.titleLab.font = [UIFont systemFontOfSize:16];
            typeCell.subtitleLab.font = [UIFont systemFontOfSize:12];
            typeCell.badgeToBottomCons.constant = 30;
        }
        switch (indexPath.row) {
            case 0:
                typeCell.headImg.image = [UIImage imageNamed:@"zxzx.png"];
                typeCell.titleLab.text = @"健康评估";
                typeCell.subtitleLab.text = @"在线评估您的身体健康状况";
                typeCell.badgeView.hidden = YES;
                break;
            case 1:
                typeCell.headImg.image = [UIImage imageNamed:@"jkpg.png"];
                typeCell.titleLab.text = @"检测报告";
                typeCell.subtitleLab.text = @"在线查看检测报告和报告解读";
                typeCell.badgeView.hidden = !newWP;
                break;
            case 2:
                typeCell.headImg.image = [UIImage imageNamed:@"gyfa.png"];
                typeCell.titleLab.text = @"干预方案";
                typeCell.subtitleLab.text = @"为您量身定制健康干预方案";
                typeCell.badgeView.hidden = !newWI;
                break;
            default:
                break;
        }
        cell = typeCell;
        
    }else{ //重点提示
        static NSString *promptCellId = @"promptCell";
        UITableViewCell *promptCell = [tableView dequeueReusableCellWithIdentifier:promptCellId];
        if (!promptCell) {
            promptCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:promptCellId];
            promptCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *lb = [[UILabel alloc] init];
            lb.font = [UIFont systemFontOfSize:12];
            lb.textColor = [UIColor colorWithRGB:@"666666"];
            lb.numberOfLines = 0;
            lb.tag = 201;
            [promptCell.contentView addSubview:lb];
        }
        
        CGFloat h = [importMsgStr boundingRectWithSize:CGSizeMake(MTScreenW - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
        
        UILabel *lb = [promptCell.contentView viewWithTag:201];
        lb.frame = CGRectMake(20, 10, MTScreenW - 40, h);
        lb.text = importMsgStr;
        promptCell.height= h + 20;
        
        cell = promptCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0 || indexPath.section == 2) && indexPath.row == 0) {
        return 40;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        return [ArchivesCell cellHeight];
    }else if(indexPath.section == 1){
        return 80;
    }else{
        
        CGFloat minH = MTScreenH - (40 * 2 + [ArchivesCell cellHeight] + 3 * 80 + 64 + 44  + 25 + 10);
        
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height > minH?cell.height:minH;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![SharedAppUtil checkLoginStates])
        return;
    if (indexPath.section == 0 || indexPath.section == 2) {
        return;
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        AllQuestionController *vc = [[AllQuestionController alloc] init];
        vc.c_id = @"1";
        vc.title = @"健康评估";
        [self.parentVC.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        ReportListViewController *reportListVC = [[ReportListViewController alloc] init];
        [self.parentVC.navigationController pushViewController:reportListVC animated:YES];
        
    }else{
        InterventionPlanController *interventionVC = [[InterventionPlanController alloc] init];
        [self.parentVC.navigationController pushViewController:interventionVC animated:YES];
    }
}

- (void)loadArchiveDataList
{
    NSDictionary *params = @{
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                             @"page":@"100",
                             @"p":@"1"
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_bingding_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [self.tableView.header endRefreshing];
        
        if ([dict[@"code"] integerValue] != 0 && [dict[@"code"] integerValue] != 17001) {
            [NoticeHelper AlertShow:@"errorMsg" view:self.view];
        }
        
        NSArray *arr = [ArchiveDataListModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        self.dataProvider = [[NSMutableArray alloc] initWithArray:arr];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        [NoticeHelper AlertShow:MTServiceError view:nil];
    }];
    
}

/**
 *  加载干预方案和检测报告未读状态
 */
- (void)getInterventionPlanList
{
    NSMutableDictionary *params = [@{@"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"client":@"ios"
                                     }mutableCopy];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_work_read parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if ([dict[@"code"] integerValue] > 0)
        {
            return ;
        }
        
        NSArray *datas = [ReportInterventionModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        if (datas.count > 0)
        {
            for (ReportInterventionModel *item in datas)
            {
                //检测报告有未读
                if (item.wp_read.count>0)
                {
                    newWP = YES;
                    [self.tableView reloadData];
                    break;
                }
                else
                {
                    newWP = NO;
                    [self.tableView reloadData];
                }
            }
            
            for (ReportInterventionModel *item in datas)
            {
                //干预方案有未读
                if (item.wi_read.count>0)
                {
                    newWI = YES;
                    [self.tableView reloadData];
                    break;
                }
                else
                {
                    newWI = NO;
                    [self.tableView reloadData];
                }
            }

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

-(void)getImportMsg
{
    importMsgStr = @"暂无与您健康相关的提醒需要您关注";
    
    //判断是否登录
    
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        return  [self.tableView.header endRefreshing];
    NSDictionary *params = @{ @"client":@"ios",
                              @"key":[SharedAppUtil defaultCommonUtil].userVO.key};
    [CommonRemoteHelper RemoteWithUrl:URL_Get_sysfmmsg_list parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        if ([dict[@"code"] integerValue] != 0) {
            //            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }
        else
        {
            NSArray *arr = dict[@"datas"];
            if (arr.count > 0)
            {
                importMsgStr = [arr[0] objectForKey:@"msg_content"];
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:MTServiceError view:nil];
    }];
}

@end
