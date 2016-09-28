//
//  PrivateProfileViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/9.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PrivateProfileViewController.h"
#import "LoginInHeadView.h"

#import "ProfileTopCell.h"
#import "CollectTypeCell.h"

#import "OrderTableViewController.h"
#import "GoodsTypeViewController.h"
#import "EstimateViewController.h"
#import "MyAccountViewController.h"
#import "PersonalDataViewController.h"
#import "SettingViewController.h"

#import "MsgAndPushViewController.h"

#import "PostsDetailViewController.h"
#import "PostsModel.h"
#import "CardCell.h"

#import "BBSPersonalModel.h"
#import "MyRelationViewController.h"

#define headHeight MTScreenH*0.3


@interface PrivateProfileViewController ()<UIScrollViewDelegate>
{
    UILabel *titleLabel;
    
    BBSPersonalModel *personalInfo;
    
    UserInforModel *infoVO;
    NSString *iconUrl;
    
    NSMutableArray *postsArr;
    
    // 当前第几页
    NSInteger currentPageIdx;
}

@property(nonatomic,strong)LoginInHeadView *headView;

@end

@implementation PrivateProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initHeadView];
    
    [self setupRefresh];
    
    self.view.backgroundColor = HMGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.contentInset = UIEdgeInsetsMake(headHeight, 0, 40, 0);
    
    if (self.headView)
        self.headView.frame = CGRectMake(0, -headHeight, MTScreenW, headHeight);
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getDataProvider];
    
    [self getUserPosts];
    
    [self getUserFannum];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

/**
 *  初始化头部视图
 */
