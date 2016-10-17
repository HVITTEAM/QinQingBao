//
//  DiscoveryViewController.m
//  QinQingBao
//
//  Created by shi on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "LoopImageView.h"
#import "ScrollMenuTableCell.h"
#import "CommunityViewController.h"
#import "CircleModel.h"
#import "PostsDetailViewController.h"
#import "HomePicModel.h"
#import "CardCell.h"
#import "ShopDetailViewController.h"
#import "MarketDeatilViewController.h"
#import "MarketDeatilViewController.h"
#import "AdvertisementController.h"
#import "PostsModel.h"

#import "PublicProfileViewController.h"
#import "SearchViewController.h"
#import "MarketViewController.h"

@interface DiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *healthCommunityDatas;    //健康圈数据

@property (strong, nonatomic) NSArray *advDatas;     //轮播图数据

@property (strong, nonatomic) NSMutableArray *postsDatas;     //热门帖子数据

@property (assign, nonatomic) NSInteger pageNum;     //分页数

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum = 1;
    
    [self setupUI];
    
    [self loadCirclelist];
    
    [self getAdvertisementpic];
    
    [self loadFlaglist];
}

- (void)setupUI
{
    //导航栏
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    UITextField *searhField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MTScreenW - 20, 30)];
    searhField.placeholder = @"输入搜索关键字";
    searhField.borderStyle = UITextBorderStyleRoundedRect;
    searhField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searhField.font = [UIFont systemFontOfSize:14];
    searhField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 16, 16)];
    imgView.image = [UIImage imageNamed:@"search_gray"];
    [leftView addSubview:imgView];
    searhField.leftView = leftView;
    searhField.delegate = self;
    self.navigationItem.titleView = searhField;
    
    //UITableView
    UITableView *tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) style:UITableViewStyleGrouped];
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.backgroundColor = HMColor(245, 245, 245);
    tbv.separatorInset = UIEdgeInsetsZero;
    tbv.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:tbv];
    self.tableView = tbv;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    self.tableView.separatorColor = [UIColor colorWithRGB:@"dcdcdc"];
    
    __weak typeof(self) weakSelf = self;
    //轮播图
    LoopImageView *loopView = [[LoopImageView alloc] init];
    loopView.bounds = CGRectMake(0, 0, MTScreenW, (int)(MTScreenW / 3));
    loopView.tapLoopImageCallBack= ^(NSInteger idx){
        [weakSelf onClickImage:idx];
    };
    tbv.tableHeaderView = loopView;
}

- (NSArray *)healthCommunityDatas
{
    if (!_healthCommunityDatas) {
        _healthCommunityDatas = [[NSArray alloc] init];
    }
    
    return _healthCommunityDatas;
}

