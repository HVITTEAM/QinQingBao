//
//  MyPostsViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 2016/11/16.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MyPostsViewController.h"
#import "PostsModel.h"
#import "BBSPersonalModel.h"
#import "CardCell.h"

#import "MyRelationViewController.h"
#import "PostsDetailViewController.h"
#import "YCXMenu.h"
#import "BHBPopView.h"

#import "CXComposeViewController.h"

@interface MyPostsViewController ()
{
    NSMutableArray *postsArr;
    
    BBSPersonalModel *personalInfo;
    
    // 当前第几页
    NSInteger currentPageIdx;
    
    PostsModel *selectedDeleteModel;
    
    NSIndexPath *selectedDeleteindexPath;
    
}
@property (nonatomic , strong) NSMutableArray *items;
@property (strong, nonatomic) UIImageView *postView;

@end

@implementation MyPostsViewController

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self setupRefresh];
    
    [self refleshData];
    
    self.title = @"我的帖子";
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
}


/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [rightBtn addTarget:self action:@selector(navgationHandler) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    self.postView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"post_icon"]];
    self.postView.frame = CGRectMake((MTScreenW - 50) / 2, MTScreenH - 160, 70, 70);
    self.postView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postAction)];
    recognizer.numberOfTapsRequired= 1;
    recognizer.numberOfTouchesRequired = 1;
    [self.postView addGestureRecognizer:recognizer];
    [self.view addSubview:self.postView];
}

#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
        _items = [@[[YCXMenuItem menuItem:@"我的关注"
                                    image:nil
                                      tag:100
                                 userInfo:nil],
                    [YCXMenuItem menuItem:@"我的粉丝"
                                    image:nil
                                      tag:101
                                 userInfo:nil],
                    ] mutableCopy];
    }
    
    return _items;
}

-(void)navgationHandler
{
    [YCXMenu setTintColor:[UIColor darkGrayColor]];
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow.rootViewController.view fromRect:CGRectMake(self.view.frame.size.width - 55, self.navigationController.navigationBar.height + 10, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        
        if (item.tag == 100)
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
        
    }];
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


/**
 * 刷新帖子数据
 */
-(void)refleshData
{
    currentPageIdx = 1;
    
    [postsArr removeAllObjects];
    
    [self getUserPosts];
    
    [self getUserFannum];
}

/**
 * 结束刷新帖子数据
 */
-(void)endrefleshData
{
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return postsArr && postsArr.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return postsArr.count + 1;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
        return 44;
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
    
    if (indexPath.row == 0)
    {
        UITableViewCell *commoncell = [tableView dequeueReusableCellWithIdentifier:@"ConmmonCell"];
        if (commoncell == nil)
            commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ConmmonCell"];
        commoncell.textLabel.text = [NSString stringWithFormat:@"我的帖子 %ld",(long)[personalInfo.count_article integerValue]];
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row > 0)
    {
        PostsDetailViewController *view = [[PostsDetailViewController alloc] init];
        [view setItemdata:postsArr[indexPath.row -1]];
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.postView.frame = CGRectMake((MTScreenW - 50) / 2, MTScreenH, 70, 70);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.postView.frame = CGRectMake((MTScreenW - 50) / 2, MTScreenH - 160, 70, 70);
    }];
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
                                             return [self.tableView initWithPlaceString:PlaceholderStr_Posts imgPath:@"placeholder-1"];
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
                                             
                                             [self.tableView reloadData];
                                         }
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.footer endRefreshing];
                                     [self endrefleshData];
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

@end
