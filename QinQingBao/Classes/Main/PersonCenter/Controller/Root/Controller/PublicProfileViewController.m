//
//  PublicProfileViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/11.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PublicProfileViewController.h"

#import "PrivateProfileViewController.h"
#import "LoginInHeadView.h"

#import "ProfileTopCell.h"
#import "CollectTypeCell.h"

#import "PostsModel.h"

#import "SendMsgViewController.h"

#import "PostsDetailViewController.h"

#import "CardCell.h"

#import "BBSPersonalModel.h"


#define headHeight MTScreenH*0.3

@interface PublicProfileViewController ()<UIScrollViewDelegate>
{
    BBSPersonalModel *personalInfo;
    
    NSMutableArray *postsArr;

    UILabel * titleLabel;
    
    // 当前第几页
    NSInteger currentPageIdx;
}

@property(nonatomic,strong)UIView *headView;

@end

@implementation PublicProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initHeadView];
    
    [self setupRefresh];
    
    [self getUserPosts];
    
    self.view.backgroundColor = HMGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.contentInset = UIEdgeInsetsMake(headHeight, 0, 0, 0);
    
    if (self.headView)
        self.headView.frame = CGRectMake(0, -headHeight - 20, MTScreenW, headHeight);
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self updateViewConstraints];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getDataProvider];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
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
    
    LoginInHeadView *headView = (LoginInHeadView *)self.headView;
    
    [self.tableView addSubview:self.headView];
    
    headView.navbtnClick = ^(NSInteger type){
        if ([SharedAppUtil checkLoginStates])
        {
            if (type == 0)
            {
                [self relationOperateWithID:self.uid type:type];
            }
            else if (type == 1)
            {
                [self relationOperateWithID:self.uid type:type];
            }
            else if (type == 2)
            {
                SendMsgViewController *view = [[SendMsgViewController alloc] init];
                view.authorid = self.uid;
                view.otherInfo = personalInfo;
                [self.navigationController pushViewController:view animated:YES];
            }
        }
    };
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}


#pragma mark 导航栏点击

-(void)navgationHandler:(UIButton *)sender
{
    
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
    titleLabel.text = personalInfo.author;
    titleLabel.alpha = alpha;
    //    self.navigationItem.titleView = titleLabel;
    
    UIImage *img = [UIImage imageWithColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
        return 1;
    else
        return postsArr.count + 1;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 60;
    }
    
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
        cell = consumeCell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"ConmmonCell"];
            if (commoncell == nil)
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ConmmonCell"];
            commoncell.textLabel.text = [NSString stringWithFormat:@"%ld 帖子",(long)[personalInfo.count_article integerValue]];
            commoncell.textLabel.font = [UIFont systemFontOfSize:15];
            commoncell.textLabel.textColor = [UIColor colorWithRGB:@"666666"];
            cell = commoncell;
        }
        else
        {
            CardCell *cardCell = [CardCell createCellWithTableView:tableView];
            [cardCell setPostsModel:postsArr[indexPath.row - 1]];
            cardCell.attentionBtn.hidden = YES;
            cell = cardCell;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        PostsDetailViewController *view = [[PostsDetailViewController alloc] init];
        [view setItemdata:postsArr[indexPath.row -1]];
        [self.navigationController pushViewController:view animated:YES];
    }
}

#pragma mark - cellClick

-(void)typeClickHandler:(NSInteger)type
{
    
}

#pragma mark -- 与后台数据交互模块

/**
 *  获取发帖数据
 */
-(void)getUserPosts
{
    currentPageIdx ++;
    NSDictionary *paramDict = [[NSDictionary alloc] init];
    if ([SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key)
    {
        paramDict = @{@"uid" : self.uid,
                      @"client" : @"ios",
                      @"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                      @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                      @"page" : @"10"};
    }
    else
    {
        paramDict = @{@"uid" : self.uid,
                      @"client" : @"ios",
                      @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                      @"page" : @"10"};
    }
    [CommonRemoteHelper RemoteWithUrl:URL_Get_personallist parameters: paramDict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.footer endRefreshing];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         if([codeNum integerValue] == 17001 && postsArr.count == 0)
                                         {
                                             return [NoticeHelper AlertShow:@"TA还没有发帖" view:nil];
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
                                             CX_Log(@"没有发帖数据");
                                         }
                                         else if (arr.count == 0 && currentPageIdx > 1)
                                         {
                                             currentPageIdx --;
                                             [self.view showNonedataTooltip];
                                         }
                                       
                                         [postsArr addObjectsFromArray:[arr copy]];

                                         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.footer endRefreshing];

                                 }];
    
}


/**
 *  获取个人信息数据
 */
-(void)getDataProvider
{
    NSDictionary *paramDict = [[NSDictionary alloc] init];
    if ([SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key)
    {
        paramDict = @{@"uid" : self.uid,
                      @"client" : @"ios",
                      @"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key};
    }
    else
    {
        paramDict = @{@"uid" : self.uid};
    }
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_personaldetail parameters: paramDict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         personalInfo = [BBSPersonalModel objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         
                                         LoginInHeadView *headView = (LoginInHeadView *)self.headView;
                                         NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Icon,personalInfo.avatar]];
                                         [headView.userIcon sd_setImageWithURL:url placeholderImage:[UIImage imageWithName:@"pc_user"]];
                                         [headView initWithName:personalInfo.author professional:personalInfo.grouptitle isfriend:personalInfo.is_home_friend is_mine:personalInfo.is_mine];
                                         
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}

/**
 *  加关注与取消关注
 * targetUId 操作的目标id type 0删除 1添加
 */
-(void)relationOperateWithID:(NSString *)targetUId type:(NSInteger)type
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_attention_do parameters: @{@"action" : type == 1 ? @"add" : @"del",
                                                                         @"uid" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id,
                                                                         @"rel" : targetUId,
                                                                         @"client" : @"ios",
                                                                         @"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [HUD removeFromSuperview];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         [NoticeHelper AlertShow:@"操作成功" view:nil];
                                         [self getDataProvider];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
}


@end
