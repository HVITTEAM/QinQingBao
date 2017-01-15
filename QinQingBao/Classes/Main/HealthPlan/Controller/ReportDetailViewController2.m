//
//  ReportDetailViewController2.m
//  QinQingBao
//
//  Created by 董徐维 on 2017/1/5.
//  Copyright © 2017年 董徐维. All rights reserved.
//

#import "ReportDetailViewController2.h"
#import "RepotDetailCell.h"
#import "ReportDetailViewController.h"
#import "UnusualReportViewController.h"

@interface ReportDetailViewController2 ()

@end

@implementation ReportDetailViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    [self uploadReadStatusWithReportId:self.wr_id fmno:self.fmno];
}

-(void)initTableView
{
    self.title = self.modelData.iname;
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"report.png"] style:UIBarButtonItemStyleDone target:self action:@selector(showWebView)];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return  cell.height;
    }
    else
        return 47;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return self.modelData.entry_content.none_gene_detection.non_normal.count + 1;
            break;
        case 2:
            return self.modelData.entry_content.none_gene_detection.normal.count + 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepotDetailCell *repotDetailCell = [tableView dequeueReusableCellWithIdentifier:@"RepotDetailCell"];
    repotDetailCell = [RepotDetailCell repotDetailCell];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        repotDetailCell.textLabel.text = @"检测报告结论";
        repotDetailCell.textLabel.textColor = [UIColor blackColor];
        repotDetailCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        repotDetailCell.paragraphValue = self.modelData.check_conclusion;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            repotDetailCell.imageView.image = [UIImage imageNamed:@"unusual.png"];
            repotDetailCell.textLabel.text = [NSString stringWithFormat:@"%lu项异常指标",(unsigned long)self.modelData.entry_content.none_gene_detection.non_normal.count];
            repotDetailCell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
            repotDetailCell.textLabel.font = [UIFont systemFontOfSize:14];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 70, 10, 50, 23)];
            [btn setTitle:@"详情" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor colorWithRGB:@"3fdde4"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(non_normalDetailClick) forControlEvents:UIControlEventTouchUpInside];
            [repotDetailCell addSubview:btn];
        }
        else if(self.modelData.entry_content.none_gene_detection.non_normal.count > 0)
        {
            GenesModel *item = self.modelData.entry_content.none_gene_detection.non_normal[indexPath.row - 1];
            [repotDetailCell setDataItem:item];
        }
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            repotDetailCell.imageView.image = [UIImage imageNamed:@"normal.png"];
            repotDetailCell.textLabel.text = [NSString stringWithFormat:@"%lu项正常指标",(unsigned long)self.modelData.entry_content.none_gene_detection.normal.count];
            repotDetailCell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
            repotDetailCell.textLabel.font = [UIFont systemFontOfSize:14];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 70, 10, 50, 23)];
            [btn setTitle:@"详情" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor colorWithRGB:@"3fdde4"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(normalDetailClick) forControlEvents:UIControlEventTouchUpInside];
            [repotDetailCell addSubview:btn];
        }
        else if(self.modelData.entry_content.none_gene_detection.normal.count > 0)
        {
            GenesModel *item = self.modelData.entry_content.none_gene_detection.normal[indexPath.row - 1];
            [repotDetailCell setDataItem:item];
        }
    }
    else
    {
        repotDetailCell.textLabel.text = @"";
        
    }
    
    //设置cell的边框
    if (indexPath.row == 0)
    {
        repotDetailCell.borderType = MTCellBorderTypeTOP;
    }
    else if (indexPath.row ==  [self  tableView:tableView numberOfRowsInSection:indexPath.section] - 1)
    {
        repotDetailCell.borderType = MTCellBorderTypeBottom;
    }
    else
    {
        repotDetailCell.borderType = MTCellBorderTypeTOPNone;
    }
    
    return repotDetailCell;
}

#pragma mark Click
-(void)non_normalDetailClick
{
    if (self.modelData.entry_content.none_gene_detection.non_normal.count < 1)
        return;
    UnusualReportViewController *vc = [[UnusualReportViewController alloc] init];
    vc.dataProvider = self.modelData.entry_content.none_gene_detection.non_normal;
    vc.title = @"异常指标解读";
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)normalDetailClick
{
    if (self.modelData.entry_content.none_gene_detection.normal.count < 1)
        return;
    UnusualReportViewController *vc = [[UnusualReportViewController alloc] init];
    vc.dataProvider = self.modelData.entry_content.none_gene_detection.normal;
    vc.title = @"正常指标解读";
    [self.navigationController pushViewController:vc animated:YES];
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
