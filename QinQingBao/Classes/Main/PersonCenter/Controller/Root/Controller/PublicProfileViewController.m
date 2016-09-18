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

#define headHeight 220

@interface PublicProfileViewController ()<UIScrollViewDelegate>
{
    UserInforModel *infoVO;
    NSString *iconUrl;
    
    NSArray *postsArr;
}

@property(nonatomic,strong)UIView *headView;

@end

@implementation PublicProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initHeadView];
    
    [self getUserPosts];
    
    self.view.backgroundColor = HMGlobalBg;
    self.navigationItem.title = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.contentInset = UIEdgeInsetsMake(headHeight, 0, 0, 0);
    
    if (self.headView)
        self.headView.frame = CGRectMake(0, -headHeight, MTScreenW, headHeight);
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
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
    
    headView.isUserata = YES;
    
    [self.tableView addSubview:self.headView];
    
    headView.navbtnClick = ^(NSInteger type){
        if (type == 1)
        {
            NSLog(@"关注");
        }
        else if (type == 2)
        {
            SendMsgViewController *view = [[SendMsgViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
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

/**
 *  获取发帖数据
 */
-(void)getUserPosts
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_followlist parameters: @{@"uid" : @"1"
                                                                       }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         postsArr = [PostsModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
    
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
        return postsArr.count;
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
        consumeCell.tapConsumeCellBtnCallback = ^(ProfileTopCell *consumeCell,NSUInteger idx){
            
            if ([SharedAppUtil defaultCommonUtil].userVO == nil)
                return   [MTNotificationCenter postNotificationName:MTNeedLogin object:nil userInfo:nil];
            
            if (idx == 100)
            {
                return;
            }
            else if (idx == 200)
            {
                return;
            }
            [NoticeHelper AlertShow:@"尚未开通,敬请期待！" view:nil];
        };
        cell = consumeCell;
    }
    else if (indexPath.section == 1)
    {
        CardCell *cardCell = [CardCell createCellWithTableView:tableView];
        [cardCell setItemdata:postsArr[indexPath.row]];
        cell = cardCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        PostsDetailViewController *view = [[PostsDetailViewController alloc] init];
        [view setItemdata:postsArr[indexPath.row]];
        [self.navigationController pushViewController:view animated:YES];
    }
}

#pragma mark - cellClick

-(void)typeClickHandler:(NSInteger)type
{
    
}

#pragma mark -- 与后台数据交互模块
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
                                             [headView.userIcon sd_setImageWithURL:url placeholderImage:[UIImage imageWithName:@"pc_user"]];
                                             
                                             [headView initWithName:infoVO.member_truename professional:@"认证专家"];
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
