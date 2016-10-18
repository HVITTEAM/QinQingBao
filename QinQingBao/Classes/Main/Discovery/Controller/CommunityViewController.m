//
//  CommunityViewController.m
//  QinQingBao
//
//  Created by shi on 16/9/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommunityViewController.h"
#import "CardCell.h"
#import "SiglePicCardCell.h"
#import "CircleModel.h"
#import "CircleSticklistModel.h"
#import "PostsModel.h"
#import "PostsDetailViewController.h"
#import "BHBPopView.h"
#import "CXComposeViewController.h"
#import "PublicProfileViewController.h"

#define kHeadViewHeith 140
#define kTabViewHeight 50
#define kNewsCellHeight 50

#define kLeftBtnTag 1200
#define kRightBtnTag 1201

@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    PostsModel *selectedDeleteModel;
    NSIndexPath *selectedDeleteindexPath;

}

@property (strong, nonatomic) UITableView *tableView;
/**标签栏*/
@property (strong, nonatomic) UIView *tabView;
/**标签栏上的指示条*/
@property (strong, nonatomic) UIView *line;
/**自定义导航栏*/
@property (strong, nonatomic) UIView *navBar;
/**头部版块信息视图*/
@property (strong, nonatomic) UIView *headView;
/**图标*/
@property (weak, nonatomic) IBOutlet UIImageView *headIconView;
/**名称*/
@property (weak, nonatomic) IBOutlet UILabel *headTitleLb;
/**参与人数和帖子数*/
@property (weak, nonatomic) IBOutlet UILabel *numberLb;
/**版主*/
@property (weak, nonatomic) IBOutlet UILabel *ownerLb;

/**置顶数据源*/
@property (strong, nonatomic) NSMutableArray *zdPosts;
/**所有数据源*/
@property (strong, nonatomic) NSMutableArray *allPosts;
/**热点数据源*/
@property (strong, nonatomic) NSMutableArray *hotPosts;

/**当前是否选中所有标签*/
@property (assign, nonatomic) BOOL isAllData;
/**所有数据的分页数*/
@property (assign, nonatomic) NSInteger allPageNum;
/**热点数据的分页数*/
@property (assign, nonatomic) NSInteger hotPageNum;

@property (assign, nonatomic) CGFloat offsetYWhenBeginDrag;

@property (assign, nonatomic) CGFloat alphaWhenBeginDrag;

@property (strong, nonatomic) UIImageView *postView;

@end

@implementation CommunityViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HMColor(245, 245, 245);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.isAllData = YES;
    
    self.allPageNum = 1;
    self.hotPageNum = 1;
    
    [self setupUI];
    
    //加载所有数据和置顶数据
    [self loadSectionlistDataWithType:nil];
    [self loadSectionlistDataWithType:@2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupUI
{
    //UITableView
    UITableView *tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) style:UITableViewStyleGrouped];
    tbv.showsVerticalScrollIndicator = NO;
    tbv.contentInset = UIEdgeInsetsMake(kHeadViewHeith, 0, 0, 0);
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tbv];
    self.tableView = tbv;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];

    //头部视图
    UIView *headView = [[[NSBundle mainBundle] loadNibNamed:@"CommunityHeadView" owner:self options:nil] firstObject];
    headView.frame = CGRectMake(0, -kHeadViewHeith, MTScreenW, kHeadViewHeith);
    [self.tableView addSubview:headView];
    self.headView = headView;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.circleModel.avatar]];
    [self.headIconView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"pc_user"]];
    self.headTitleLb.text = self.circleModel.name;
    self.numberLb.text = [NSString stringWithFormat:@"参与人数:%@ 帖子:%@",self.circleModel.num_author,self.circleModel.num_article];
    self.ownerLb.text = [NSString stringWithFormat:@"版主:%@",self.circleModel.moderators];
    
    //自定义导航条
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0,0, MTScreenW, 64)];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.alpha = 0;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 23, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, MTScreenW, 30)];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor darkTextColor];
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.text = self.circleModel.name;
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MTScreenW, 0.5)];
    lv.backgroundColor = HMColor(230, 230, 230);
    [self.navBar addSubview:lv];
    [self.navBar addSubview:backBtn];
    [self.navBar addSubview:titleLb];
    [self.view addSubview:self.navBar];
    
    self.postView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"post_icon"]];
    self.postView.frame = CGRectMake((MTScreenW - 50) / 2, MTScreenH - 80, 70, 70);
    self.postView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postAction)];
    recognizer.numberOfTapsRequired= 1;
    recognizer.numberOfTouchesRequired = 1;
    [self.postView addGestureRecognizer:recognizer];
    [self.view addSubview:self.postView];
}