-(void)initHeadView
{
    if (self.headView)
    {
        [self.headView removeFromSuperview];
        self.headView = nil;
    }
    
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"LoginInHeadView" owner:self options:nil] lastObject];
    
    LoginInHeadView *headView = self.headView;
    // 显示个人资料
    headView.inforClick = ^(void){
        [self.navigationController pushViewController:[[PersonalDataViewController alloc] init] animated:YES];
    };
    
    [self.tableView addSubview:self.headView];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    UIButton *rightBtn0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightBtn0 addTarget:self action:@selector(navgationHandler:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn0.tag = 100;
    [rightBtn0 setBackgroundImage:[UIImage imageNamed:@"ic_msg.png"] forState:UIControlStateNormal];
    [rightBtn0 setBackgroundImage:[UIImage imageNamed:@"ic_msg.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarBtn0 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn0];
    
    UIButton *rightBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    rightBtn1.tag = 200;
    [rightBtn1 addTarget:self action:@selector(navgationHandler:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"pc_setup.png"] forState:UIControlStateNormal];
    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"pc_setup.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarBtn1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn1];
    
    self.navigationItem.rightBarButtonItems = @[rightBarBtn0,rightBarBtn1];
    
    self.navigationItem.title = @"";
    // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

#pragma mark 导航栏点击

-(void)navgationHandler:(UIButton *)sender
{
    switch (sender.tag) {
        case 200:
        {
            SettingViewController *vc = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 100:
        {
            MsgAndPushViewController *vc = [[MsgAndPushViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark 集成刷新控件

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    currentPageIdx = 0;
    postsArr = [[NSMutableArray alloc] init];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getUserPosts)];
}


#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y <= -headHeight)
    {
        CGRect frame = self.headView.frame;
        frame.size.height = -y;
        frame.origin.y = y;
        self.headView.frame = frame;
    }
    
    CGFloat alpha;
    if ((scrollView.contentOffset.y + headHeight) > 0) {
        alpha = (scrollView.contentOffset.y + headHeight) / 64;
    }else{
        alpha = 0;
    }
    
    //    UIImage *img = [UIImage imageNamed:@"red_line_and_shadow.png"];
    //    self.navigationController.navigationBar.alpha = alpha;
    
    if (titleLabel == nil)
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 62, 20)] ;
    titleLabel.text = infoVO.member_truename;
    titleLabel.alpha = alpha;
    //    self.navigationItem.titleView = titleLabel;
    
    UIImage *img = [UIImage imageWithColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (2 == section)
        return postsArr.count + 1;
    return 1;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return  80;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        ProfileTopCell *consumeCell = [ProfileTopCell creatProfileConsumeCellWithTableView:tableView];
        [consumeCell setZan:[personalInfo.all_recommends integerValue] fansnum:[personalInfo.count_fans integerValue] attentionnum:[personalInfo.count_attention integerValue]];
        consumeCell.tapConsumeCellBtnCallback = ^(ProfileTopCell *consumeCell,NSUInteger idx){
            
            if ([SharedAppUtil defaultCommonUtil].userVO == nil)
                return   [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
            
            if (idx == 100)
            {
                //                [NoticeHelper AlertShow:@"尚未开通,敬请期待！" view:nil];
            }
            else if (idx == 200)
            {
                MyRelationViewController *view = [[MyRelationViewController alloc] init];
                view.type = 1;
                view.uid = [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id;
                [self.navigationController pushViewController:view animated:YES];
            }
            else
            {
                MyRelationViewController *view = [[MyRelationViewController alloc] init];
                view.type = 2;
                view.uid = [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id;
                [self.navigationController pushViewController:view animated:YES];
            }
        };
        cell = consumeCell;
        
    }
    else if (indexPath.section == 1)
    {
        CollectTypeCell *collectTypeCell = [tableView dequeueReusableCellWithIdentifier:@"MTCollectTypeCell"];
        
        if(collectTypeCell == nil)
            collectTypeCell = [CollectTypeCell collectTypeCell];
        
        collectTypeCell.cellClick = ^(NSInteger cellTag){
            NSLog(@"%ld",(long)cellTag);
            [self typeClickHandler:cellTag];
        };
        
        cell = collectTypeCell;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"ConmmonCell"];
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ConmmonCell"];
            commoncell.textLabel.text = [NSString stringWithFormat:@"我的帖子  %ld",(long)[personalInfo.count_article integerValue]];
            commoncell.textLabel.font = [UIFont systemFontOfSize:15];
            commoncell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
            cell = commoncell;
        }
        else
        {
            CardCell *cardCell = [CardCell createCellWithTableView:tableView];
            [cardCell setPostsModel:postsArr[indexPath.row - 1]];
            
            // 头像点击 进入个人信息界面
            cardCell.portraitClick = ^(PostsModel *item)
            {
                
            };
            cell = cardCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - cellClick

-(void)typeClickHandler:(NSInteger)type
{
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
        return [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
    
    Class class;
    
    switch (type) {
        case 0:
            class = [MyAccountViewController class];
            break;
        case 1:
            class = [EstimateViewController class];
            break;
        case 2:
            class = [GoodsTypeViewController class];
            break;
        case 3:
            class = [OrderTableViewController class];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:[[class alloc] init] animated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        PostsDetailViewController *view = [[PostsDetailViewController alloc] init];
        [view setItemdata:postsArr[indexPath.row-1]];
        [self.navigationController pushViewController:view animated:YES];
    }
}

#pragma mark -- 与后台数据交互模块

/**
 *  获取BBS账号信息
 */
-(void)getUserFannum
{
    if (![SharedAppUtil defaultCommonUtil].userVO)
        return;
    [CommonRemoteHelper RemoteWithUrl:URL_Get_personaldetail parameters: @{@"uid" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                                                                           @"client" : @"ios",
                                                                           @"key" :[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         personalInfo = [BBSPersonalModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         
                                         LoginInHeadView *headView = (LoginInHeadView *)self.headView;
                                         
                                         [headView initWithName:infoVO.member_truename.length > 0 ? infoVO.member_truename : @"请完善资料" professional:personalInfo.grouptitle isfriend:personalInfo.is_home_friend is_mine:personalInfo.is_mine];
                                         
                                         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}

/**
 *  获取发帖数据
 */
-(void)getUserPosts
{
    currentPageIdx ++;
    NSDictionary *paramDict = [[NSDictionary alloc] init];
    if (![SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key)
        return [self.tableView.footer endRefreshing];
    
    paramDict = @{@"uid" :[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                  @"client" : @"ios",
                  @"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"page" : @"10"};
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_personallist parameters: paramDict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.footer endRefreshing];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)
                                     {
                                         if([codeNum integerValue] == 17001 && postsArr.count == 0)
                                         {
                                             return ;
//                                             [NoticeHelper AlertShow:@"您还没有发帖" view:nil]
                                         }
                                         else if([codeNum integerValue] == 17001 && postsArr.count > 0)
                                         {
                                             return;
//                                             return [NoticeHelper AlertShow:@"没有更多数据了" view:nil];
                                         }
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSArray *arr =[PostsModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         
                                         if (arr.count == 0 && currentPageIdx == 1)
                                         {
                                             CX_Log(@"没有新的发帖数据");
                                         }
                                         else if (arr.count == 0 && currentPageIdx > 1)
                                         {
                                             currentPageIdx --;
                                             //                                             [self.view showNonedataTooltip];
                                         }
                                         
                                         [postsArr addObjectsFromArray:[arr copy]];
                                         
                                         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.footer endRefreshing];
                                     
                                 }];
}

/**
 *  获取数据
 */
-(void)getDataProvider
{
    if (![SharedAppUtil defaultCommonUtil].userVO)
        return;
    [CommonRemoteHelper RemoteWithUrl:URL_GetUserInfor parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         if ([di count] != 0)
                                         {
                                             infoVO = [UserInforModel objectWithKeyValues:di];
                                             iconUrl = infoVO.member_avatar;
                                             
                                             // 显示个人资料
                                             LoginInHeadView *headView = (LoginInHeadView *)self.headView;
                                             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Icon,iconUrl]];
                                             [headView.userIcon sd_setImageWithURL:url placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
                                             // [headView.loginBtn setTitle:[NSString stringWithFormat:@"%@",infoVO.member_truename] forState:UIControlStateNormal];
                                             
                                             [headView initWithName:infoVO.member_truename.length > 0 ? infoVO.member_truename : @"请完善资料" professional:personalInfo.grouptitle isfriend:personalInfo.is_home_friend is_mine:personalInfo.is_mine];
                                         }
                                         else
                                             [NoticeHelper AlertShow:@"个人资料为空!" view:self.view];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}
@end
