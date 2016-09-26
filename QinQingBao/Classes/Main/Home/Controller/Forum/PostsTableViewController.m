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

@interface PostsTableViewController ()
{
    NSArray *postsArr;
    
    NSArray *recommendlist;
    
    NSArray *questiondata;
}
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
    if (self.type == BBSType_1)
    {
        [self getDataProvider];
        [self getRecommendlist];
        [self getUserPosts];
    }
    if (self.type == BBSType_2)
    {
        [self getFollowlist];
    }
    else if (self.type == BBSType_4)
    {
        [self getRecommendlist];
    }
    else
    {
        [self getUserPosts];
    }
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
}

/**
 *  获取帖子数据
 */
-(void)getUserPosts
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_flaglist parameters: @{@"flag" : [NSString stringWithFormat:@"%ld",(long)self.type] }
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.header endRefreshing];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         postsArr = [PostsModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         if (postsArr.count == 0)
                                             [self.tableView initWithPlaceString:PlaceholderStr_Posts imgPath:@"placeholder-2"];
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                     
                                 }];
}

/**
 *  获取关注人帖子数据
 */
-(void)getFollowlist
{
    if (![SharedAppUtil defaultCommonUtil].bbsVO) {
        return [self.tableView initWithPlaceString:PlaceholderStr_Login imgPath:@"placeholder-2"];
    }
    [CommonRemoteHelper RemoteWithUrl:URL_Get_followlist parameters: @{@"key" : [SharedAppUtil defaultCommonUtil].bbsVO.BBS_Key,
                                                                       @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.header endRefreshing];
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum integerValue] > 0)//如果返回的是NSString 说明有错误
                                     {
                                         if ([codeNum integerValue] == 17001) {
                                             return [self.tableView initWithPlaceString:PlaceholderStr_Attention imgPath:@"placeholder-2"];
                                         }
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         postsArr = [PostsModel objectArrayWithKeyValuesArray:[dict objectForKey:@"datas"]];
                                         if (postsArr.count == 0)
                                             [self.tableView initWithPlaceString:PlaceholderStr_Posts imgPath:@"placeholder-2"];
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.tableView.header endRefreshing];
                                     
                                 }];
}


/**
 *  获取说说和资讯数据
 */
-(void)getRecommendlist
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_recommendlist parameters: @{@"recommend" : self.type == BBSType_4 ? @"2" : @"3"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [self.tableView.header endRefreshing];
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
                                     
                                 }];
}

/**
 *  获取问卷数据
 */
-(void)getDataProvider
{
    [CommonRemoteHelper RemoteWithUrl:URL_Get_classlist parameters:nil type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if([dict[@"code"] integerValue] != 0){
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
            return;
        }
        questiondata = [[ClasslistModel objectArrayWithKeyValuesArray:dict[@"datas"]] mutableCopy];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type  == BBSType_1)
        return 3;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type  == BBSType_1)
    {
        switch (section)
        {
            case 0:
                return 3;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return postsArr.count;
                break;
            default:
                return  postsArr.count;
        }
    }
    else  if (self.type  == BBSType_4)
        return recommendlist.count;
    else
        return postsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.type  == BBSType_1)
        return 8;
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (self.type == BBSType_4 || self.type == BBSType_1)
    {
        if (indexPath.section == 0)
        {
            SiglePicCardCell *picCell = [SiglePicCardCell createCellWithTableView:tableView];
            [picCell setItemdata:recommendlist[indexPath.row]];
            
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
        else if (indexPath.section == 1)
        {
            QuestionCell *quecell = [QuestionCell createCellWithTableView:tableView];
            if (questiondata)
                quecell.dataProvider = questiondata;
            quecell.portraitClick = ^(ClasslistModel *itemData){
                
                // 问卷调查
                NSArray *exam_infoArray = itemData.exam_info;
                if (exam_infoArray.count == 1) {
                    SexViewController *vc = [[SexViewController alloc] init];
                    ClasslistExamInfoModel *examInfoModel = exam_infoArray[0];
                    vc.exam_id = examInfoModel.e_id;
                    vc.e_title = itemData.c_title;
                    vc.calculatype = examInfoModel.e_calculatype;
                    [self.parentVC.navigationController pushViewController:vc animated:YES];
                }else if(exam_infoArray.count> 1){
                    AllQuestionController *vc = [[AllQuestionController alloc] init];
                    vc.c_id = itemData.c_id;
                    [self.parentVC.navigationController pushViewController:vc animated:YES];
                }
            };
            
            cell = quecell;
        }
        else
        {
            CardCell *cardCell1 = [CardCell createCellWithTableView:tableView];
            [cardCell1 setPostsModel:postsArr[indexPath.row]];
            cell = cardCell1;
        }
    }
    else
    {
        CardCell *cardCell = [CardCell createCellWithTableView:tableView];
        [cardCell setPostsModel:postsArr[indexPath.row]];
        cell = cardCell;
    }
    
    if ([cell isKindOfClass:[CardCell class]])
    {
        CardCell *cardCell = (CardCell *)cell;
        
        cardCell.attentionBlock = ^(NSIndexPath *idx){
            [self attentionAction:idx];
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
    //    [view setItemdata:postsArr[indexPath.row]];
    [self.parentVC.navigationController pushViewController:view animated:YES];
}

/**
 *  加关注与取消关注，add是加关注，del是取消关注
 */
- (void)attentionAction:(NSIndexPath *)idx
{
    
}


@end