- (NSMutableArray *)postsDatas
{
    if (!_postsDatas) {
        _postsDatas = [[NSMutableArray alloc] init];
    }
    
    return _postsDatas;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.postsDatas.count + 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0){
        static NSString *cellId = @"titleCellId";
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = @"健康检测";
                break;
            case 1:
                cell.textLabel.text = @"健康圈";
                break;
            default:
                cell.textLabel.text = @"热门帖子";
                break;
        }
        
    }else if (indexPath.row == 1 && indexPath.section != 2){
        ScrollMenuTableCell * menuCell = [ScrollMenuTableCell createCellWithTableView:tableView];
        menuCell.row = 1;
        menuCell.col = 4;
        menuCell.colSpace = 30;
        if (indexPath.section == 0) {
            //健康检测
            menuCell.margin = UIEdgeInsetsMake(10, 10, 10, 10);
            menuCell.shouldShowIndicator = NO;
            menuCell.datas = @[@{KScrollMenuTitle:@"心脑血管",KScrollMenuImg:@"xnxg_icon"},
                               @{KScrollMenuTitle:@"精英压力",KScrollMenuImg:@"jyyl_icon"},
                               @{KScrollMenuTitle:@"肝脏排毒",KScrollMenuImg:@"gzpd_icon"},
                               @{KScrollMenuTitle:@"其他",KScrollMenuImg:@"qt_icon"}
                               ];
            menuCell.selectMenuItemCallBack = ^(NSInteger idx){
                //跳转服务市场
                
                NSString *title = nil;
                NSString *tid = nil;
                switch (idx) {
                    case 0:
                        title = @"心脑血管";
                        tid = @"44";
                        break;
                    case 1:
                        title = @"精英压力";
                        tid = @"45";
                        break;
                    case 2:
                        title = @"肝脏排毒";
                        tid = @"46";
                        break;
                    default:
                        title = @"其他";
                        tid = @"47";
                        break;
                }
                
                MarketViewController *marketListVC = [[MarketViewController alloc] init];
                marketListVC.navTitle = title;
                marketListVC.tid = tid;
                [weakSelf.navigationController pushViewController:marketListVC animated:YES];
            };
        }else{
            //健康圈
            if (self.healthCommunityDatas.count > 4) {
                menuCell.shouldShowIndicator = YES;
                menuCell.margin = UIEdgeInsetsMake(10, 10, 0, 10);
            }else{
                menuCell.shouldShowIndicator = NO;
                menuCell.margin = UIEdgeInsetsMake(10, 10, 10, 10);
            }
            
            NSMutableArray *ar = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.healthCommunityDatas.count; i++) {
                CircleModel *model = self.healthCommunityDatas[i];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                dict[KScrollMenuTitle] = model.name;
                dict[KScrollMenuImg] = model.avatar;
                [ar addObject:dict];
            }
            
            menuCell.datas = ar;
            menuCell.selectMenuItemCallBack = ^(NSInteger idx){
                CircleModel *model = weakSelf.healthCommunityDatas[idx];
                CommunityViewController *communityVC = [[CommunityViewController alloc] init];
                communityVC.circleModel = model;
                [weakSelf.navigationController pushViewController:communityVC animated:YES];
            };
            
        }
        
        cell = menuCell;
    }else{
        CardCell *cardCell = [CardCell createCellWithTableView:tableView];
        PostsModel *model = self.postsDatas[indexPath.row - 1];
        [cardCell setPostsModel:model];
        
        // 头像点击 进入个人信息界面
        cardCell.portraitClick = ^(PostsModel *item)
        {
            PublicProfileViewController *view = [[PublicProfileViewController alloc] init];
            view.uid = item.authorid;
            [self.navigationController pushViewController:view animated:YES];
        };
        cardCell.indexpath = indexPath;
        cardCell.attentionBlock = ^(PostsModel *model){
            [weakSelf attentionAction:model];
        };
        cell = cardCell;
    }

    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 40;
    }else if (indexPath.section == 0){
        return 90;
    }else if (indexPath.section == 1) {
        if (self.healthCommunityDatas.count > 4) {
            return 110;
        }else{
            return 90;
        }
    }
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 2 && indexPath.row != 0) {
        PostsDetailViewController *detailVC = [[PostsDetailViewController alloc] init];
        PostsModel *postsModel = self.postsDatas[indexPath.row - 1];
        detailVC.itemdata = postsModel;
        detailVC.deletePostsSuccessBlock = ^{
            [weakSelf.postsDatas removeObject:postsModel];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - 网络相关
/**
 * 获取健康圈数据
 **/
- (void)loadCirclelist
{
    NSDictionary *params = @{
                             @"circleid":@"38"
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_Circle parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
    
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:@"出错" view:nil];
            return;
        }

        self.healthCommunityDatas = [CircleModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        NSIndexSet *idxSet = [NSIndexSet indexSetWithIndex:1];
        [self.tableView reloadSections:idxSet withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/**
 * 获取热门帖子数据  标识位【推荐贴：1；热门帖：2；说说：3  根据帖子标题查询帖子列表：4】
 **/
- (void)loadFlaglist
{
    NSMutableDictionary *params = [@{
                             @"flag":@2,
                             @"p": @(self.pageNum),
                             @"page":@(10),
                             @"client":@"ios"
                             }mutableCopy];
    params[@"key"] = [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key;
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_flaglist parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [self.tableView.footer endRefreshing];
        
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            return;
        }
        
        NSArray *datas = [PostsModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        if (datas.count > 0) {
            [self.postsDatas addObjectsFromArray:datas];
            self.pageNum++;
            
//            [self.tableView reloadData];
            NSIndexSet *idxSet = [NSIndexSet indexSetWithIndex:2];
            [self.tableView reloadSections:idxSet withRowAnimation:UITableViewRowAnimationNone];
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
    [self loadFlaglist];
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
 * 获取轮播图片
 **/
-(void)getAdvertisementpic
{
    [CommonRemoteHelper RemoteWithUrl:URL_Advertisementpic parameters:nil type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {

        if([dict[@"code"] integerValue] != 0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return ;
        }
        
        self.advDatas = [HomePicModel objectArrayWithKeyValuesArray:dict[@"datas"][@"data"]];
    
        NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.advDatas.count; i++) {
            HomePicModel *model = self.advDatas[i];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_AdvanceImg,model.bc_value];
            [imageUrls addObject:urlStr];
        }
        LoopImageView *loopView = (LoopImageView *)self.tableView.tableHeaderView;
        loopView.imageUrls = imageUrls;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"轮播图获取失败!" view:self.view];
    }];
}

#pragma mark - 事件方法
/**
 *  轮播广告点击事件
 */
-(void)onClickImage:(NSInteger)idx
{
    HomePicModel *item = self.advDatas[idx];
    if (item.bc_article_url.length == 0)
        return;
    
    // 43 超声理疗 44 精准健康监测分析 45疾病易感性基因检测
    
    if ([item.bc_type_app_id isEqualToString:@"43"])
    {
        ShopDetailViewController *view = [[ShopDetailViewController alloc] init];
        view.iid = item.bc_item_id;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
        
    }
    else if ([item.bc_type_app_id isEqualToString:@"44"])
    {
        MarketDeatilViewController *view = [[MarketDeatilViewController alloc] init];
        view.iid = item.bc_item_id;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else if ([item.bc_type_app_id isEqualToString:@"45"])
    {
        MarketDeatilViewController *view = [[MarketDeatilViewController alloc] init];
        view.iid = item.bc_item_id;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        AdvertisementController *adver = [[AdvertisementController alloc] init];
        adver.item = item;
        [self.navigationController pushViewController:adver animated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SearchViewController *searchVc = [[SearchViewController alloc] init];
    searchVc.type = SearchTypePosts;
    [self.navigationController pushViewController:searchVc animated:YES];
    return NO;
}

@end
