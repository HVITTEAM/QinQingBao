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
    NSArray *postsArr;
    UILabel * titleLabel;
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
        [consumeCell setZan:[personalInfo.all_recommends integerValue] fansnum:[personalInfo.count_fans integerValue] attentionnum:[personalInfo.count_attention integerValue]];
        consumeCell.tapConsumeCellBtnCallback = ^(ProfileTopCell *consumeCell,NSUInteger idx){
            
            if ([SharedAppUtil checkLoginStates])
            {
                if (idx == 100)
                {
                    //                [NoticeHelper AlertShow:@"尚未开通,敬请期待！" view:nil];
                }
                else if (idx == 200)
                {
                    //                MyRelationViewController *view = [[MyRelationViewController alloc] init];
                    //                view.type = 1;
                    //                view.uid = [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id;
                    //                [self.navigationController pushViewController:view animated:YES];
                }
                else
                {
                    //                MyRelationViewController *view = [[MyRelationViewController alloc] init];
                    //                view.type = 2;
                    //                view.uid = [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Member_id;
                    //                [self.navigationController pushViewController:view animated:YES];
                }
            }
        };
        cell = consumeCell;
    }
    else if (indexPath.section == 1)
    {
        CardCell *cardCell = [CardCell createCellWithTableView:tableView];
        [cardCell setPostsModel:postsArr[indexPath.row]];
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
 *  获取发帖数据
 */
-(void)getUserPosts
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_personallist parameters: @{@"uid" :self.uid }
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
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
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
                                         [headView initWithName:personalInfo.author professional:personalInfo.grouptitle isfriend:personalInfo.is_home_friend];
                                         
                                         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
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