#pragma mark - gettter和setter方法
- (NSMutableArray *)allPosts
{
    if (!_allPosts) {
        _allPosts = [[NSMutableArray alloc] init];
    }
    
    return _allPosts;
}

- (NSMutableArray *)hotPosts
{
    if (!_hotPosts) {
        _hotPosts = [[NSMutableArray alloc] init];
    }
    
    return _hotPosts;
}

- (NSMutableArray *)zdPosts
{
    if (!_zdPosts) {
        _zdPosts = [[NSMutableArray alloc] init];
    }
    
    return _zdPosts;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (0 == section) {
        return self.zdPosts.count;
    }
    
    if (self.isAllData) {
        return self.allPosts.count;
    }
    
    return self.hotPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        static NSString *newsCellId = @"newsCell";
        UITableViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:newsCellId];
        if (!newsCell) {
            newsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsCellId];
            newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            newsCell.imageView.image = [UIImage imageNamed:@"zhiDing_icon"];
        }
        PostsModel *model = self.zdPosts[indexPath.row];
            
        newsCell.textLabel.text = model.subject;
        
        cell = newsCell;
    }else{
        CardCell *cardCell = [CardCell createCellWithTableView:tableView];
        
        PostsModel *model;
        if (self.isAllData) {
            model = self.allPosts[indexPath.row];
        }else{
            model = self.hotPosts[indexPath.row];
        }
        
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
            selectedDeleteindexPath = indexPath;
            [weakSelf attentionAction:model];
        };
        cell = cardCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return kNewsCellHeight;
    }
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.01;
    }
    
    return kTabViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == self.zdPosts.count) {
        return 0.01;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    }
    
    if (!self.tabView) {
        self.tabView = [self createTabView];
    }

    return self.tabView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    PostsDetailViewController *postsDetailVC = [[PostsDetailViewController alloc] init];
    PostsModel *postsModel;
    if (indexPath.section == 0) {
        postsModel = self.zdPosts[indexPath.row];
    }else if (self.isAllData) {
        postsModel = self.allPosts[indexPath.row];
    }else{
        postsModel = self.hotPosts[indexPath.row];
    }
    postsDetailVC.itemdata = postsModel;
    postsDetailVC.deletePostsSuccessBlock = ^{
        if (weakSelf.isAllData) {
            [self.allPosts removeObject:postsModel];
        }else{
            [self.hotPosts removeObject:postsModel];
        }
        [weakSelf.tableView reloadData];
    };
    
    [self.navigationController pushViewController:postsDetailVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -kHeadViewHeith) {
        self.headView.frame = CGRectMake(0, scrollView.contentOffset.y, MTScreenW, -scrollView.contentOffset.y);
        
    }else{
        self.headView.frame = CGRectMake(0, -kHeadViewHeith, MTScreenW, kHeadViewHeith);
    }
    
    //导航栏设置
    CGFloat tempAlpha = 0;
    CGFloat delta = 1.0 / 64;
    if (scrollView.contentOffset.y > self.offsetYWhenBeginDrag) {
        tempAlpha = self.alphaWhenBeginDrag + (scrollView.contentOffset.y - self.offsetYWhenBeginDrag) * delta;
        self.navBar.alpha = (tempAlpha <= 1.0?tempAlpha:1.0);
    }else if (scrollView.contentOffset.y < -64){
        tempAlpha = self.alphaWhenBeginDrag - (-64 - scrollView.contentOffset.y) * delta;
        self.navBar.alpha = (tempAlpha >=0?tempAlpha:0);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.offsetYWhenBeginDrag = scrollView.contentOffset.y;
    self.alphaWhenBeginDrag = self.navBar.alpha;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.postView.frame = CGRectMake((MTScreenW - 50) / 2, MTScreenH, 70, 70);
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.postView.frame = CGRectMake((MTScreenW - 50) / 2, MTScreenH - 80, 70, 70);
    }];
}

