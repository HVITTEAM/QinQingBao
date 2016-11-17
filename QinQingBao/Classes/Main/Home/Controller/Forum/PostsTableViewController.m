//
//  PostsTableViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/9/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PostsTableViewController.h"
#import "PostsDetailViewController.h"
#import "PublicProfileViewController.h"

#import "SexViewController.h"
#import "AllQuestionController.h"

#import "CardCell.h"
#import "PostsModel.h"
#import "QuestionCell.h"
#import "SiglePicCardCell.h"
#import "ClasslistModel.h"

#import "ScrollMenuTableCell.h"
#import "HomePicModel.h"
#import "LoopImageView.h"

@interface PostsTableViewController ()
{
    NSMutableArray *postsArr;
    
    NSArray *recommendlist;
    
    NSArray *questiondata;
    
    // 当前第几页
    NSInteger currentPageIdx;
    
    PostsModel *selectedDeleteModel;
}
@property (strong, nonatomic) NSArray *advDatas;     //轮播图数据
@end

@implementation PostsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 105, 0);
    
    [self setupRefresh];
    
    [self getData];
    
}

#pragma mark 集成刷新控件

-(void)getData
{
    [self.tableView removePlace];
    
    //获取问卷数据
    [self getDataProvider];
    [self getRecommendlist];
    [self getUserPosts];
    
    //获取轮播图片
    [self getAdvertisementpic];
    
    __weak typeof(self) weakSelf = self;
    //轮播图
    LoopImageView *loopView = [[LoopImageView alloc] init];
    loopView.bounds = CGRectMake(0, 0, MTScreenW, (int)(MTScreenW / 3));
    loopView.tapLoopImageCallBack= ^(NSInteger idx){
//        [weakSelf onClickImage:idx];
    };
    self.tableView.tableHeaderView = loopView;
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


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    currentPageIdx = 0;
    postsArr = [[NSMutableArray alloc] init];
    
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        currentPageIdx = 0;
        postsArr = [[NSMutableArray alloc] init];
        [self getData];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
}

/**
 *  获取帖子数据
 */
-(void)getUserPosts
{
    currentPageIdx ++;
    NSDictionary *paramDict = [[NSDictionary alloc] init];
    if ([SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key)
    {
        paramDict = @{@"flag" : @"1",
                      @"client" : @"ios",
                      @"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                      @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                      @"page" : @"10"};
    }
    else
    {
        paramDict = @{@"flag" : @"1",
                      @"client" : @"ios",
                      @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                      @"page" : @"10"};
    }
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_flaglist parameters: paramDict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.header endRefreshing];
                                     [self.tableView.footer endRefreshing];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         if([codeNum integerValue] == 17001 && postsArr.count == 0)
                                         {
                                             //                                             return [self.tableView initWithPlaceString:PlaceholderStr_Posts imgPath:@"placeholder-1"];
                                             return ;
                                         }
                                         else if([codeNum integerValue] == 17001 && postsArr.count > 0)
                                         {
                                             return;
                                             //                                             return [self.view showNonedataTooltip];
                                         }
                                         
                                         //                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         //                                         [alertView show];
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
                                         
                                         [self.tableView reloadData];
                                     }
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                     [self.tableView.footer endRefreshing];
                                     
                                 }];
}

/**
 *  获取关注人帖子数据
 */
-(void)getFollowlist
{
    if (![SharedAppUtil defaultCommonUtil].bbsVO) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
        return [self.tableView initWithPlaceString:PlaceholderStr_Login imgPath:@"placeholder-0"];
    }
    currentPageIdx ++;
    [CommonRemoteHelper RemoteWithUrl:URL_Get_followlist parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                                                                       @"client" : @"ios",
                                                                       @"p" : [NSString stringWithFormat:@"%li",(long)currentPageIdx],
                                                                       @"page" : @"10"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.header endRefreshing];
                                     [self.tableView.footer endRefreshing];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         if([codeNum integerValue] == 17001 && postsArr.count == 0)
                                         {
                                             return [self.tableView initWithPlaceString:PlaceholderStr_Attention imgPath:@"placeholder-1"];
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
                                         
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                     [self.tableView.header endRefreshing];
                                 }];
}

/**
 *  获取说说和资讯数据
 */
-(void)getRecommendlist
{
    NSMutableDictionary *params = [@{
                                     @"recommend" :  @"3"
                                     }mutableCopy];
    
    //    if (self.type == BBSType_1) {
    //        //        params[@"p_expert"] = @"1";
    //        //        params[@"page_expert"] = @"1000";
    //    }else{
    //        params[@"p_health"] = @"1";
    //        params[@"page_health"] = @"1000";
    //    }
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_recommendlist parameters: params
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.header endRefreshing];
                                     [self.tableView.footer endRefreshing];
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         recommendlist = [PostsModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                     [self.tableView.footer endRefreshing];
                                     
                                 }];
}

