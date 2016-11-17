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

#import "HealthPlanController.h"
#import "OrderTableViewController.h"
#import "GoodsTypeViewController.h"
#import "EstimateViewController.h"
#import "MyAccountViewController.h"
#import "PersonalDataViewController.h"
#import "SettingViewController.h"
#import "HealthArchiveListController.h"

#import "MsgAndPushViewController.h"

#import "PostsDetailViewController.h"
#import "PostsModel.h"
#import "CardCell.h"

#import "BBSPersonalModel.h"
#import "MyRelationViewController.h"
#import "MyPostsViewController.h"

#define headHeight MTScreenH*0.3


@interface PrivateProfileViewController ()<UIScrollViewDelegate,HeadRefleshDelegate>
{
    UILabel *titleLabel;
    
    BBSPersonalModel *personalInfo;
    
    UserInforModel *infoVO;
    NSString *iconUrl;
    
    NSMutableArray *postsArr;
    
    // 当前第几页
    NSInteger currentPageIdx;
    
    UIButton *rightBtn0;
    UIButton *rightBtn1;
    
    PostsModel *selectedDeleteModel;
    
    NSIndexPath *selectedDeleteindexPath;
}

@property(nonatomic,strong)LoginInHeadView *headView;

/**自定义导航栏*/
@property (strong, nonatomic) UIView *navBar;
@end

@implementation PrivateProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initHeadView];
    
    [self setupRefresh];
    
    [self refleshData];
    
    self.view.backgroundColor = HMGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //注册重新登录成功监听
    [MTNotificationCenter addObserver:self selector:@selector(refleshDataByLogin) name:MTReLogin object:nil];
    
    //注册注销监听
    [MTNotificationCenter addObserver:self selector:@selector(refleshDataByLogin) name:MTLoginout object:nil];
    
    //注册寸欣账户登录信息超时监听
    [MTNotificationCenter addObserver:self selector:@selector(loginTimeout) name:MTLoginTimeout object:nil];
    
    self.tableView.contentInset = UIEdgeInsetsMake(headHeight, 0, 40, 0);
    
    if (self.headView)
        self.headView.frame = CGRectMake(0, -headHeight, MTScreenW, headHeight);
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getDataProvider];
    
    [self getAllPriletterList];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

