//
//  PersonReportListViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PersonReportListViewController.h"
#import "CommonPlanCell.h"
#import "PersonReportModel.h"
#import "HealthReportCell.h"
#import "ReportDetailViewController.h"
#import "VariousGenesViewController.h"
#import "ReportDetailViewController2.h"
#import "Gene_DetectionViewController.h"

@interface PersonReportListViewController ()
{
    NSMutableArray *dataProvider;
}

@end

@implementation PersonReportListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    dataProvider = [[NSMutableArray alloc] init];
    
    [self getDataProvider];
}

-(void)initView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = HMGlobalBg;
}


/**
 *  获取数据源
 */
-(void)getDataProvider
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_workreport_groupitem parameters:@{@"wid" : self.wid && self.wid.length >0 ? self.wid : @"",
                                                                                @"fmno" : self.fmno,
                                                                                @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                                                                @"client":@"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [HUD removeFromSuperview];
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         if ([codeNum integerValue] == 17001)
                                         {
                                             return [self.tableView initWithPlaceString:@"暂无相关报告" imgPath:@"placeholder-3"];
                                         }
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         for (NSArray *item in [dict objectForKey:@"datas"])
                                         {
                                             NSArray *arr = [PersonReportModel objectArrayWithKeyValuesArray:item];
                                             [dataProvider addObject:arr];
                                         }
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                     [HUD removeFromSuperview];
                                 }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthReportCell *healthReportCell = [tableView dequeueReusableCellWithIdentifier:@"MTHealthReportCell"];
    if(healthReportCell == nil)
        healthReportCell = [HealthReportCell healthReportCell];
    
    healthReportCell.dataProvider = dataProvider[indexPath.section];
    __weak typeof(self) weakSelf = self;
    healthReportCell.clickType = ^(PersonReportModel *item){
        
        //非基因类
        if (item.entry_content.none_gene_detection && item.entry_content.none_gene_detection != nil &&
            (item.entry_content.none_gene_detection.normal.count >0 || item.entry_content.none_gene_detection.non_normal.count >0))
        {
            ReportDetailViewController2 *VC =[[ReportDetailViewController2 alloc] init];
            VC.modelData = item;
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }
        //（等位基因）
        else if (item.entry_content.gene_detection && item.entry_content.gene_detection != nil)
        {
            Gene_DetectionViewController *VC =[[Gene_DetectionViewController alloc] init];
            VC.modelData = item;
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }
        //非等位基因
        else if (item.entry_content.various_genes && item.entry_content.various_genes != nil)
        {
            VariousGenesViewController *VC =[[VariousGenesViewController alloc] init];
            VC.modelData = item;
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }
    };
    return healthReportCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