#pragma mark - 点击事件方法
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeTab:(UIButton *)sender
{
    UIButton *leftbtn = (UIButton *)[self.view viewWithTag:kLeftBtnTag];
    [leftbtn setTitleColor:HMColor(153, 153, 153) forState:UIControlStateNormal];
    UIButton *rightbtn = (UIButton *)[self.view viewWithTag:kRightBtnTag];
    [rightbtn setTitleColor:HMColor(153, 153, 153) forState:UIControlStateNormal];
    
    [sender setTitleColor:HMColor(112, 164, 38) forState:UIControlStateNormal];
    
    
    if (sender == leftbtn) {
        self.isAllData = YES;
        if (self.allPosts.count == 0) {
            [self loadSectionlistDataWithType:nil];
        }
        
    }else{
        self.isAllData = NO;
        if (self.hotPosts.count == 0) {
            [self loadSectionlistDataWithType:@1];
        }
    }
    
    [self.tableView reloadData];
    
    CGRect frame = self.line.frame;
    frame.origin.x = sender.frame.origin.x;
    frame.size.width = sender.frame.size.width;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.line.frame = frame;
    }];
}

#pragma mark - 加载数据网络相关
/**
 *  获取版块详细列表  版块内特殊标志的列表  热门：1；置顶：2  不传为全部
 */
