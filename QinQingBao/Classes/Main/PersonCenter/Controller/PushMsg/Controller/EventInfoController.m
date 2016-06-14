//
//  EventInfoController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/5/31.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EventInfoController.h"
#import "EventMsgModel.h"
#import "NewsCell.h"
#import "NotificationCell.h"
#import "LogisticNotificationCell.h"
#import "NoticeHelper.h"
#import "PushMsgModel.h"
#import "NewsDetailViewControler.h"
#import "DeliverViewController.h"

@interface EventInfoController ()
{
    NSMutableArray *dataProvider;
}

@property (assign,nonatomic)NSUInteger nextPageNumber;

@end

@implementation EventInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataProvider = [[NSMutableArray alloc] init];
    
    //默认加载第一页
    self.nextPageNumber = 1;
    
    self.view.backgroundColor  = HMGlobalBg;
    //    MJRefreshAutoNormalFooter  MJRefreshBackNormalFooter
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadMoreData];
}

/** 屏蔽tableView的样式 */
- (id)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return [self initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataProvider.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *commonCell = nil;
    
    if (self.type == MessageTypeEventinfo || self.type == MessageTypeHealthTips) {
        NewsCell *newsCell = [NewsCell createCellWithTableView:tableView];
        [newsCell setDataWithMode:dataProvider[indexPath.section]];
        commonCell = newsCell;
    }else if (self.type == MessageTypePushMsg){
        NotificationCell *msgCell = [NotificationCell createCellWithTableView:tableView];
        [msgCell setDataWithModel:dataProvider[indexPath.section]];
        commonCell = msgCell;
    }else{
        LogisticNotificationCell *logisticCell = [LogisticNotificationCell createCellWithTableView:tableView];
        [logisticCell setDataWithModel:dataProvider[indexPath.section]];
        commonCell = logisticCell;
    }
    return commonCell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == MessageTypeEventinfo || self.type == MessageTypeHealthTips) {
        return 320;
    }else if (self.type == MessageTypePushMsg){
        return 150;
    }else{
        return 190;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == MessageTypeEventinfo || self.type == MessageTypeHealthTips || self.type == MessageTypePushMsg)
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }else{
        return 190;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((MTScreenW - 120)/2, 15, 120, 23)];
    
    if (self.type == MessageTypeEventinfo || self.type == MessageTypeHealthTips) {
        EventMsgModel *model  = dataProvider[section];
        lab.text = [model.s_push_time substringToIndex:16];
    }else if (self.type == MessageTypePushMsg || self.type == MessageTypeLogistics){
        PushMsgModel *model  = dataProvider[section];
        lab.text = [model.push_time substringToIndex:16];
    }
    
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 4;
    lab.backgroundColor = HMColor(198, 198, 198);
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    return view;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == MessageTypeEventinfo || self.type == MessageTypeHealthTips)
    {
        EventMsgModel *model  = dataProvider[indexPath.section];
        NewsDetailViewControler *view = [[NewsDetailViewControler alloc] init];
        NSString *url;
        if (![SharedAppUtil defaultCommonUtil].userVO)
            url = [NSString stringWithFormat:@"%@/admin/manager/index.php/family/article_detail/%@?key=cxjk&like",URL_Local,model.msg_artid];
        else
            url = [NSString stringWithFormat:@"%@/admin/manager/index.php/family/article_detail/%@?key=%@&like",URL_Local,model.msg_artid,[SharedAppUtil defaultCommonUtil].userVO.key];
        view.url = url;
        [self.navigationController pushViewController:view animated:YES];
    }else if (self.type == MessageTypeLogistics){
        PushMsgModel *model  = dataProvider[indexPath.section];
        DeliverViewController *deliverVC = [[DeliverViewController alloc] init];
        deliverVC.orderId = model.sys_relevant_id;
        [self.navigationController pushViewController:deliverVC animated:YES];
    }
}

#pragma mark - 网络相关
-(void)loadMoreData
{
    //活动资讯、健康小贴士、通知消息
    [self getDadaProvider];
}

/**
 *  根据类别获取不同的数据源 - 活动资讯、健康小贴士、通知消息
 */
-(void)getDadaProvider
{
    NSInteger infotype = self.type + 1;
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_get_systemmsginfos_by_type parameters: @{@"type" : @(infotype),
                                                                                   @"page" : @10,
                                                                                   @"client" : @"ios",
                                                                                   @"p" : @(self.nextPageNumber),
                                                                                   @"key":[SharedAppUtil defaultCommonUtil].userVO ? [SharedAppUtil defaultCommonUtil].userVO.key : @""}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                                     if (self.tableView.footer.isRefreshing) {
                                         [self.tableView.footer endRefreshing];
                                         
                                     }
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         //暂无数据
                                         if ([codeNum isEqualToString:@"17001"])
                                             return [self.tableView initWithPlaceString:@"暂无数据"];
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSArray *newDatas = [[NSArray alloc] init];
                                         if (self.type == MessageTypeEventinfo || self.type == MessageTypeHealthTips) {
                                             newDatas =[EventMsgModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         }else if (self.type == MessageTypePushMsg || self.type == MessageTypeLogistics){
                                             newDatas =[PushMsgModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         }
                                         
                                         [dataProvider addObjectsFromArray:newDatas];
                                         self.nextPageNumber ++;
                                         [self.tableView reloadData];
                                     }
                                     
                                     if (dataProvider.count == 0) {
                                         [self.tableView initWithPlaceString:@"暂无数据"];
                                     }else{
                                         [self.tableView removePlace];
                                     }
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                                     if (self.tableView.footer.isRefreshing) {
                                         [self.tableView.footer endRefreshing];
                                     }
                                     [NoticeHelper AlertShow:@"数据获取失败，请检查网络是否正常！" view:nil];
                                 }];
    
}

@end
