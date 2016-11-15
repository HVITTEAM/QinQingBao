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

@interface ServiceHomeViewController ()

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
        }else{
            titleCell.textLabel.textColor = [UIColor colorWithRGB:@"fbb03b"];
            titleCell.textLabel.text = @"重点提示";
        }
        
        cell = titleCell;
    }else if (indexPath.section == 0 && indexPath.row == 1){ //档案cell
        ArchivesCell *archivesCell = [ArchivesCell createCellWithTableView:tableView];
        archivesCell.scanBlock = ^{
            [[[UIAlertView alloc] initWithTitle:@"扫码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        };
        
        archivesCell.addNewArchivesBlock = ^{
            [weakSelf.dataProvider addObject:@"1"];
            [weakSelf.tableView reloadData];
        };
        archivesCell.tapArchiveBlock = ^(NSUInteger idx){
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"点击了第%d个",(int)idx] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
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
                typeCell.headImg.image = [UIImage imageNamed:@"eventinfo.png"];
                typeCell.titleLab.text = @"健康评估";
                typeCell.subtitleLab.text = @"健康评估";
                typeCell.badgeView.hidden = NO;
                break;
            case 1:
                typeCell.headImg.image = [UIImage imageNamed:@"healthTips.png"];
                typeCell.titleLab.text = @"检测报告";
                typeCell.subtitleLab.text = @"检测报告";
                typeCell.badgeView.hidden = YES;
                break;
            case 2:
                typeCell.headImg.image = [UIImage imageNamed:@"pushMsg.png"];
                typeCell.titleLab.text = @"干预方案";
                typeCell.subtitleLab.text = @"干预方案";
                typeCell.badgeView.hidden = YES;
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
        return 70;
    }else{
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height + 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
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

@end
