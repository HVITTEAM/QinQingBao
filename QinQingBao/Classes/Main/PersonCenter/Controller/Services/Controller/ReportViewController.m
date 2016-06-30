//
//  ReportViewController.m
//  QinQingBao
//
//  Created by shi on 16/6/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ReportViewController.h"
#import "ParagraphTextCell.h"
#import "WorkReportModel.h"

@interface ReportViewController ()

@property (nonatomic,strong) WorkReportModel *reportInfo;

@end

@implementation ReportViewController

-(instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"医嘱信息";
    
    [self getWorkReportData];
    
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0)
    {
        UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
        if(commoncell == nil)
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MTCommonCell"];
        commoncell.textLabel.text = @"医嘱";
        cell = commoncell;
    }
    else
    {
        ParagraphTextCell *paragraphTextCell = [tableView dequeueReusableCellWithIdentifier:@"MTParagraphTextCell"];
        if(paragraphTextCell == nil)
            paragraphTextCell = [ParagraphTextCell paragraphTextCell];
        switch (indexPath.row)
        {
            case 1:
                [paragraphTextCell setTitle:@"饮食" withValue:self.reportInfo.wp_advice_diet];
                cell = paragraphTextCell;
                break;
            case 2:
                [paragraphTextCell setTitle:@"运动" withValue:self.reportInfo.wp_advice_sport];
                cell = paragraphTextCell;
                break;
            case 3:
                [paragraphTextCell setTitle:@"其它" withValue:self.reportInfo.wp_advice_others];
                cell = paragraphTextCell;
                break;
            default:
                break;
  
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - 网络相关
/**
 *  获取医嘱信息
 */
-(void)getWorkReportData
{
    NSDictionary *params = @{
                             @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client" : @"ios",
                             @"wid" : self.wid
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_get_work_report parameters:params
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     if ([dict[@"code"] integerValue] != 0) {
                                         [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
                                         return ;
                                     }
                                     
                                     WorkReportModel *model = [WorkReportModel objectWithKeyValues:dict[@"datas"]];
                                     self.reportInfo = model;
                                     [self.tableView reloadData];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [NoticeHelper AlertShow:@"请检查网络是否正常" view:nil];
                                 }];
    
}

@end