// 登录超时
-(void)loginTimeout
{
    personalInfo = nil;
    LoginInHeadView *headView = self.headView;
    
    [headView.userIcon sd_setImageWithURL:nil placeholderImage:[UIImage imageWithName:@"pc_user"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    [headView initWithName:@"请登录" professional:@"" isfriend:@"" is_mine:@"1"];
    
    [postsArr removeAllObjects];
    [self.tableView reloadData];
}

-(void)refleshDataByLogin
{
    personalInfo = nil;
    [postsArr removeAllObjects];
    [self.tableView reloadData];
    
    [self refleshData];
}

/**
 * 刷新帖子数据
 */
-(void)refleshData
{
    currentPageIdx = 1;
    
    personalInfo = nil;
    [postsArr removeAllObjects];
    [self getUserPosts];
    
    [self getUserFannum];
    
    [self getAllPriletterList];
}

/**
 * 结束刷新帖子数据
 */
-(void)endrefleshData
{
    [self.headView setStates:RefreshViewStateNormal];
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
    self.headView.delegate = self;
    
    LoginInHeadView *headView = self.headView;
    // 显示个人资料
    headView.inforClick = ^(void){
        [self.navigationController pushViewController:[[PersonalDataViewController alloc] init] animated:YES];
    };
    
    [self.tableView insertSubview:self.headView atIndex:0];
    
    //自定义导航条
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0 ,-headHeight-20, MTScreenW, 64)];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.alpha = 0;
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, MTScreenW, 30)];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor darkTextColor];
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.text = @"个人中心";
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MTScreenW, 0.5)];
    lv.backgroundColor = HMColor(230, 230, 230);
    [self.navBar addSubview:lv];
    [self.navBar addSubview:titleLb];
    [self.view addSubview:self.navBar];
    
    [self initNavigation];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    if (!rightBtn0)
        rightBtn0 = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 35,25 - headHeight, 24, 24)];
    [rightBtn0 addTarget:self action:@selector(navgationHandler:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn0.tag = 100;
    [rightBtn0 setBackgroundImage:[UIImage imageNamed:@"ic_msg.png"] forState:UIControlStateNormal];
    [rightBtn0 setBackgroundImage:[UIImage imageNamed:@"ic_msg.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:rightBtn0];
    
    if (!rightBtn1)
        rightBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 70, 25 - headHeight, 24, 24)];
    rightBtn1.tag = 200;
    [rightBtn1 addTarget:self action:@selector(navgationHandler:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"pc_setup.png"] forState:UIControlStateNormal];
    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"pc_setup.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:rightBtn1];
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
    currentPageIdx = 1;
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
    
    rightBtn0.y = 25 + scrollView.contentOffset.y;
    rightBtn1.y = 25 + scrollView.contentOffset.y;
    
    
    if (alpha >0.5)
    {
        rightBtn1.hidden = YES;
        rightBtn0.hidden = YES;
    }
    else
    {
        rightBtn1.hidden = NO;
        rightBtn0.hidden = NO;
    }
    
    self.navBar.y = scrollView.contentOffset.y;
    self.navBar.alpha = alpha;
    
    // 下拉超过50像素
    if (self.headView.states !=RefreshViewStateRefreshing &&scrollView.contentOffset.y + headHeight < -50)
    {
        self.headView.refleshBtn.alpha = 1;
        [self.headView updateRefreshHeaderWithOffsetY:y scrollView:self.tableView];
        
    }
    else if(self.headView.states !=RefreshViewStateRefreshing)
    {
        self.headView.refleshBtn.alpha = 0;
    }
}

#pragma mark HeadRefleshDelegate

- (void)refleshWithStates:(RefreshViewState)states
{
    if (states == RefreshViewStateRefreshing)
    {
        [self refleshData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (2 == section)
    //        return 6;
    return 6;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 1)
    //        return  80;
    //    else
    return 50;
    //    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //    return cell.height;
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
    
    if (indexPath.section == 2)
    {
        ProfileTopCell *consumeCell = [ProfileTopCell creatProfileConsumeCellWithTableView:tableView];
        [consumeCell setZan:[personalInfo.all_recommends integerValue] fansnum:[personalInfo.count_fans integerValue] attentionnum:[personalInfo.count_attention integerValue]];
        consumeCell.tapConsumeCellBtnCallback = ^(ProfileTopCell *consumeCell,NSUInteger idx){
            
            //判断是否登录
            if (![SharedAppUtil checkLoginStates])
                return;
            
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
    else if (indexPath.section == 0)
    {
        UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"ConmmonCell"];
        if (commoncell == nil)
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ConmmonCell"];
        commoncell.textLabel.font = [UIFont systemFontOfSize:16];
        commoncell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
        commoncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = commoncell;
        
        switch (indexPath.row) {
            case 0:
                commoncell.textLabel.text = @"我的账户";
                commoncell.imageView.image = [UIImage imageNamed:@"type1.png"];
                break;
            case 1:
                commoncell.textLabel.text = @"我的商品";
                commoncell.imageView.image = [UIImage imageNamed:@"type3.png"];
                break;
            case 2:
                commoncell.textLabel.text = @"我的服务";
                commoncell.imageView.image = [UIImage imageNamed:@"type4.png"];
                break;
            case 3:
                commoncell.textLabel.text = @"我的评估";
                commoncell.imageView.image = [UIImage imageNamed:@"type2.png"];
                break;
            case 4:
                commoncell.textLabel.text = @"健康档案";
                commoncell.imageView.image = [UIImage imageNamed:@"type5.png"];
                break;
            case 5:
                commoncell.textLabel.text = @"我的帖子";
                commoncell.imageView.image = [UIImage imageNamed:@"type1.png"];
                break;
            default:
                break;
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
        case 3:
            class = [EstimateViewController class];
            break;
        case 1:
            class = [GoodsTypeViewController class];
            break;
        case 2:
            class = [OrderTableViewController class];
            break;
        case 4:
            class = [HealthArchiveListController class];
            break;
        case 5:
            class = [MyPostsViewController class];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:[[class alloc] init] animated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self typeClickHandler:indexPath.row];
    
//    if (indexPath.section == 2 && indexPath.row > 0)
//    {
//        PostsDetailViewController *view = [[PostsDetailViewController alloc] init];
//        [view setItemdata:postsArr[indexPath.row-1]];
//        [self.navigationController pushViewController:view animated:YES];
//    }
}

#pragma mark -- 与后台数据交互模块

/**
 *  获取BBS账号信息
 */
-(void)getUserFannum
{
    if (![SharedAppUtil defaultCommonUtil].userVO || [SharedAppUtil defaultCommonUtil].bbsVO == nil)
        return [self endrefleshData];
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
                                         
                                         [headView initWithName:infoVO.member_truename.length > 0 ? infoVO.member_truename : @"请完善资料" professional:personalInfo.grouptitle isfriend:personalInfo.is_home_friend is_mine:@"1"];
                                         
                                         [self.tableView reloadData];
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
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
    {
        personalInfo = nil;
        [postsArr removeAllObjects];
        [self.tableView reloadData];
        [self endrefleshData];
        return  [self.tableView.footer endRefreshing];
    }
    else if ([SharedAppUtil defaultCommonUtil].bbsVO == nil)
    {
        [self endrefleshData];
        return  [self.tableView.footer endRefreshing];
    }
    NSDictionary *paramDict = [[NSDictionary alloc] init];
    
    paramDict = @{@"uid" :[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                  @"client" : @"ios",
                  @"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                  @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                  @"page" : @"10"};
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_personallist parameters: paramDict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self endrefleshData];
                                     [self.tableView.footer endRefreshing];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)
                                     {
                                         if([codeNum integerValue] == 17001 && postsArr.count == 0)
                                         {
                                             return;
                                         }
                                         else if([codeNum integerValue] == 17001 && postsArr.count > 0)
                                         {
                                             return [NoticeHelper AlertShow:@"没有更多数据了" view:nil];
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
                                             //[self.view showNonedataTooltip];
                                         }else
                                         {
                                             currentPageIdx ++;
                                             [postsArr addObjectsFromArray:[arr copy]];
                                             
                                             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                                         }
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.footer endRefreshing];
                                     [self endrefleshData];
                                 }];
}

/**
 *  获取头像数据
 */
-(void)getDataProvider
{
    if (![SharedAppUtil defaultCommonUtil].userVO)
        return [self endrefleshData];
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
                                             
                                             [headView.userIcon sd_setImageWithURL:url placeholderImage:[UIImage imageWithName:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                 if (image) {
                                                     headView.userIcon.image = [image circleImage];
                                                 }
                                             }];
                                             
                                             [headView initWithName:infoVO.member_truename.length > 0 ? infoVO.member_truename : @"请完善资料" professional:personalInfo.grouptitle isfriend:personalInfo.is_home_friend is_mine:@"1"];
                                         }
                                         else
                                             [NoticeHelper AlertShow:@"个人资料为空!" view:self.view];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

/**
 *  获取个人的所有私信
 */
- (void)getAllPriletterList
{
    //判断是否登录
    if ([SharedAppUtil defaultCommonUtil].userVO == nil || [SharedAppUtil defaultCommonUtil].bbsVO == nil)
        return [self endrefleshData];
    
    NSDictionary *params = @{@"key":[SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                             @"client":@"ios",
                             @"p": @1,
                             @"page":@"10",};
    [CommonRemoteHelper RemoteWithUrl:URL_get_allpriletter parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        id codeNum = [dict objectForKey:@"code"];
        if([codeNum integerValue] > 0)
        {
            
        }
        else
        {
            NSString *msgNum = [dict objectForKey:@"allnew"];
            NSLog(@"有%@条未读私信",msgNum);
            [rightBtn0 initWithBadgeValue:msgNum];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"请求出错了" view:nil];
    }];
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
                [postsArr removeObjectAtIndex:selectedDeleteindexPath.row - 1];
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
