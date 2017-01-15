//
//  Gene_DetectionViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/8.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import "Gene_DetectionViewController.h"
#import "RepotDetailCell.h"
#import "GeneDetectionCell.h"
#import "ReportDetailViewController.h"

@interface Gene_DetectionViewController ()

@end

@implementation Gene_DetectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    [self uploadReadStatusWithReportId:self.wr_id fmno:self.fmno];
}

-(void)initTableView
{
    self.title = _modelData.iname;
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"report.png"] style:UIBarButtonItemStyleDone target:self action:@selector(showWebView)];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return  cell.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _modelData.entry_content.various_genes.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    GeneDetectionCell *geneDetectionCell = [tableView dequeueReusableCellWithIdentifier:@"GeneDetectionCell"];
    if(geneDetectionCell == nil)
        geneDetectionCell = [GeneDetectionCell geneDetectionCell];
    
    RepotDetailCell *repotDetailCell = [tableView dequeueReusableCellWithIdentifier:@"RepotDetailCell"];
    repotDetailCell = [RepotDetailCell repotDetailCell];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        repotDetailCell.textLabel.text = @"检测报告结论";
        repotDetailCell.textLabel.textColor = [UIColor blackColor];
        repotDetailCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell = repotDetailCell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        repotDetailCell.paragraphValue = self.modelData.check_conclusion;
        cell = repotDetailCell;
    }
    else
    {
        GenesModel *item = _modelData.entry_content.various_genes[indexPath.section - 1];
        geneDetectionCell.dataItem = item;
        geneDetectionCell.paragraphValue = item.ycjd_detail;
        cell = geneDetectionCell;
    }
    
    //设置cell的边框
    if (indexPath.row == 0)
    {
        repotDetailCell.borderType = MTCellBorderTypeTOP;
    }
    else if (indexPath.row ==  [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1)
    {
        repotDetailCell.borderType = MTCellBorderTypeBottom;
    }
    else
    {
        repotDetailCell.borderType = MTCellBorderTypeTOPNone;
    }
    
    return cell;
    
}


-(void)showWebView
{
    ReportDetailViewController *VC =[[ReportDetailViewController alloc] init];
    VC.title = self.modelData.iname;
    VC.urlArr = self.modelData.wp_advice_report;
    VC.wr_id = self.modelData.wr_id;
    VC.fmno = self.fmno;
    
    if (self.modelData.entry_voice && self.modelData.entry_voice.count > 0)
    {
        NSMutableString *str = [[NSMutableString alloc] init];
        if (self.modelData.entry_voice &&  self.modelData.entry_voice.count > 0)
        {
            for (NSDictionary *dict in self.modelData.entry_voice)
            {
                [str appendString:[dict objectForKey:@"ycjd_voice"]];
            }
        }
        VC.speakStr = str;
    }
    else
        VC.speakStr = @"";
    [self.navigationController pushViewController:VC animated:YES];
}


/**
 *  检测报告状态变更 未读改为已读  read为0:解读报告操作 1:干预方案操作
 */
- (void)uploadReadStatusWithReportId:(NSString *)reportId fmno:(NSString *)fmno
{
    NSMutableDictionary *params = [@{
                                     @"client":@"ios",
                                     @"key":[SharedAppUtil defaultCommonUtil].userVO.key
                                     }mutableCopy];
    params[@"fmno"] = fmno;
    params[@"report_id"] = reportId;
    params[@"read"] = @"0";
    
    [CommonRemoteHelper RemoteWithUrl:URL_Readed parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
