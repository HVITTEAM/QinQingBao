//
//  ReportViewController.m
//  QinQingBao
//
//  Created by shi on 16/6/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ReportViewController.h"
#import "WorkReportModel.h"
#import "ReportInfoCell.h"

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
    
    self.navigationItem.title = @"医嘱信息";
    
    [self setupTableView];
    
    [self getWorkReportData];

}

-(void)setupTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HMGlobalBg;
    
    //设置底部的提示view
    UIView *footView = [[UIView alloc] init];
    self.tableView.tableFooterView = footView;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 6.0f;
    NSDictionary *attr = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:14],
                           NSForegroundColorAttributeName : HMColor(127, 98, 69),
                           NSParagraphStyleAttributeName : paragraph
                           };
    
    NSMutableAttributedString *mtAttrStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示 ：检测报告文件已经发到您的电子信箱,请注意查收.如有疑惑欢迎联系客服咨询。" attributes:attr];
    
    [mtAttrStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, 6)];
    
    UILabel *lb = [[UILabel alloc] init];
    lb.numberOfLines = 0;
    lb.attributedText = mtAttrStr;
    
    CGSize size = [lb sizeThatFits:CGSizeMake(MTScreenW - 25, MAXFLOAT)];
    lb.frame = CGRectMake(15, 10, size.width, size.height);
    
    [footView addSubview:lb];
    footView.frame = CGRectMake(0, 0, 0, size.height + 20);
    
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportInfoCell *reportInfoCell = [ReportInfoCell createCellWithTableView:tableView];
    if (0 == indexPath.row) {
        [self setCell:reportInfoCell iconName:@"report_diet_icon" title:@"饮食方面" content:self.reportInfo.advice_diet];
        
    }else if (1 == indexPath.row){
        [self setCell:reportInfoCell iconName:@"report_sport_icon" title:@"运动方面" content:self.reportInfo.advice_sport];

    }else{
        [self setCell:reportInfoCell iconName:@"report_other_icon" title:@"其他方面" content:self.reportInfo.advice_others];
    }
    
    [reportInfoCell computeCellHeight];

    return reportInfoCell;
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

/**
 *  设置ReportInfoCell内容
 */
-(void)setCell:(ReportInfoCell *)cell iconName:(NSString *)iconName title:(NSString *)aTitle content:(NSString *)aContent
{
    cell.imgView.image = [UIImage imageNamed:iconName];
    cell.titleLb.text = aTitle;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 6.0f;
    NSDictionary *attr = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:14],
                           NSForegroundColorAttributeName : [UIColor darkGrayColor],
                           NSParagraphStyleAttributeName : paragraph
                           };
    if (!aContent || 0 == aContent.length) {
        aContent = @"暂无建议";
    }
    
    NSAttributedString *atrrStr = [[NSAttributedString alloc] initWithString:aContent attributes:attr];
    
    cell.contentLb.attributedText = atrrStr;
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
