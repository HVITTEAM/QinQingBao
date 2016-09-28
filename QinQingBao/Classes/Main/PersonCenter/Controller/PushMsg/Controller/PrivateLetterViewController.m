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

@interface PrivateLetterViewController ()

@property (strong, nonatomic) NSMutableArray *dataProvider;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation PrivateLetterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pageNum = 1;
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    
    [self initTableView];
    
    [self getAllPriletterList];
    
}

-(void)initTableView
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
//    [self.view initWithPlaceString:PlaceholderStr_Letter imgPath:@"placeholder-3.png"];
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

#pragma mark - 网络相关
/**
 *  获取个人的所有私信
 */
- (void)getAllPriletterList
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates]) {
        return;
    }
    
    NSDictionary *params = @{
                             @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                             @"client":@"ios",
                             @"p": @(self.pageNum),
                             @"page":@"20",
                             };
    [CommonRemoteHelper RemoteWithUrl:URL_get_allpriletter parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [self.tableView.footer endRefreshing];
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            NSArray *ar = [AllpriletterModel objectArrayWithKeyValuesArray:dict[@"datas"]];
            [self.dataProvider addObjectsFromArray:ar];
            self.pageNum ++;
            
//            if (self.dataProvider.count > 0) {
//                [self.view removePlace];
//            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.footer endRefreshing];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
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
