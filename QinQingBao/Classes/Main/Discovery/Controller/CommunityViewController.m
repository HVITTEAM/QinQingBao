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

#define kHeadViewHeith 140
#define kTabViewHeight 50
#define kNewsCellHeight 50

#define kLeftBtnTag 1200
#define kRightBtnTag 1201

@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

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
    
    self.view.backgroundColor = HMGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.isAllData = YES;
    
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
    backBtn.frame = CGRectMake(15, 27, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"btn_dismissItem"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, MTScreenW, 30)];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor darkTextColor];
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.text = @"标题";
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MTScreenW, 0.5)];
    lv.backgroundColor = HMColor(230, 230, 230);
    [self.navBar addSubview:lv];
    [self.navBar addSubview:backBtn];
    [self.navBar addSubview:titleLb];
    [self.view addSubview:self.navBar];
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
    PostsDetailViewController *postsDetailVC = [[PostsDetailViewController alloc] init];
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
    
    if (scrollView.contentOffset.y > 0) {
        CGFloat delta = 1.0 / 64;
        self.navBar.alpha = scrollView.contentOffset.y * delta;
    }else{
        self.navBar.alpha = 0;
    }

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
                             @"page":@(3),
                             @"sys":@"",
                             @"client":@"",
                             @"key":@"",
                             } mutableCopy];

    params[@"tag"] = type?type:nil;
    
    if (self.isAllData) {
        params[@"p"] = @(self.allPageNum);
    }else{
        params[@"p"] = @(self.hotPageNum);
    }

    [CommonRemoteHelper RemoteWithUrl:URL_Sectionlist parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [self.tableView.footer endRefreshing];
        
        if ([dict[@"code"] integerValue] != 0) {
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            return;
        }
    
        NSArray *datas = [PostsModel objectArrayWithKeyValuesArray:dict[@"datas"]];
        
        if ([type isEqual:@1]) {//所有数据
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


@end