- (void)loadSectionlistDataWithType:(NSNumber *)type
{
    NSMutableDictionary *params = [@{
                             @"sectionid":self.circleModel.sectionid,
                             @"page":@(10),
                             @"client":@"ios"
                             } mutableCopy];

    params[@"key"] = [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key;
    params[@"tag"] = type?type:nil;
    
    if (self.isAllData) {
        params[@"p"] = @(self.allPageNum);
    }else{
        params[@"p"] = @(self.hotPageNum);
    }

    [CommonRemoteHelper RemoteWithUrl:URL_Sectionlist parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [self.tableView.footer endRefreshing];
        
        
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)
        {
            
            if ([type isEqual:@1]) {//热门数据
                
                if([codeNum integerValue] == 17001 && self.hotPosts.count == 0)
                {
                    return [NoticeHelper AlertShow:@"当前板块没有数据" view:nil];
                }
                else if([codeNum integerValue] == 17001 && self.hotPosts.count > 0)
                {
                    return [NoticeHelper AlertShow:@"没有更多数据了" view:nil];
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                
            }else if ([type isEqual:@2]){ //置顶数据
                return;
                
            }else{
                //全部数据
                if([codeNum integerValue] == 17001 && self.allPosts.count == 0)
                {
                    return [NoticeHelper AlertShow:@"当前板块没有数据" view:nil];
                }
                else if([codeNum integerValue] == 17001 && self.allPosts.count > 0)
                {
                    return [NoticeHelper AlertShow:@"没有更多数据了" view:nil];
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
        }
        else
        {
            NSArray *datas = [PostsModel objectArrayWithKeyValuesArray:dict[@"datas"]];
            if (datas.count > 0) {
                if ([type isEqual:@1]) {//热门数据
                    [self.hotPosts addObjectsFromArray:datas];
                    self.hotPageNum++;
                }else if ([type isEqual:@2]){ //置顶数据
                    [self.zdPosts addObjectsFromArray:datas];
                }else{
                    //全部数据
                    [self.allPosts addObjectsFromArray:datas];
                    self.allPageNum++;
                }
                
                [self.tableView reloadData];
            }
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
    if (self.isAllData) {
        [self loadSectionlistDataWithType:nil];
    }else{
        [self loadSectionlistDataWithType:@1];
    }
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
    if ([model.is_myposts integerValue] == 1)//点击的是自己的帖子
    {
        return [self deleteAction:model];
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

#pragma mark - 发帖
- (void)postAction
{
    if ([SharedAppUtil checkLoginStates])
    {
        if ([[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id  isEqual: @"1"])
        {
            [BHBPopView showToView:self.view andImages:@[@"images.bundle/healthNews_icon",@"images.bundle/heart_brain_icon",@"images.bundle/fatigue_icon",@"images.bundle/liver_curing_icon"] andTitles:@[@"健康资讯",@"心脑血管",@"压力缓解",@"肝脏养护"] andSelectBlock:^(BHBItem *item) {
                // 弹出发微博控制器
                CXComposeViewController *compose = [[CXComposeViewController alloc] init];
                if ([item.title isEqualToString:@"健康资讯"])
                {
                    compose.fid = 39;
                }
                else if ([item.title isEqualToString:@"心脑血管"])
                {
                    compose.fid = 40;
                }
                else if ([item.title isEqualToString:@"压力缓解"])
                {
                    compose.fid = 41;
                }
                else if ([item.title isEqualToString:@"肝脏养护"])
                {
                    compose.fid = 42;
                }
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:compose];
                [self presentViewController:nav animated:YES completion:nil];
            }];
        }
        else
        {
            [BHBPopView showToView:self.view andImages:@[@"images.bundle/heart_brain_icon",@"images.bundle/fatigue_icon",@"images.bundle/liver_curing_icon"] andTitles:@[@"心脑血管",@"压力缓解",@"肝脏养护"] andSelectBlock:^(BHBItem *item) {
                // 弹出发微博控制器
                CXComposeViewController *compose = [[CXComposeViewController alloc] init];
                if ([item.title isEqualToString:@"心脑血管"])
                {
                    compose.fid = 40;
                }
                else if ([item.title isEqualToString:@"压力缓解"])
                {
                    compose.fid = 41;
                }
                else if ([item.title isEqualToString:@"肝脏养护"])
                {
                    compose.fid = 42;
                }
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:compose];
                [self presentViewController:nav animated:YES completion:nil];
            }];
            
        }
    }}

#pragma mark - 工具方法
- (UIView *)createTabView
{
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, kTabViewHeight)];
    tabView.backgroundColor = [UIColor whiteColor];
    
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, kTabViewHeight, MTScreenW, 0.5)];
    lv.backgroundColor = HMColor(235, 235, 235);
    [tabView addSubview:lv];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = kLeftBtnTag;
    [leftBtn setTitle:@"全部" forState:UIControlStateNormal];
    [leftBtn setTitleColor:HMColor(112, 164, 38) forState:UIControlStateNormal];
    [leftBtn sizeToFit];
    leftBtn.frame = CGRectMake(0.25 * MTScreenW - leftBtn.width / 2, 0, leftBtn.width, kTabViewHeight);
    [leftBtn addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.tag = kRightBtnTag;
    [rightBtn setTitle:@"热门" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HMColor(153, 153, 153) forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    rightBtn.frame = CGRectMake(0.75 * MTScreenW - rightBtn.width / 2, 0, rightBtn.width, kTabViewHeight);
    [rightBtn addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:rightBtn];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(leftBtn.x, kTabViewHeight - 3, leftBtn.width, 3)];
    self.line.backgroundColor = HMColor(112, 164, 38);
    [tabView addSubview:self.line];
    
    return tabView;
}

/**
 *  删除帖子
 */
#pragma mark - 导航栏事件

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSDictionary *params = @{@"tid":selectedDeleteModel.tid,
                                 @"client":@"ios",
                                 @"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key};
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_Get_delete_thread parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
            [HUD removeFromSuperview];
            id codeNum = [dict objectForKey:@"code"];
            if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            else
            {
                if (self.isAllData) {
                    [self.allPosts removeObjectAtIndex:selectedDeleteindexPath.row];

                }else{
                    [self.hotPosts removeObjectAtIndex:selectedDeleteindexPath.row];
                }
                [self.tableView deleteRowsAtIndexPaths:@[selectedDeleteindexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD removeFromSuperview];
            [NoticeHelper AlertShow:@"请求出错了" view:nil];
        }];
    }
}
/**
 *  删除帖子
 */
- (void)deleteAction:(PostsModel *)model
{
    if ([model.is_myposts integerValue] == 1)
    {
        selectedDeleteModel = model;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定删除该帖子，删除后将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
        [alertView show];
    }
}

@end
