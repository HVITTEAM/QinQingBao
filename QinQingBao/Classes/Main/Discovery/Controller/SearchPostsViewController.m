//
//  SearchPostsViewController.m
//  QinQingBao
//
//  Created by shi on 16/9/28.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SearchPostsViewController.h"
#import "CardCell.h"
#import "PostsModel.h"
#import "PublicProfileViewController.h"
#import "PostsDetailViewController.h"

@interface SearchPostsViewController ()

@property (strong, nonatomic) NSMutableArray *dataProvider;

@property (assign, nonatomic) NSInteger pageNum;     //分页数

@property (assign, nonatomic) BOOL isFirstLoad;

@end

@implementation SearchPostsViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageNum = 1;
    self.isFirstLoad = YES;
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HMColor(245, 245, 245);
    [self.tableView initWithPlaceString:@"暂无数据" imgPath:@"placeholder-1"];
    
    self.navigationItem.title = @"搜索结果";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadFlaglist];
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
    __weak typeof (self) weakSelf = self;
    CardCell *cardCell = [CardCell createCellWithTableView:tableView];
    PostsModel *model = self.dataProvider[indexPath.row];
    [cardCell setPostsModel:model];
    
    // 头像点击 进入个人信息界面
    cardCell.portraitClick = ^(PostsModel *item)
    {
        PublicProfileViewController *view = [[PublicProfileViewController alloc] init];
        view.uid = item.authorid;
        [weakSelf.navigationController pushViewController:view animated:YES];
    };
    
    cardCell.indexpath = indexPath;
    cardCell.attentionBlock = ^(PostsModel *model){
        [weakSelf attentionAction:model];
    };
    
    return cardCell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    PostsDetailViewController *detailVC = [[PostsDetailViewController alloc] init];
    PostsModel *postsModel = self.dataProvider[indexPath.row];
    detailVC.itemdata = postsModel;
    detailVC.deletePostsSuccessBlock = ^{
        [weakSelf.dataProvider removeObject:postsModel];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

/**
 * 获取热门帖子数据  标识位【推荐贴：1；热门帖：2；说说：3  根据帖子标题查询帖子列表：4】
 **/
- (void)loadFlaglist
{
    if (self.isFirstLoad) {
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        self.isFirstLoad = NO;
    }
    NSMutableDictionary *params = [@{
                                     @"flag":@4,
                                     @"p": @(self.pageNum),
                                     @"page":@(10),
                                     @"client":@"ios"
                                     }mutableCopy];
    params[@"key"] = [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key;
    params[@"subjectname"] = self.keyWords;
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_flaglist parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.tableView.footer endRefreshing];
        
        if ([dict[@"code"] integerValue] != 0) {
//            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            return;
        }
        
        NSArray *datas = [PostsModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        if (datas.count > 0) {
            [self.dataProvider addObjectsFromArray:datas];
            self.pageNum++;
            
            [self.tableView reloadData];
            
            if(self.dataProvider > 0){
                [self.tableView removePlace];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.tableView.footer endRefreshing];
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}


/**
 *  加关注与取消关注，add是加关注，del是取消关注
 */
- (void)attentionAction:(PostsModel *)model
{
    //判断是否登录
    if (![SharedAppUtil checkLoginStates]) {
        return;
    }
    
    NSString *type = @"add";
    if ([model.is_home_friend integerValue] != 0) {
        type = @"del";
    }
    
    NSDictionary *params = @{
                             @"action":type,
                             @"uid": [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                             @"rel":model.authorid,
                             @"client":@"ios",
                             @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key
                             };
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_attention_do parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [HUD removeFromSuperview];
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            if ([type isEqualToString:@"add"]) {
                model.is_home_friend = @"1";
            }else{
                model.is_home_friend = @"0";
            }
            NSString *str = [[dict objectForKey:@"datas"] objectForKey:@"message"];
            [NoticeHelper AlertShow:str view:nil];
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
}

/**
 *  加载更多数据
 */
- (void)loadMoreDatas
{
    [self loadFlaglist];
}

@end
