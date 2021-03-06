//
//  PrivateLetterViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PrivateLetterViewController.h"
#import "PrivateLetterCell.h"
#import "AllpriletterModel.h"
#import "SendMsgViewController.h"
#import "MsgAndPushViewController.h"

@interface PrivateLetterViewController ()

@property (strong, nonatomic) NSMutableArray *dataProvider;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation PrivateLetterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pageNum = 1;
    
    [self initTableView];
    
    [self getAllPriletterList];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    
    [self.tableView initWithPlaceString:@"暂无消息" imgPath:@"placeholder-3"];
}

-(void)initTableView
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (NSMutableArray *)dataProvider
{
    if (!_dataProvider) {
        _dataProvider = [[NSMutableArray alloc] init];
    }
    return _dataProvider;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataProvider.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateLetterCell *cell = [PrivateLetterCell createCellWithTableView:tableView];
    cell.item = self.dataProvider[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllpriletterModel *item = self.dataProvider[indexPath.row];
    SendMsgViewController *view = [[SendMsgViewController alloc] init];
    view.authorid = item.authorid;
    view.otherName = item.author;
    [self.parentVC.navigationController pushViewController:view animated:YES];

}

#pragma mark - 网络相关
/**
 *  获取个人的所有私信
 */
- (void)getAllPriletterList
{
    //判断是否登录
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
    {
        return [self.tableView initWithPlaceString:PlaceholderStr_Login imgPath:@"placeholder-2"];
    }
    else if ([SharedAppUtil defaultCommonUtil].bbsVO == nil)
    {
        return [self.tableView initWithPlaceString:PlaceholderStr_Login imgPath:@"placeholder-2"];
    }
    
    NSDictionary *params = @{@"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                             @"client":@"ios",
                             @"p": @(self.pageNum),
                             @"page":@"10",};
    [CommonRemoteHelper RemoteWithUrl:URL_get_allpriletter parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [self.tableView.footer endRefreshing];
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)
        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"Msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
        }
        else
        {
            NSString *msgNum = [dict objectForKey:@"allnew"];
            NSLog(@"有%@条未读私信",msgNum);
            
            MsgAndPushViewController *vc = (MsgAndPushViewController *)self.parentVC;
            [vc setBadge:msgNum];
            NSArray *ar = [AllpriletterModel objectArrayWithKeyValuesArray:dict[@"datas"]];
            
            if (ar.count > 0) {
                [self.dataProvider addObjectsFromArray:ar];
                self.pageNum ++;
                [self.tableView reloadData];
            }
            
            if(self.dataProvider > 0){
                [self.tableView removePlace];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.footer endRefreshing];
        [NoticeHelper AlertShow:MTServiceError view:nil];
    }];
}

/**
 *  加载更多数据
 */
- (void)loadMoreDatas
{
    [self getAllPriletterList];
}

@end