/**
 *  获取问卷调查数据
 */
-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_classlist parameters:nil type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if([dict[@"code"] integerValue] != 0){
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            return;
        }
        questiondata = [[ClasslistModel objectArrayWithKeyValuesArray:dict[@"datas"]] mutableCopy];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section)
    {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return postsArr.count;
            break;
        default:
            return  postsArr.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(indexPath.section == 0)
    //        return 60;
    if(indexPath.section == 0 && indexPath.row == 0)
        return 44;
    if(indexPath.section == 0)
        return (MTScreenW+30)/4;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?5:0.01;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 5;
    }else {
        return 10;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        UITableViewCell *commoncell = nil;
        if (indexPath.row == 0)
        {
            static NSString *cellId = @"titleCellId";
            commoncell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!commoncell) {
                commoncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                commoncell.selectionStyle = UITableViewCellSelectionStyleNone;
                commoncell.textLabel.font = [UIFont systemFontOfSize:16];
                commoncell.layoutMargins = UIEdgeInsetsZero;
            }
            commoncell.textLabel.text = @"健康话题";
            cell = commoncell;
        }
        else
        {
            ScrollMenuTableCell * menuCell = [ScrollMenuTableCell createCellWithTableView:tableView];
            menuCell.row = 1;
            menuCell.col = 4;
            menuCell.colSpace = 30;
            
            menuCell.margin = UIEdgeInsetsMake(10, 10, 10, 10);
            menuCell.shouldShowIndicator = NO;
            menuCell.datas = @[@{KScrollMenuTitle:@"心脑血管",KScrollMenuImg:@"xnxg_icon"},
                               @{KScrollMenuTitle:@"精英压力",KScrollMenuImg:@"jyyl_icon"},
                               @{KScrollMenuTitle:@"肝脏排毒",KScrollMenuImg:@"gzpd_icon"},
                               @{KScrollMenuTitle:@"其他",KScrollMenuImg:@"qt_icon"}
                               ];
            cell = menuCell;
        }
        
    }
    else
    {
        if (indexPath.section < 3)
        {
            SiglePicCardCell *picCell = [SiglePicCardCell createCellWithTableView:tableView];
            [picCell setItemdata:recommendlist[indexPath.section]];
            // 头像点击 进入个人信息界面
            picCell.portraitClick = ^(PostsModel *item)
            {
                PublicProfileViewController *view = [[PublicProfileViewController alloc] init];
                view.hidesBottomBarWhenPushed = YES;
                view.uid = item.authorid;
                [self.parentVC.navigationController pushViewController:view animated:YES];
            };
            
            cell = picCell;
        }
        else
        {
            CardCell *cardCell1 = [CardCell createCellWithTableView:tableView];
            if (postsArr.count > 0)
                [cardCell1 setPostsModel:postsArr[indexPath.row]];
            cell = cardCell1;
        }
    }
    
    if ([cell isKindOfClass:[CardCell class]])
    {
        CardCell *cardCell = (CardCell *)cell;
        
        cardCell.attentionBlock = ^(PostsModel *model){
            [self attentionAction:model];
        };
        // 头像点击 进入个人信息界面
        cardCell.portraitClick = ^(PostsModel *item)
        {
            PublicProfileViewController *view = [[PublicProfileViewController alloc] init];
            view.hidesBottomBarWhenPushed = YES;
            view.uid = item.authorid;
            [self.parentVC.navigationController pushViewController:view animated:YES];
        };
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostsDetailViewController *view = [[PostsDetailViewController alloc] init];
    if ((indexPath.section < 3) )
    {
        if(!recommendlist || recommendlist.count==0)return;
        [view setItemdata:recommendlist[indexPath.section]];
    }
    //    else  if ( self.type == BBSType_4)
    //    {
    //        if(!recommendlist || recommendlist.count==0)return;
    //        [view setItemdata:recommendlist[indexPath.row]];
    //    }
    else
    {
        if(!postsArr || postsArr.count==0)return;
        [view setItemdata:postsArr[indexPath.row]];
    }
    [self.parentVC.navigationController pushViewController:view animated:YES];
}


/**
 *  加关注与取消关注，add是加关注，del是取消关注
 */
- (void)attentionAction:(PostsModel *)model
{
    if ([SharedAppUtil checkLoginStates])
    {
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
                [self getData];
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
