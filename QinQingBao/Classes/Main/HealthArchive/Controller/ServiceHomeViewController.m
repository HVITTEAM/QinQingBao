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

#import "ClasslistViewController.h"
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
    
    self.dataProvider = [[NSMutableArray alloc] init];
    
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorColor = [UIColor colorWithRGB:@"dcdcdc"];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
    
    [self loadArchiveDataList];
    
    [self getInterventionPlanList];
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
            promptCell.textLabel.font = [UIFont systemFontOfSize:14];
            promptCell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
            promptCell.textLabel.numberOfLines = 0;
            promptCell.layoutMargins = UIEdgeInsetsZero;
        }
        
        NSString *promptStr = @"as砥砺风节爱上了点金乏术绝对拉风静安寺劳动纠纷拉丝机东方丽景奥丝蓝黛发撒蝶恋蜂狂as砥砺风节爱上了点金乏术绝对拉风静安寺劳动纠纷拉丝机东方丽景奥丝蓝黛发撒蝶恋蜂狂as砥砺风节爱上了点金乏术绝对拉风静安寺劳动纠纷拉丝机东方丽景奥丝蓝黛发撒蝶恋蜂狂as砥砺风节爱上了点金乏术绝对拉风静安寺劳动纠纷拉丝机东方丽景奥丝蓝黛发撒蝶恋蜂狂as砥砺风节爱上了点金乏术绝对拉风静安寺劳动纠纷拉丝机东方丽景奥丝蓝黛发撒蝶恋蜂狂as砥砺风节爱上了点金乏术绝对拉风静安寺劳动纠纷拉丝机东方丽景奥丝蓝黛发撒蝶恋蜂狂as砥砺风节爱上了点金乏术绝对拉风静安寺劳动纠纷拉丝机东方丽景奥丝蓝黛发撒蝶恋蜂狂蝶恋蜂狂as砥";
        CGFloat h = [promptStr boundingRectWithSize:CGSizeMake(MTScreenW - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        
        promptCell.textLabel.text = promptStr;
        promptCell.height= h;
        
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
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height + 30;
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
    if (indexPath.section == 0 || indexPath.section == 2) {
        return;
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        ClasslistViewController *questionResultVC = [[ClasslistViewController alloc] init];
        [self.parentVC.navigationController pushViewController:questionResultVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        ReportListViewController *reportListVC = [[ReportListViewController alloc] init];
        [self.parentVC.navigationController pushViewController:reportListVC animated:YES];
        
    }else{
        InterventionPlanController *interventionVC = [[InterventionPlanController alloc] init];
        [self.parentVC.navigationController pushViewController:interventionVC animated:YES];
    }
    
    //    PayResultViewController *payResultVC = [[PayResultViewController alloc] init];
    //    [self.parentVC.navigationController pushViewController:payResultVC animated:YES];
    //
    //    QuestionResultController3 *payResultVC = [[QuestionResultController3 alloc] init];
    //    [self.parentVC.navigationController pushViewController:payResultVC animated:YES];
    
}

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

/**
 *  加载干预方案和检测报告未读状态
 */
- (void)getInterventionPlanList
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates])
        return;
    
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
                }
                //干预方案有未读
                if (item.wi_read.count>0)
                {
                    newWI = YES;
                    [self.tableView reloadData];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
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
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
    
}


@end
